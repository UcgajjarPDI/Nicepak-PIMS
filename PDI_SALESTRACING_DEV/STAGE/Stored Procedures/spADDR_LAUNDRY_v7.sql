CREATE PROCEDURE [STAGE].[spADDR_LAUNDRY_v7] 
WITH EXEC AS CALLER
AS
BEGIN  

 -------------   START ----------
/*
    --------------  STA_CD  --------------------- 
     STATS_CD = 0, pending or not touched
     STATS_CD = 1, okay, quality passed
     STAT_CD = -1, NULL
     STAT_CD = 9 -- being worked on, in process
     STAT_CD = -9 -- INVALID
    -------------------------------------------- 
    */
  
    -- - First take out spaacial charcater, extra spaces, keep #, because that could be Unit 
    UPDATE MDM_STAGE.TEMP_ADDR SET WB_1 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR_1))
    WHERE ADDR_1 IS NOT NULL;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET WB_2 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR_2))
    WHERE ADDR_2 IS NOT NULL;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET WB_1 = WB_2, WB_2 =NULL
    WHERE  WB_1  IS NULL AND WB_2 IS NOT NULL;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
    STAT_1_CD = CASE WHEN WB_1 IS NULL THEN -1 ELSE 0 END, 
    STAT_2_CD = CASE WHEN WB_2 IS NULL THEN -1 ELSE 0 END;
    -- 2 min 13 sec
    

  ----------------------------    S T A G E   1   ------------------------------------
  
    -- TAKE OUT DIRECTION to run the same exercise
    UPDATE  C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      WB_1 = STAGE.fnGet_FirstPart(WB_1,LEN(WB_1)-LEN(A.ADDR_VAR))
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN);
    -- 25 sec - 206K

    -- STEP - 5
    -- If first word is numeric, and last word is a roadway, mark it as good record stat_cd = 100
    UPDATE  C 
      SET STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN ( SELECT DISTINCT ADDR_STD FROM REF.ADDR_STD WHERE CAT IN ('Roadway','Location')) A 
        ON STAGE.fnLastWord(WB_1) = A.ADDR_STD 
    WHERE 
      ISNUMERIC(STAGE.fnFirstWord(WB_1)) = 1
    OPTION (MERGE JOIN) ;
    --  1 MIN 15 SEC sec -- 2.6  million  
    
    -- get rid of the following - did not save any time 
    /*
  TRUNCATE TABLE MDM_STAGE.TEMP_ADDR_PARTS;
    
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR,ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
      STAGE.fnFirstWord(WB_1),
      STAGE.fnMiddlePart(WB_1,STAGE.fnFirstWord(WB_1),STAGE.fnLastWord(WB_1) ),
      STAGE.fnLastWord(WB_1), 
       BLDG_NR, FL_NR, STE_NR,
      DIR_2
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 AND STAT_2_CD = -1; -- (-1 means null values)
    -- 2:45 min 1.9 million
    
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD = -1; */
    
    ----------- GET THE SUITE NUMBERS --------------------------
    -- we will do this again for smaller set of records 
    -- after large chunk is removed to Addr_parts 
    UPDATE  C SET
      C.STE_NR = REPLACE(STAGE.fnLastWord(WB_2),'#',''),
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE --C.STAT_2_CD = 0 AND
    WB_2 IS NOT NULL 
    AND stage.fnwordcount(WB_2) = 2
    OPTION(MERGE JOIN); 
    -- 24 sec - 545 K
    
    -- BUILDING NUMBERS
    UPDATE  C SET
      C.BLDG_NR = STAGE.fnLastWord(WB_2),
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    WHERE --C.STAT_2_CD = 0 AND
    WB_2 IS NOT NULL 
    AND stage.fnwordcount(WB_2) = 2
    OPTION(MERGE JOIN); 
    -- 5 sec, 6.2k
    
    -- FLOOR NUMBERS
    UPDATE  C SET
      C.FL_NR = STAGE.fnLastWord(ADDR_STD),
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_2 = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE --C.STAT_2_CD = 0 AND
    WB_2 IS NOT NULL 
    AND stage.fnwordcount(WB_2) = 2
    OPTION(MERGE JOIN); 
    -- Sec 4 sec, 18 K
    
    
    -- Only when Address line is verified then address 2 could be okay with null value
    --UPDATE MDM_STAGE.TEMP_ADDR SET
    --  STAT_2_CD = 1
    --WHERE WB_2  IS NULL AND STAT_1_CD = 1 
    -- 5 sec, 1.96 million
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_2_CD = 0 WHERE LEN(STE_NR) > 9;
    
    
    -- GET RID OF this big chunk of records
   TRUNCATE TABLE MDM_STAGE.TEMP_ADDR_PARTS;
    
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR,ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
      STAGE.fnFirstWord(WB_1),
      STAGE.fnMiddlePart(WB_1,STAGE.fnFirstWord(WB_1),STAGE.fnLastWord(WB_1) ),
      STAGE.fnLastWord(WB_1), 
       BLDG_NR, FL_NR, STE_NR,
      DIR_2
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 AND STAT_2_CD IN (-1,1);
  -- 3.5 MIN, 2.5 miullion
  
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD IN (-1,1);
  -- 5 SEC
  
  ----------------------------    S T A G E   2   ------------------------------------
  
  ----------------------------------
  -- ADDR 1 is just like ADDR 2
  -- SWITCH
  -----------------------------------
  
  -- SUITE NUMBERS --
   UPDATE  C SET
      C.STE_NR = CASE WHEN STE_NR IS NULL THEN STAGE.fnLastWord(WB_1) END,
      C.WB_1 = WB_2,
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE WB_1 IS NOT NULL 
    AND stage.fnwordcount(WB_1) = 2
    OPTION(MERGE JOIN); 
    -- 10 sec -  175
    
    -- BUILDING NUMBERS
    UPDATE  C SET
      C.BLDG_NR = CASE WHEN BLDG_NR IS NULL THEN STAGE.fnLastWord(WB_1) END,
      C.WB_1 = WB_2,
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR 
    AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    WHERE WB_1 IS NOT NULL 
    AND stage.fnwordcount(WB_1) = 2
    OPTION(MERGE JOIN); 
    -- 10 sec -  89 rec
    
    -- FLOOR NUMBERS
    UPDATE  C SET
      C.FL_NR = CASE WHEN  C.FL_NR IS NULL THEN STAGE.fnLastWord(ADDR_STD) END ,
      C.WB_1 = WB_2,
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_1 = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE WB_1 IS NOT NULL 
    AND stage.fnwordcount(WB_1) = 2
    OPTION(MERGE JOIN); 
    -- 10 sec - 1 rec
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
    WB_2 = NULL WHERE WB_1 = WB_2;
    
  ---------------------------------------------
  -- LAST WORD IS STE , IT MIGHT BE A MISTAKE IF WE TOOK STE S OR N AS DIRECTION--
  -- This will fix it --
  -----------------------------------------------
    
  UPDATE C SET
    C.STE_NR  = CASE WHEN DIR_2 IS NOT NULL THEN DIR_2 ELSE STE_NR END,      
    C.DIR_2 = NULL,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR)))
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1)  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
  WHERE WB_1 IS NOT NULL 
  --AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 7 SEC, 3K   
    
    
    ---------------------------------------------
  -- Last 2 words are suite, builing or floor --
  -----------------------------------------------
  UPDATE C SET
    C.STE_NR  = STAGE.fnLastWord(WB_1),      
    C.STAT_1_CD = 9,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 28 SEC, 312K

 
  UPDATE C SET
    C.BLDG_NR  = STAGE.fnLastWord(WB_1),      
    C.STAT_1_CD = 9,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 9 SEC, 6.2 K
  
  UPDATE C SET
    C.FL_NR  = STAGE.fnLastWord(ADDR_STD),
    C.STAT_1_CD = 9,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR)) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))) +' '+STAGE.fnLastWord(WB_1) = A.ADDR_VAR 
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 11 SEC 11K
  
  -------------------------------------------------------------------------
 --      select top 1000 ADDR_1, ADDR_2, WB_1, wb_2, STE_NR, BLDG_NR, FL_NR from MDM_STAGE.TEMP_ADDR where STAT_1_CD = 92
  --- ONE MORE TIME
  
  UPDATE C SET
    C.STE_NR  = STAGE.fnLastWord(WB_1), 
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) ),
    C.STAT_1_CD = 92
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND C.STAT_1_CD = 9
  AND STE_NR IS NOT NULL
  OPTION (MERGE JOIN);
  --9 sec - 16

 
  UPDATE C SET
    C.BLDG_NR  = STAGE.fnLastWord(WB_1),      
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) ),
     C.STAT_1_CD = 93
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  OPTION (MERGE JOIN);
  -- 8 SEC, 228 K
  
  UPDATE C SET
    C.FL_NR  = STAGE.fnLastWord(ADDR_STD),  
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR)) ),
    C.STAT_1_CD = 94
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))) +' '+STAGE.fnLastWord(WB_1) = A.ADDR_VAR 
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 9
  OPTION (MERGE JOIN);
  
  --RESET STATUS CODE
  UPDATE MDM_STAGE.TEMP_ADDR SET STAT_1_CD = 0 WHERE STAT_1_CD > 1;
  
  ------------------------------------------------------------------
 -- Before starting to deal with #, let's add highway indicator to have 
 -- Highway excluded from this 
 ----------------------------------------------------------------------
   UPDATE  C SET
      HWY_IN = 'Y'
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON WB_1 LIKE '% '+A.ADDR_VAR+'%' 
      AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAT_1_CD = 0;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET HWY_IN = 'N' WHERE HWY_IN <>'Y';
 
  
  -----------  suite orbuild number after # --------
      -- SUITE NUMBER IS #303 - with no gap
      
  UPDATE MDM_STAGE.TEMP_ADDR SET
    STE_NR = case when STE_NR IS NULL THEN STAGE.fnGet_Num(STAGE.fnLastWord(WB_1)) ELSE STE_NR END,
    BLDG_NR = case when STE_NR IS NOT NULL AND BLDG_NR IS NULL THEN STAGE.fnGet_Num(STAGE.fnLastWord(WB_1)) ELSE BLDG_NR END,
    WC_2 = case when STE_NR IS NOT NULL AND BLDG_NR IS NOT NULL THEN STAGE.fnGet_Num(STAGE.fnLastWord(WB_1)) END,
    WB_1 = STAGE.fnGet_FirstPart(WB_1, LEN(WB_1)-LEN(STAGE.fnLastWord(WB_1))),
    STAT_1_CD = 9
  WHERE   STAGE.fnLastWord(WB_1) LIKE '#%' 
  AND stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  AND HWY_IN = 'N';
  -- 27 SEC 4K
  
     -- SUITE NUMBER IS # 303 - with a space
  UPDATE MDM_STAGE.TEMP_ADDR SET
    BLDG_NR = case when STE_NR IS NOT NULL AND BLDG_NR IS NULL THEN STAGE.fnLastWord(WB_1) ELSE BLDG_NR END,
    STE_NR = case when STE_NR IS NULL THEN STAGE.fnLastWord(WB_1) ELSE STE_NR END,
    WC_2 =  STAGE.fnLastWord(WB_1),
    WB_1 = rtrim(STAGE.fnGet_FirstPart(WB_1, STAGE.fn_LastIndexOf(WB_1,'#')-1)),
    STAT_1_CD = 92
  WHERE   STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = '#' 
  AND stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  AND HWY_IN = 'N';
  -- 9 SEC, 22K
  
  UPDATE MDM_STAGE.TEMP_ADDR SET STAT_1_CD = 0 WHERE STAT_1_CD > 1;
      
  ------------------------------------------------------
  -- DIRECTION FROM END
  --- So that if last word is a roadway, we can grab it
  ------------------------------------------------------
    UPDATE  C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      WB_1 = STAGE.fnGet_FirstPart(WB_1,LEN(WB_1)-LEN(A.ADDR_VAR)),
      STAT_1_CD = 9  -- for chacking any error from this line
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
   -- WHERE STAT_1_CD = 9
    OPTION (MERGE JOIN);
    -- 3 SEC 24K
    
    -- Fix any potential issue with direction -- 
  UPDATE C SET
    C.STE_NR  = CASE WHEN DIR_2 IS NOT NULL THEN DIR_2 ELSE STE_NR END,      
    C.DIR_2 = NULL,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR))),
    STAT_1_CD = 92
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1)  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' --AND A.SUB_CAT = 'SUITE'
  WHERE WB_1 IS NOT NULL 
  AND STAT_1_CD = 9
  OPTION (MERGE JOIN);  
  
    UPDATE MDM_STAGE.TEMP_ADDR SET     STAT_1_CD = 0 WHERE STAT_1_CD > 8; 

    -- IF THE WORD BEFORE WAS SUITE OR BUILDING OR # -- THEN IT WAS NOT a dir
    
    

    --------------- bookmark  ---------------
    
    -- AGAIN TAKE THE COMPLETELY GOOD ONES OUT
    /*
    UPDATE  C 
      SET STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN ( SELECT DISTINCT ADDR_STD FROM REF.ADDR_STD WHERE CAT IN ('Roadway','Location')) A 
        ON STAGE.fnLastWord(WB_1) = A.ADDR_STD 
    WHERE 
      ISNUMERIC(STAGE.fnFirstWord(WB_1)) = 1
      AND STAT_1_CD = 9
    OPTION (MERGE JOIN) ;
  -- 9 SEC, 303k
  
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_2_CD = 1
    WHERE WB_2  IS NULL AND STAT_1_CD = 1 ;
    -- 1 SEC 298K
  
      UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_2_CD = 0 WHERE LEN(STE_NR) > 9;
 
  -- move second chunk of god records
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR,ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
      STAGE.fnFirstWord(WB_1),
      STAGE.fnMiddlePart(WB_1,STAGE.fnFirstWord(WB_1),STAGE.fnLastWord(WB_1) ),
      STAGE.fnLastWord(WB_1), 
       BLDG_NR, FL_NR, STE_NR,
      DIR_2
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 AND STAT_2_CD = 1;
  -- 25 sec, 297K
  
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD = 1;
  -- 5 SEC
*/
----------------------------    S T A G E   3   ------------------------------------

    --------------------------------------------
    -- BREAK APART STREET ADDRESSS -----
    ----------------------------------------------
    -- CHECK STAT_1_CD STATUS
    --select stat_1_cd, count(*) from MDM_STAGE.TEMP_ADDR group by stat_1_cd
    
  UPDATE MDM_STAGE.TEMP_ADDR SET
    ST_NR = STAGE.fnFirstWord(WB_1),
    ST_NM = STAGE.fnSecondPart(WB_1, LEN(STAGE.fnFirstWord(WB_1))+1)
  WHERE ISNUMERIC(LEFT(WB_1,1)) = 1 --AND ST_NM IS NULL
  ;
  -- 

    
    
   --- Now Take the DIRECTION 
    
   UPDATE  C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      ST_NM = STAGE.fnGet_FirstPart(ST_NM,LEN(ST_NM)-LEN(A.ADDR_VAR)),
      STAT_1_CD = 111
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ST_NM) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    AND STAT_1_CD = 0
    OPTION (MERGE JOIN);
    -- 5 sec  38 ROWS  
   --     UPDATE MDM_STAGE.TEMP_ADDR SET     STAT_1_CD = 0 WHERE STAT_1_CD=111;
   
   
  -- Take ROADWAY VAR as last word out
  -- MARK THE GOOD RECORDS 
  UPDATE  C SET
      ST_TYP = A. ADDR_STD,
      ST_NM = STAGE.fnGet_FirstPart(ST_NM,LEN(ST_NM)-LEN(A.ADDR_VAR)),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ST_NM) = A.ADDR_VAR 
          AND CAT IN ('Roadway','Location')
    WHERE STAT_1_CD = 0
    OPTION (MERGE JOIN) ;
    -- 15 SEC 483k record

    
    ------------------------------------
    ---  HIGHWAY (A LITTLE TRICKY) -- 
    ------------------------------------
    -- check if there is any stats_1_cd 9 is left - should not be any
    -- Take the last two words out first
    
    ----------------- SIMPLE CASE WHEN SECOND LAST WORD IS HWY
    UPDATE  C SET
       C.WC_1 = STAGE.fnLastWord(ST_NM),
       C.ST_TYP = ADDR_STD , -- STAGE.fnLastWord(LEFT(ST_NM,LEN(ST_NM)- LEN(STAGE.fnLastWord(ST_NM)))), 
       ST_NM = STAGE.fnGet_FirstPart(ST_NM, stage.fn_LastIndexOf(ST_NM,A.ADDR_VAR)-1),
       STAT_1_CD = 90
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON STAGE.fnLastWord(LEFT(ST_NM,LEN(ST_NM)- LEN(STAGE.fnLastWord(ST_NM)))) = A.ADDR_VAR 
      AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAT_1_CD = 0
    AND HWY_IN = 'Y'
    AND STAGE.fnWordCount(ST_NM)>1
    OPTION(MERGE JOIN);  
    -- 4 SEC -- 56K
    
     -- COUNTY OR STATE ROAD -- 
    UPDATE  C SET
       C.WC_1 = STAGE.fnLastWord(ST_NM),
       C.ST_TYP ='RD' ,
       ST_NM = STAGE.fnGet_FirstPart(ST_NM, stage.fn_LastIndexOf(ST_NM,A.ADDR_VAR)-1),
       STAT_1_CD = 91
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON STAGE.fnLastWord(LEFT(ST_NM,LEN(ST_NM)- LEN(STAGE.fnLastWord(ST_NM)))) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'ROAD'
    WHERE STAT_1_CD = 0 AND
    STAGE.fnWordCount(ST_NM)>1
    AND (ST_NM LIKE '%COUNTY %' OR ST_NM LIKE '%STATE %' OR ST_NM LIKE '%US %')
    OPTION(MERGE JOIN); 
    -- 1 SEC - 7.3K
    
    -- MARK THE GOOD ONES, RESET FLAG
    UPDATE MDM_STAGE.TEMP_ADDR SET
    ST_NM = ISNULL(ST_NM,'')+' '+ST_TYP+' '+WC_1,
    WC_1 = NULL, ST_TYP = NULL,
    STAT_1_CD = 1
    WHERE STAT_1_CD > 89;

    -- CHECK --- select stat_1_cd, count(*) from MDM_STAGE.TEMP_ADDR group by stat_1_cd
    -- 157K LEFT

    ------------------------------------------
    -- HIGHWAY IN THE MIDDLE
    ----------------------------------------
    
    UPDATE  C SET
       C.ST_TYP = A.ADDR_STD,
       ST_NM = STAGE.fnGet_FirstPart(ST_NM, stage.fn_LastIndexOf(ST_NM,A.ADDR_VAR)-1),
       WC_1 = STAGE.fnSecondPart(ST_NM, stage.fn_LastIndexOf(ST_NM,A.ADDR_VAR)+LEN(ADDR_VAR)+1 ),
       STAT_1_CD = 91
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON ST_NM LIKE '% '+A.ADDR_VAR+' %'
          AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAT_1_CD = 0
    AND HWY_IN = 'Y'
    AND STAGE.fnWordCount(ST_NM)>1
    --OPTION(MERGE JOIN)
    ;  
    -- 12 sec - 1.7 k
    
    -- WHEN ST_NM IS US OR STATE, TAKE FIRST NUMERIC FROM WC_1 AND ADJUST WC_1 --
    

    UPDATE  C SET
      DIR_1 = A.ADDR_STD, 
      ST_NM = STAGE.fnSecondPart(ST_NM,LEN(STAGE.fnFirstWord(ST_NM))+1),
      STAT_1_CD = 101
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(ST_NM) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    AND STAT_1_CD = 91
    OPTION (MERGE JOIN);
    -- 25 sec    
    
    -- WC_1 HAS THE POTENTIAL HIGHNAME IN IT --
    -- REMOVE PRECEDDING # TO BE ABLE TO USE IT --
    UPDATE MDM_STAGE.TEMP_ADDR SET
    WC_1 = LTRIM(REPLACE(WC_1,'#',''))
    WHERE LEFT(LTRIM(WC_1),1) = '#'
    AND STAT_1_CD = 91
    
    -- US, STATYE O COUNTY HIGHWAY
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NM = ST_NM + ' '+ST_TYP+' '+STAGE.fnFirstWord(WC_1),
      WC_1 = STAGE.fnSECONDPART(WC_1,LEN(STAGE.fnFirstWord(WC_1))+1),
      WC_2 = REPLACE(STAGE.fnSECONDPART(WC_1,LEN(STAGE.fnFirstWord(WC_1))+1),'#','')
      ,stat_1_cd = 92
    WHERE LTRIM(RTRIM(ST_NM)) IN ('US','STATE','COUNTY','CNTY','ST')
    AND stat_1_cd = 91;
    -- 1 SEC, 226 RECORD
    
    -- STATE NAME HIGHWAY
    UPDATE T SET
      ST_NM = ST_NM + ' '+T.ST_TYP+' '+STAGE.fnFirstWord(WC_1),
      WC_1 = STAGE.fnSECONDPART(WC_1,LEN(STAGE.fnFirstWord(WC_1))+1)
      ,stat_1_cd = 93
    FROM  MDM_STAGE.TEMP_ADDR T
    JOIN REF.STATE_LIST S ON T.ST_NM = S.ST AND S.ST_TYP = 'State'
    WHERE stat_1_cd = 91;
    -- 1 SEC 19 RECORD
    
    -- NO STATE NAME
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NM = ST_NM + ' '+ST_TYP, --+' '+STAGE.fnFirstWord(WC_1),
      st_typ = null
      ,stat_1_cd = 94
    WHERE len(LTRIM(RTRIM(ST_NM))) > 1
    AND stat_1_cd = 91;
    -- 1 SEC 788 REC
    
    ---- Taking direction from front
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR_2 = CASE WHEN WC_1 IS NULL THEN len(LTRIM(RTRIM(ST_NM))) ELSE ST_NR_2  END,
      st_NM = CASE WHEN WC_1 IS NULL THEN ST_NM+' '+ST_TYP ELSE ST_TYP+ ' '+STAGE.fnFirstWord(WC_1) END
      ,stat_1_cd = 95
    WHERE len(LTRIM(RTRIM(ST_NM))) = 1
    AND LTRIM(RTRIM(ST_NM)) NOT IN ('N','E','S','W')
    AND stat_1_cd = 91;
    -- 13 sec - 4 rows
    
    -- There is no name other than highway and then take first word of WC_1
    UPDATE MDM_STAGE.TEMP_ADDR SET
      st_NM = ST_TYP+' '+STAGE.fnFirstWord(wc_1)
      ,WC_1= STAGE.fnSecondPart(WC_1,LEN(STAGE.fnFirstWord(wc_1))+1)
      ,stat_1_cd = 96
    WHERE ST_NM IS NULL AND WC_1 IS NOT NULL 
    AND stat_1_cd = 91;
    -- zero record
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      st_NM = CASE
       WHEN DIR_1='N' THEN 'NORTH '+ST_TYP 
       WHEN DIR_1='S' THEN 'SOUTH '+ST_TYP 
       WHEN DIR_1='E' THEN 'EAST '+ST_TYP 
       WHEN DIR_1='W' THEN 'WEST '+ST_TYP 
       WHEN DIR_1='NE' THEN 'NORTHEAST '+ST_TYP 
       WHEN DIR_1='SE' THEN 'SOUTHEAST '+ST_TYP 
       WHEN DIR_1='NW' THEN 'NORTHWEST '+ST_TYP 
       WHEN DIR_1='SW' THEN 'SOUTHWEST '+ST_TYP  END
      ,DIR_1=NULL
      ,stat_1_cd = 97
    WHERE ST_NM IS NULL AND WC_1 IS NULL AND DIR_1 IS NOT NULL
    AND stat_1_cd = 91;
    -- no record
    
      -- SUITE NUMBERS --
   UPDATE  C SET
      C.STE_NR = CASE WHEN STE_NR IS NULL THEN STAGE.fnNextWord(WC_1, A.ADDR_VAR) ELSE STE_NR  END,
      WC_1 = NULL,
      STAT_1_CD = 98
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WC_1) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE WC_1 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 10 sec -  175
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
    WC_1 = NULL, WC_2 = NULL,
    STAT_1_CD = 1
    WHERE STAT_1_CD > 89;
    -- 24 SEC 287 RECORD
    
    ---------------------------------------------------------------------------------------------------------
   
    --------------------------------------------------------------------------------------------------------
   
    /*
    -- IF THERE IS # or NR before highway number
    UPDATE  C SET
       C.LW_1 = LTRIM(RTRIM(STAGE.fnSecondPart(ST_NM, charindex(ADDR_VAR,ST_NM)+LEN(A.ADDR_VAR)))),
       C.LW_2 = LTRIM(RTRIM(A.ADDR_VAR)),
       STAT_1_CD = 8
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON ST_NM LIKE '% '+A.ADDR_VAR +' %'  AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAT_1_CD = 0
    AND STAGE.fnWordCount(ST_NM)>1;  
      
      
    -- If there are more than two words extract st_nm, otherwise st name remains null
    -- TEST -- NMAY NOT NEED IT
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NM = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1) - LEN(LW_2+' '+LW_1)-1))
    WHERE STAGE.fnWordCount(WB_1)>2
    AND STAT_1_CD IN (8,9)
    
    -- Now stdandardize the highway name
    UPDATE  C SET
       C.LW_2 = A.ADDR_STD 
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON C.LW_2 = A.ADDR_VAR AND A.CAT = 'ROADWAY'
    WHERE STAT_1_CD = 9
    OPTION(MERGE JOIN); 
    */
    
    
    
        -- Take care of diffrent vrsion of Us
    UPDATE MDM_STAGE.TEMP_ADDR SET ST_NM = REPLACE(ST_NM,' U S ',' US ') WHERE  ST_NM LIKE '% U S %';
    -- 19 SEC -- 45 ROWS
     UPDATE MDM_STAGE.TEMP_ADDR SET ST_NM = REPLACE(ST_NM,'U S ','US ') WHERE  ST_NM LIKE '%U S %';
     
    UPDATE MDM_STAGE.TEMP_ADDR SET ST_NM = REPLACE(ST_NM,' U.S. ','US ') WHERE  WB_1 LIKE '% U.S. %';
    -- NO RECORDS
    
    ------------------------------------------------
    -- Direction in the beginning of name
    ------------------------------------------------
    UPDATE  C SET
      DIR_1 = ltrim(rtrim(A.ADDR_STD)), 
      ST_NM = STAGE.fnSECONDPart(ST_NM,LEN(A.ADDR_VAR)+1)
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(ST_NM) = A.ADDR_VAR
         AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN);
    
    -- IF IT IS NAME OF A HIGHWAY, Like North Highway - thn bring it back
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NM = CASE
       WHEN DIR_1='N' THEN 'NORTH '+ST_NM 
       WHEN DIR_1='S' THEN 'SOUTH '+ST_NM 
       WHEN DIR_1='E' THEN 'EAST '+ST_NM 
       WHEN DIR_1='W' THEN 'WEST '+ST_NM 
       WHEN DIR_1='NE' THEN 'NORTHEAST '+ST_NM 
       WHEN DIR_1='SE' THEN 'SOUTHEAST '+ST_NM 
       WHEN DIR_1='NW' THEN 'NORTHWEST '+ST_NM 
       WHEN DIR_1='SW' THEN 'SOUTHWEST '+ST_NM  END
      ,DIR_1=NULL
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON ltrim(rtrim(ST_NM)) = A.ADDR_VAR AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAGE.fnWordCount(ST_NM)=1 AND ST_TYP IS NULL
    OPTION(MERGE JOIN);  
    
    -- IF DIRECTION IS ACTUALLY PART OF NAME OF A STATE - THEN DO NOT ABBREVIATE
    UPDATE MDM_STAGE.TEMP_ADDR SET
      DIR_1 = NULL, 
      ST_NM = 
        CASE WHEN DIR_1 = 'N' THEN 'NORTH '+ST_NM 
             WHEN DIR_1 = 'S' THEN 'SOUTH '+ST_NM 
        ELSE ST_NM END
    WHERE STAGE.fnFirstWord(ST_NM) IN ('CAROLINA','DAKOTA') AND DIR_1 IN ('N','S');
    
    UPDATE  C SET
      DIR_1 = NULL, 
      ST_NM = 'WEST '+ST_NM 
    FROM MDM_STAGE.TEMP_ADDR C
    WHERE STAGE.fnFirstWord(ST_NM) = 'VIRGINIA' AND C.DIR_1 = 'W';



    -----------------------------------------------
    -- AVENUE H, or BLVD A --
     -----------------------------------------------
    
    UPDATE  C SET
      ST_NM = REPLACE(ST_NM, A.ADDR_VAR, A.ADDR_STD),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnFirstWord(st_nm) = A.ADDR_VAR AND CAT = 'Roadway'
    OPTION (MERGE JOIN); 
    
     
    UPDATE  C SET
      ST_NM = REPLACE(WB_1, A.ADDR_VAR, A.ADDR_STD),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR AND CAT = 'Roadway'
    OPTION (MERGE JOIN); 
    
   
    -------------------------- ADD_VAR is inside  ------------------------------------
    -- Get rid of the second part after ADD_VAR
    

    
    UPDATE  C SET
       ST_NM = STAGE.fnGET_FirstPart(ST_NM, stage.fn_LastIndexOf(ST_NM,A.ADDR_VAR)-1),
       ST_TYP = ADDR_STD,
       STAT_1_CD = 91
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON stage.fn_LastIndexOf(ST_NM,' '+A.ADDR_VAR+' ') > 0
      AND A.CAT  = 'ROADWAY'
    WHERE STAT_1_CD = 0
    AND STAGE.fnWordCount(ST_NM)>1;
    
        
    
    -------------------------- LAST LETTER OF ST_NR  ------------------------------------

    ----------------------------------------------------------------------------
    -- TAKE OUT THE LAST LETTER FROM THE STREET NUMBER 
    -- as it most likely building number
    -- but sometimes there is no space between street number and name - this wil fix that
    ----------------------------------------------------------------------------
    -- CHECK THE STATUS AGAIN
    -- Initiate
    UPDATE MDM_STAGE.TEMP_ADDR SET WC_1 = NULL, WC_2= NULL 
    WHERE WC_1 IS NOT NULL OR WC_2 IS NOT NULL ;
    
    -- FIRST TAKE THE NUMERIC PORTION OUT -- 
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WC_1 = STAGE.fnGet_Num(ST_NR) ,
      STAT_1_CD = 9
    WHERE ISNUMERIC(RIGHT(ST_NR,1)) = 0 AND ISNUMERIC(LEFT(ST_NR,1)) = 1
    AND RIGHT(ST_NR,2) NOT IN ('TH' ,'ST','ND','RD');
    
    -- Then take the string portion out
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WC_2 = RIGHT(ST_NR, LEN(ST_NR)-LEN(WC_1))
    WHERE STAT_1_CD = 9   ;
    
    -- Could the letter be direction --
    UPDATE MDM_STAGE.TEMP_ADDR SET
      DIR_1 = WC_2,
      WC_2 = NULL
    WHERE WC_2 IN ('N','S','E','W','NE','SW','NW','SE') AND DIR_1 IS NULL
    AND STAT_1_CD = 9   ;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR_2 = CASE WHEN LEN(WC_2) = 1 THEN WC_2 ELSE ST_NR_2 END,
      ST_NM = CASE WHEN LEN(WC_2) > 1 THEN WC_2+' '+ST_NM ELSE ST_NM END,
      WC_2 = NULL,
      STAT_1_CD = 1
    WHERE WC_2 IS NOT NULL AND STAT_1_CD = 9    ;
    

    -- Update with correct street number    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR = CASE WHEN RIGHT(WC_1,1) IN ('-','+') THEN LEFT(WC_1, LEN(WC_1)-1) ELSE WC_1 END
    WHERE WC_1 IS NOT NULL
     
    ----------------------------------------------  END OF ST_NR WITH LETTER ----------------------
 
    ----------------------------------------------------------------------------
    -- WHEN There is no street number
    ----------------------------------------------------------------------------
   
 ----------------------------    S T A G E   4   ------------------------------------  
-- Take care of ADDR 2

  -- REMOVE # from WB_2
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WB_2 = STAGE.fnRemoveSpace(REPLACE(WB_2,'#',' '))
  -- 12 SEC, 528k
  
    UPDATE MDM_STAGE.TEMP_ADDR SET WB_2 = STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(WB_2,' NO ',' '),' NR ',' '),' NUMBER ',' '));
    UPDATE MDM_STAGE.TEMP_ADDR SET WB_2 = STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(WB_2,'(',' '),'-',' '),':',' '));
    -- 6 SEC, 528k


  
  UPDATE  C SET
      C.STE_NR = STAGE.fnSecondWord(WB_2),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 101
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE 
    C.STAT_2_CD = 0 
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 12 sec - 518 K
    
    -- Building
    UPDATE  C SET
      C.BLDG_NR = STAGE.fnSecondWord(WB_2),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 102
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    WHERE C.STAT_2_CD = 0 
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 3 SEC, 8.3 k
    
    -- Floor
    UPDATE  C SET
      C.FL_NR = STAGE.fnLastWord(ADDR_STD),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 103
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE C.STAT_2_CD = 0 
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    
    -------------------------------------------------------------
    -- We need to repeat these one more time - to fully cleanse it
    -------------------------------------------------------------
    
    UPDATE  C SET
      C.STE_NR = STAGE.fnSecondWord(WB_2),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 121
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE C.STAT_2_CD > 100
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 1 sec - 6k
    
    -- Building
    UPDATE  C SET
      C.BLDG_NR = STAGE.fnSecondWord(WB_2),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 122
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    WHERE C.STAT_2_CD > 100
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 1 sec - 358 rec
    
    -- Floor
    UPDATE  C SET
      C.FL_NR = STAGE.fnLastWord(ADDR_STD),
      C.WB_2 = STAGE.fnSecondPart(C.WB_2 , len(STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2))+1),
      C.STAT_2_CD = 123
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_2)+' '+STAGE.fnSecondWord(WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE C.STAT_2_CD > 100
    AND WB_2 IS NOT NULL 
    OPTION(MERGE JOIN); 
    -- 1 sec, 604
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STE_NR = WB_2,
      WB_2 = NULL,
      STAT_2_CD = 131
    WHERE STAT_2_CD = 0
    AND stage.fnwordcount(WB_2) = 1
    AND ISNUMERIC(WB_2) = 1
    OPTION(MERGE JOIN); 
    -- 1 SEC, 50k
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STE_NR = STAGE.fnFirstWord(STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(STE_NR,'(',' '),'-',' '),':',' ')))
    WHERE STE_NR IS NOT NULL;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STAT_2_CD = 1 WHERE STAT_2_CD > 100;
    
    --- TAKE MANY ROADWAYS ARE STILL IN ST_NM
    
      UPDATE  C SET
      ST_TYP = A. ADDR_STD,
      ST_NM = STAGE.fnGet_FirstPart(ST_NM,LEN(ST_NM)-LEN(A.ADDR_VAR)),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ST_NM) = A.ADDR_VAR 
          AND CAT IN ('Roadway','Location')
    WHERE  ST_TYP IS NULL
    AND (C.HWY_IN = 'N' OR C.HWY_IN IS NULL)
    OPTION (MERGE JOIN) ;
    
    
    -------------------------------------
    --- LOAD DATA  ----------------------
    -------------------------------------
  
  UPDATE MDM_STAGE.TEMP_ADDR SET STE_NR = NULL WHERE LEN(STE_NR)>5;
    UPDATE MDM_STAGE.TEMP_ADDR SET BLDG_NR = NULL WHERE LEN(BLDG_NR)>5;
    
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR, ST_NR_2, DIR_1,  ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
       ST_NR, ST_NR_2, DIR_1, ST_NM, ST_TYP ,
        DIR_2, BLDG_NR, FL_NR, STE_NR
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 AND STAT_2_CD IN (-1,1)
    
    
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD IN (-1,1);
   
  
  -----------------------------------------------------------------------
  -- BLDG,STE, FLOOR Inside ADDR_2, instead of at the begining --
   -----------------------------------------------------------------------
   
   
   UPDATE  C SET
      C.STE_NR = STAGE.fnNEXTWORD (WB_2,A.ADDR_VAR),
      C.WB_2 = REPLACE(C.WB_2 , A.ADDR_VAR+' '+STAGE.fnNEXTWORD (WB_2,A.ADDR_VAR),''),
      C.STAT_2_CD = 141
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_2 LIKE '% '+A.ADDR_VAR+' %' 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE  stage.fnwordcount(WB_2) > 1;  
    -- 1 MIN -- 1946
    
   UPDATE  C SET
      C.FL_NR = STAGE.fnLastWord (A.ADDR_STD),
      C.WB_2 = REPLACE(C.WB_2, A.ADDR_VAR,''),
      C.STAT_2_CD = 142
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_2 LIKE '% '+A.ADDR_VAR+'%' 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE  stage.fnwordcount(WB_2) > 1;  
    -- 27 SEC 5K 
    
    UPDATE  C SET
      C.BLDG_NR = STAGE.fnNEXTWORD (WB_2,A.ADDR_VAR),
      C.WB_2 = REPLACE(C.WB_2 , A.ADDR_VAR+' '+STAGE.fnNEXTWORD (WB_2,A.ADDR_VAR),''),
      C.STAT_2_CD = 143
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_2 LIKE '% '+A.ADDR_VAR+' %' 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    WHERE  stage.fnwordcount(WB_2) > 1;  
    -- 33 SEC, 33K
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STE_NR = STAGE.fnFirstWord(STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(STE_NR,'(',' '),'-',' '),':',' ')));
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STAT_2_CD = 1 WHERE STAT_2_CD > 100;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STAT_1_CD = 1 WHERE ST_NM = 'BROADWAY';
     
    UPDATE MDM_STAGE.TEMP_ADDR SET STAT_1_CD = 1 WHERE ST_NR IS NOT NULL;
    
     UPDATE MDM_STAGE.TEMP_ADDR SET STE_NR = NULL WHERE LEN(STE_NR)>5;
    UPDATE MDM_STAGE.TEMP_ADDR SET BLDG_NR = NULL WHERE LEN(BLDG_NR)>5;
    
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR, ST_NR_2, DIR_1,  ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
       ST_NR, ST_NR_2, DIR_1, ST_NM, ST_TYP ,
        DIR_2, BLDG_NR, FL_NR, STE_NR
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 --AND STAT_2_CD IN (-1,1)
    
    DELETE FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1;
    
 -- TRUNCATE TABLE MDM_STAGE.TEMP_ADDR 
    
    ----------------- END  ------------
    
 END;