CREATE PROCEDURE [STAGE].[spADDR_LAUNDRY_V4] 
@ID INT = NULL
WITH EXEC AS CALLER
AS
BEGIN  

 
 -------------   START ----------

  UPDATE MDM_STAGE.TEMP_ADDR
    SET STAT_1_CD = 0, STAT_2_CD = 0;
  -- 5 sec
    /*
    --------------  STA_CD  --------------------- 
     STATS_CD = 0, pending or not touched
     STATS_CD = 1, okay, quality passed
     STAT_CD = -1, invalid address
     STAT_CD = 9 - being worked on, in process
    -------------------------------------------- 
    */
    
    -- First take out spaacial charcater, extra spaces, keep #, because that could be Unit 
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WB_1 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR_1)),
      WB_2 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR_2));
    -- 2 min 13 sec
    
    ----------------------------------------------------- 
    -- STEP 1:  First pick the ones whihc are good 
    -- to go without cleaning
    ----------------------------------------------------- 
    
    -- TAKE OUT DIRECTION to run the same exercise
    UPDATE  C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      WB_1 = STAGE.fnGet_FirstPart(WB_1,LEN(WB_1)-LEN(A.ADDR_VAR))
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN);
    -- 25 sec

    -- If first word is numeric, and last word is a roadway, mark it as good record stat_cd = 100
    UPDATE  C 
      SET STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN ( SELECT DISTINCT ADDR_STD FROM REF.ADDR_STD WHERE CAT IN ('Roadway','Location')) A 
        ON STAGE.fnLastWord(WB_1) = A.ADDR_STD 
    WHERE 
      ISNUMERIC(STAGE.fnFirstWord(WB_1)) = 1
    OPTION (MERGE JOIN) ;
    --  1 MIN 15 SEC sec -- 2.8  million
    
    -- GET THE SUITE NUMBERS
    -- we will do this again for smaller set of records 
    -- after large chunk is removed to Addr_parts 
    
    UPDATE  C SET
      C.STE_NR = STAGE.fnLastWord(WB_2),
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(C.WB_2) = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE 
      C.STAT_2_CD = 0 
      AND WB_2 IS NOT NULL 
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
    WHERE C.STAT_2_CD = 0 
    AND WB_2 IS NOT NULL 
    AND stage.fnwordcount(WB_2) = 2
    OPTION(MERGE JOIN); 
    --  sec 1M 16 SEC SEC - 2.75 Million
    
    -- FLOOR NUMBERS
    UPDATE  C SET
      C.FL_NR = STAGE.fnLastWord(ADDR_STD),
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_2 = A.ADDR_VAR 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    WHERE C.STAT_2_CD = 0 
    AND WB_2 IS NOT NULL 
    AND stage.fnwordcount(WB_2) = 2
    OPTION(MERGE JOIN); 
    -- Sec 4 sec, 18 K
    
    -- Only when Address line is verified then address 2 could be okay with null value
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_2_CD = 1
    WHERE WB_2  IS NULL AND STAT_1_CD = 1 
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
    WHERE STAT_1_CD = 1 AND STAT_2_CD = 1;
  -- 3.5 MIN, 2.5 MILLION 
  
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD = 1;
  -- 5 SEC
  
  ----------------------------------------------------- 
  -- STEP 2:  FIRST we will clean ADDR Line 1
  ----------------------------------------------------- 
  -- Before cleansing ADDR 1 need to take words does not belon in ADDR 2
  -- Then we will clean all of the ADDR 1 at once 
  -----------------------------------------------
  
  -- First set of cases: ADDR 1 is 2 words and is actually ADDR 2 = so switch
  ---------------------------------------------------------------------------
   UPDATE  C SET
      C.STE_NR = CASE WHEN STE_NR IS NULL THEN STAGE.fnLastWord(WB_1) END,
      C.WB_1 = WB_2,
      C.STAT_2_CD = 1
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    WHERE WB_1 IS NOT NULL 
    AND stage.fnwordcount(WB_1) = 2
    OPTION(MERGE JOIN); 
    -- 24 sec - 545 K
    
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
  
  ------------ ------------ ------------ ------------ ------------ ------------ ------------ -----------
  ------------  BEFORE CLEANSING ADDR 1,  we will bring ADDR 2 TO ADDR 1 IF IT BELONGS THERE ------------  
  -- Change all string numbers to numeric. It will help to find street numbers in next step    ---------
  
  UPDATE C SET
    WB_1 = CONVERT(VARCHAR(10),N.NBR_NUM)+' '+ RIGHT(C.WB_1 ,LEN(C.WB_1)-charindex(' ',C.WB_1 ))
  FROM 
    MDM_STAGE.TEMP_ADDR  C, 
    REF.NBR_CNVRTR N
  WHERE STAGE.fnWordCount(WB_1)>1 AND STAGE.fnFirstWord(WB_1) = N.NBR_STR 
  OPTION (MERGE JOIN);
  
  UPDATE C SET
    WB_1 = CONVERT(VARCHAR(10),N.NBR_NUM)+' '+ RIGHT(C.WB_1 ,LEN(C.WB_1)-charindex(' ',C.WB_1 ))
  FROM 
    MDM_STAGE.TEMP_ADDR  C, 
    REF.NBR_CNVRTR N
  WHERE STAGE.fnWordCount(WB_1)>1 AND STAGE.fnFirstWord(WB_1) = N.NBR_STR 
  OPTION (MERGE JOIN);
  
  UPDATE T SET
    WB_1 = WB_2,
    WB_2 = WB_1
  FROM MDM_STAGE.TEMP_ADDR T
  JOIN REF.ADDR_STD A ON T.WB_2 LIKE '% '+A.ADDR_VAR+'%' AND A.CAT ='Roadway' AND ISNUMERIC(LEFT(T.WB_2,1)) = 1 
  WHERE ISNUMERIC(LEFT(T.WB_1,1)) = 0 ;
  
  
  ---------------------------------------------------------
  -- Second set of cases: ADDR 2 is at the end of ADDR 1
  -- BLDG, STE or FL are at the end of ADDR 1
  ---------------------------------------------------------
  -- USE STAT_CD = 9 for repeating cleansing on same set of records -- 
  
  UPDATE MDM_STAGE.TEMP_ADDR SET
    STE_NR = STAGE.fnLastWord(WB_1),
    STAT_1_CD = 9,
    WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN('# '+STAGE.fnLastWord(WB_1))) )
  WHERE   STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = '#' 
  AND stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  
  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,  -- why?
    C.STE_NR  = STAGE.fnLastWord(WB_1),      
    C.STAT_1_CD = 9,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 24 SEC, 312K


  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,                  -- why?
    C.BLDG_NR  = STAGE.fnLastWord(WB_1),      
    C.STAT_1_CD = 9,
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
  STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
  AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
  AND A.REC_ACT_IN = 'Y'
  WHERE stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  OPTION (MERGE JOIN);
  -- 6 SEC, 6.2 K
  
  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,    -- why?
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
  -- 8 SEC 11K
  
  -- DO IT AGAIN FOR BUILDING AND STE
  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,                  -- why?
    C.BLDG_NR  = STAGE.fnLastWord(WB_1),      
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
    STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
    AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING'
    AND A.REC_ACT_IN = 'Y'
  WHERE 
    stage.fnwordcount(WB_1) >2
    AND STAT_1_CD = 9
    and C.BLDG_NR is null
  OPTION (MERGE JOIN);
  
  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,    -- why?
    C.FL_NR  = STAGE.fnLastWord(ADDR_STD),      
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR)) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
    STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))) +' '+STAGE.fnLastWord(WB_1) = A.ADDR_VAR 
    AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'FLOOR'
    AND A.REC_ACT_IN = 'Y'
  WHERE 
    stage.fnwordcount(WB_1) >2
    AND STAT_1_CD = 9
    and C.FL_NR is NULL
  OPTION (MERGE JOIN);
  
  
  UPDATE C SET
    C.LW_2 = A.ADDR_VAR,  -- why?
    C.STE_NR  = STAGE.fnLastWord(WB_1),      
    C.WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN(A.ADDR_VAR+' '+STAGE.fnLastWord(WB_1))) )
  FROM MDM_STAGE.TEMP_ADDR   C
  JOIN REF.ADDR_STD A ON 
    STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = A.ADDR_VAR
    AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE'
    AND A.REC_ACT_IN = 'Y'
  WHERE 
    stage.fnwordcount(WB_1) >2
    AND C.STAT_1_CD = 9
    AND C.STE_NR IS NULL
  OPTION (MERGE JOIN);
  
  --- the purpose of stat_1_cd = 9 is done -- back to zero
  UPDATE MDM_STAGE.TEMP_ADDR  SET STAT_1_CD = 0 WHERE STAT_1_CD = 9;
  
  ----------------------  END OF TAKING THE SUITE, BLDG, FLOOR OUT FROM ADDR 1  ---------------------
  
  -------------------------------
  -- NOW TAKE THE DIRECTION OUT
  ------------------------------
  
    UPDATE C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      WB_1 = STAGE.fnGet_FirstPart(WB_1,LEN(WB_1)-LEN(A.ADDR_VAR))
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN);

    ------------------------------------------------
    -- Break apart the address
    -- Take STR_NR  for all Records and adjust ST_NM
    -------------------------------------------------
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR = STAGE.fnFirstWord(WB_1),
      ST_NM = STAGE.fnSecondPart(WB_1, LEN(STAGE.fnFirstWord(WB_1))+1)
    WHERE ISNUMERIC(LEFT(WB_1,1)) = 1;
    
    UPDATE  C SET
      ST_TYP = ADDR_STD,
      ST_NM = STAGE.fnGet_FirstPart(ST_NM, (LEN(ST_NM) - LEN(A.ADDR_STD)-1)),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR AND A.CAT IN ('Roadway','Location')
    WHERE ST_NR IS NOT NULL
    AND STAGE.fnWordCount(ST_NM)>1
    OPTION (MERGE JOIN);
  
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_2_CD = 1
    WHERE WB_2  IS NULL AND STAT_1_CD = 1 ;
    
    
    /*
    -- AGAIN TAKE THE COMPLETELY GOOD ONES OUT
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
  -- 528k left
  -- 252 k has issue with addr_2

  ----------------------------------------
  --- STEP:  CLEANSE ADDR 2
  ----------------------------------------
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
    
    UPDATE MDM_STAGE.TEMP_ADDR SET STE_NR = STAGE.fnFirstWord(STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(STE_NR,'(',' '),'-',' '),':',' ')));
    
    --- MOVE the third chunk --
  --SELECT COUNT(*)  FROM MDM_STAGE.TEMP_ADDR
  --WHERE STAT_1_CD = 1 AND STAT_2_CD > 100
    
   INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR,ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT 
      SRC_ID,  
      STAGE.fnFirstWord(WB_1),
      STAGE.fnMiddlePart(WB_1,STAGE.fnFirstWord(WB_1),STAGE.fnLastWord(WB_1) ),
      STAGE.fnLastWord(WB_1), 
       BLDG_NR, FL_NR, STE_NR,
      DIR_2
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD = 1 AND STAT_2_CD > 100
    AND LEN(STE_NR)<10 AND LEN(BLDG_NR)<10;
  
  DELETE FROM MDM_STAGE.TEMP_ADDR 
  WHERE STAT_1_CD = 1 AND STAT_2_CD > 100
  AND LEN(STE_NR)<10 AND LEN(BLDG_NR)<10;
  -- 5 SEC  
   
  
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
    
    ----------------- END OF EXTRACTIN ADDR 2 - BLDG, STE, FL ------------
    
    ----------------------------------------
    -- ADDR 1 is inside ADDR 2
    -- MARK THE POTENTIAL ADDR_1 as 99
    -------------------------------------------
    UPDATE  C 
      SET STAT_2_CD = 99
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnLastWord(WB_2) = A.ADDR_VAR AND CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(LEFT(STAGE.fnFirstWord(WB_2),1)) = 1
    OPTION (MERGE JOIN) ;
    -- 3 SEC -- 8K
    
    --DELETE FROM MDM_STAGE.TEMP_ADDR WHERE STAT_2_CD = 0
    
  
 -- last word is numeric - highway	
--there is number after road - ste , except after state, county, us, (numeric)	
	
--last letter char or hiphen between two numbers	there could be directin in it
--keep the rest as is	

  -- REMOVE # - SUITES FROM WB - COULD BE MOVED UP
  
  UPDATE MDM_STAGE.TEMP_ADDR SET
    STE_NR = STAGE.fnLastWord(WB_1),
    WB_1 = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1)-LEN('# '+STAGE.fnLastWord(WB_1))) )
  WHERE   STAGE.fnLastWord(LEFT(ADDR_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1))))  = '#' 
  AND stage.fnwordcount(WB_1) >2
  AND STAT_1_CD = 0
  
  
  -- REMOVE ANY BLDG, STE ETC INSIDE ADDR_1
  UPDATE  C SET
      C.STE_NR = STAGE.fnNEXTWORD (WB_1,A.ADDR_VAR),
      C.WC_1 = STAGE.fnSecondPart(C.WB_1, CHARINDEX(' '+ADDR_VAR,WB_1)), -- Temporairly saving it, in case there is roadway in it.
      C.WB_1 = STAGE.fnGet_FirstPart(C.WB_1, CHARINDEX(' '+ADDR_VAR,WB_1))  ,
      STAT_1_CD= 201
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_1 LIKE '% '+A.ADDR_VAR+'%' 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'SUITE' AND A.ADDR_VAR <> 'ST'
    WHERE  stage.fnwordcount(WB_1) > 2
    AND STAT_1_CD = 0 ;
    
    UPDATE  C SET
      C.BLDG_NR = STAGE.fnNEXTWORD (WB_1,A.ADDR_VAR),
      C.WC_1 = STAGE.fnSecondPart(C.WB_1, CHARINDEX(' '+ADDR_VAR,WB_1)), -- Temporairly saving it, in case there is roadway in it.
      C.WB_1 = STAGE.fnGet_FirstPart(C.WB_1, CHARINDEX(' '+ADDR_VAR,WB_1))  ,
      STAT_1_CD= 211
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A ON WB_1 LIKE '% '+A.ADDR_VAR+'%' 
         AND A.CAT = 'ADDR2_KEEP' AND A.SUB_CAT = 'BUILDING' 
    WHERE  stage.fnwordcount(WB_1) > 2
    AND STAT_1_CD =0;

    -- Fix any issue of breaking good record
    UPDATE  C SET
      C.WB_1 = WB_1 + WC_1,
      STAT_1_CD= 203
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN 
      REF.ADDR_STD A ON (STAGE.fnLastWord(WC_1) = A.ADDR_VAR
      OR WC_1 LIKE '% '+A.ADDR_VAR+' %')
         AND A.CAT = 'Roadway' 
    WHERE STAT_1_CD > 200 ;
    
    -- RESET WILD COLUMN
    UPDATE MDM_STAGE.TEMP_ADDR SET WC_1 = NULL
    
    --------------------------------------------
    -- Break apart the address
    -- TAKE STR_NR  for all Records
    ----------------------------------------------
  UPDATE MDM_STAGE.TEMP_ADDR SET
    ST_NR = STAGE.fnFirstWord(WB_1),
    WB_1 = STAGE.fnSecondPart(WB_1, LEN(STAGE.fnFirstWord(WB_1))+1)
  WHERE ISNUMERIC(LEFT(STAGE.fnFirstWord(WB_1),1)) = 1;
   
   --- Now TAKE THE DIRECTION AND ROASWAY Out if those are roadways
    
   UPDATE  C SET
      DIR_2 = ltrim(rtrim(A.ADDR_STD)), 
      WB_1 = STAGE.fnGet_FirstPart(WB_1,LEN(WB_1)-LEN(A.ADDR_VAR))
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(WB_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN);
    -- 25 sec    
    
    
    ------------------------------------
    ---  HIGHWAY (A LITTLE TRICKY) -- 
    ------------------------------------
    
    -- Take the last two words out first
    UPDATE  C SET
       C.LW_1 = STAGE.fnLastWord(WB_1),
       C.LW_2 = STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))),
       STAT_1_CD = 401
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))) = A.ADDR_VAR 
      AND A.SUB_CAT = 'HIGHWAY'
    WHERE STAT_1_CD <> 1
    AND STAGE.fnWordCount(WB_1)>1
    OPTION(MERGE JOIN);  
    
    -- COUNTY OR STATE ROAD -- 
    UPDATE  C SET
       C.LW_1 = STAGE.fnLastWord(WB_1),
       C.LW_2 = STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))),
       STAT_1_CD = 401
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON STAGE.fnLastWord(LEFT(WB_1,LEN(WB_1)- LEN(STAGE.fnLastWord(WB_1)))) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'ROAD'
    WHERE STAT_1_CD <> 1
    AND STAGE.fnWordCount(WB_1)>1
    AND (WB_1 LIKE '% COUNTY %' OR WB_1 LIKE '% STATE %' OR WB_1 LIKE '% US %')
    OPTION(MERGE JOIN); 
    
    -- If there are more than two words extract st_nm, otherwise st name remains null
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NM = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1) - LEN(LW_2+' '+LW_1)-1))
    WHERE STAGE.fnWordCount(WB_1)>2
    AND STAT_1_CD = 401
    
    -- Now stdardaize the highway name
    UPDATE  C SET
       C.LW_2 = A.ADDR_STD 
    FROM MDM_STAGE.TEMP_ADDR  C
    JOIN REF.ADDR_STD A 
      ON C.LW_2 = A.ADDR_VAR AND A.CAT = 'ROADWAY'
    WHERE STAT_1_CD = 401
    OPTION(MERGE JOIN); 
    
    -- TAKE CARE OF THE DIRECTION -- 
    UPDATE  C SET
      DIR_1 = ltrim(rtrim(A.ADDR_STD)), 
      ST_NM = STAGE.fnSECONDPart(ST_NM,LEN(A.ADDR_VAR)+1)
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(ST_NM) = A.ADDR_VAR
         AND A.CAT = 'DIRECTION' 
   -- WHERE STAT_1_CD = 401
    OPTION (MERGE JOIN);
    
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


    -- Take care of diffrent vrsion of Us
    UPDATE MDM_STAGE.TEMP_ADDR SET ST_NM = REPLACE(ST_NM,'U S','US ')
    WHERE STAT_1_CD = 401 AND ADDR_1 LIKE '% U S %';
    
    UPDATE MDM_STAGE.TEMP_ADDR SET ST_NM = REPLACE(ST_NM,'U.S.','US ')
    WHERE STAT_1_CD = 401 AND ADDR_1 LIKE '% U.S. %';
    
    -----------------------------------------------------
    -- NOW PUT THEM BACK AN GET THE HWY NAME COMPLETED --
    -----------------------------------------------------
    UPDATE MDM_STAGE.TEMP_ADDR SET
      STAT_1_CD = 1,
      ST_NM = CASE WHEN ST_NM IS NULL THEN LW_2+' '+LW_1 ELSE ST_NM+' '+LW_2+' '+LW_1 END
    WHERE STAT_1_CD = 401;
        
    -----------------------------------------------
    -- AVENUE H, or BLVD A --
     -----------------------------------------------
     
    UPDATE  C SET
      ST_NM = REPLACE(WB_1, A.ADDR_VAR, A.ADDR_STD),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR AND CAT = 'Roadway'
    OPTION (MERGE JOIN); 
    
    ----------------------------------------------------------------------------
    -- TAKE OUT THE LAST LETTER FROM THE STREET NUMBER 
    -- as it most likely building number
    -- but sometimes there is no space between street number and name - this wil fix that
    ----------------------------------------------------------------------------
    
    -- Initiate
    UPDATE MDM_STAGE.TEMP_ADDR SET WC_1 = NULL, WC_2= NULL 
    WHERE WC_1 IS NOT NULL OR WC_2 IS NOT NULL ;
    
    -- FIRST TAKE THE NUMERIC PORTION OUT -- 
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WC_1 = STAGE.fnGet_NR(ST_NR) ,
      STAT_1_CD = 501
    WHERE ISNUMERIC(RIGHT(ST_NR,1)) = 0 AND ISNUMERIC(LEFT(ST_NR,1)) = 1
    AND RIGHT(ST_NR,2) NOT IN ('TH' ,'ST','ND','RD');
    
 
    
    -- Then take the string portion out
    UPDATE MDM_STAGE.TEMP_ADDR SET
      WC_2 = RIGHT(ST_NR, LEN(ST_NR)-LEN(WC_1))
    WHERE STAT_1_CD = 501    ;
    
    -- Could the letter be direction --
    UPDATE MDM_STAGE.TEMP_ADDR SET
      DIR_1 = WC_2,
      WC_2 = NULL
    WHERE WC_2 IN ('N','S','E','W','NE','SW','NW','SE') AND DIR_1 IS NULL
    AND STAT_1_CD = 501    ;
    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR_2 = CASE WHEN LEN(WC_2) = 1 THEN WC_2 ELSE ST_NR_2 END,
      ST_NM = CASE WHEN LEN(WC_2) > 1 THEN WC_2+' '+ST_NM ELSE ST_NM END,
      WC_2 = NULL,
      STAT_1_CD = 1
    WHERE WC_2 IS NOT NULL AND STAT_1_CD = 501    ;
    

    -- Update with correct street number    
    UPDATE MDM_STAGE.TEMP_ADDR SET
      ST_NR = CASE WHEN RIGHT(WC_1,1) IN ('-','+') THEN LEFT(WC_1, LEN(WC_1)-1) ELSE WC_1 END
    WHERE WC_1 IS NOT NULL
     
    
    -- CLEANSE AGAIN IF THERE IS NO ST_TYP, but there is any st_typ at the end of St_nm
    UPDATE  C SET
      ST_TYP = ADDR_STD,
      ST_NM = STAGE.fnGet_FirstPart(ST_NM, (LEN(ST_NM) - LEN(A.ADDR_VAR)-1)),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnLastWord(ST_NM) = A.ADDR_VAR AND CAT IN ('Roadway','Location') 
    WHERE C.ST_TYP IS NULL
    AND STAGE.fnWordCount(ST_NM)>1
    OPTION (MERGE JOIN);
    
    -- AGAIN ENSURE ALL ST-TYP IS STANDARDIZED
    UPDATE  C SET
      ST_TYP = ADDR_STD,
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnLastWord(ST_NM) = A.ADDR_VAR AND CAT IN ('Roadway','Location') 
    WHERE C.ST_TYP <> A.ADDR_STD
    OPTION (MERGE JOIN);
    
    -- BREAK APART THE GOOD ONES
    UPDATE  C SET
      ST_TYP = ADDR_STD,
      ST_NM = STAGE.fnGet_FirstPart(WB_1, (LEN(WB_1) - LEN(A.ADDR_STD)-1))
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN (SELECT DISTINCT ADDR_STD FROM REF.ADDR_STD WHERE CAT IN ('Roadway','Location') )A 
        ON STAGE.fnLastWord(WB_1) = A.ADDR_STD
    WHERE C.ST_NM IS NULL
    AND STAGE.fnWordCount(WB_1)>1
    AND STAT_1_CD = 1
    OPTION (MERGE JOIN);
    
  INSERT INTO MDM_STAGE.TEMP_ADDR_PARTS (  SRC_ID, ST_NR, ST_NR_2, ST_NM,  ST_TYP, ST_DIR, BLDG_NR, FL_NR, STE_NR )
    SELECT --TOP 100
      SRC_ID,  
       ST_NR, ST_NR_2, ST_NM, ST_TYP ,
        DIR_2, BLDG_NR, FL_NR, STE_NR
    FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD =1 --AND STAT_2_CD > 0
    AND (STE_NR IS NULL OR LEN(STE_NR)<10) 
    AND (BLDG_NR IS NULL OR LEN(BLDG_NR)<10);
    
    DELETE FROM MDM_STAGE.TEMP_ADDR
    WHERE STAT_1_CD =1 --AND STAT_2_CD > 0
    AND (STE_NR IS NULL OR LEN(STE_NR)<10) 
    AND (BLDG_NR IS NULL OR LEN(BLDG_NR)<10);
    
    /*
    -- THE REST STAYS THE SAME
    UPDATE  C SET
      ST_NM = REPLACE(WB_1, A.ADDR_VAR, A.ADDR_STD),
      STAT_1_CD = 1
    FROM MDM_STAGE.TEMP_ADDR C
    JOIN REF.ADDR_STD A 
        ON STAGE.fnFirstWord(WB_1) = A.ADDR_VAR AND CAT = 'Roadway'
    OPTION (MERGE JOIN); 
    */
    

    
  END;