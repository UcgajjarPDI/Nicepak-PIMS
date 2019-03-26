CREATE PROCEDURE [STAGE].[spCMS_PRE_WASH] 
WITH EXEC AS CALLER
AS
BEGIN  

UPDATE MDM_STAGE.CMS_COMPANY
      SET STAT_CD = 0
    -- 6 SECOND    
    
    /*
    --------------  STA_CD  --------------------- 
     STATS_CD = 12, - both ADDR1 and ADDR2 is good to go
     STATS_CD = 10 - ADDR1 is good, ADDR2 does not exist
     STAT_CD = 1 - AdDR1 is good, ADDR2 needs work
     STAT_CD = 2 - AdDR2 is good, ADDR1 needs work
     STAT_CD = 0 - The record hasn't been worked on yet
    -------------------------------------------- 
    */
    
    UPDATE MDM_STAGE.CMS_COMPANY SET
      CMPNY_ADDR_1 = UPPER(STAGE.fnRemoveSpace_SpChar(CMPNY_ADDR_1)),
      CMPNY_ADDR_2 = UPPER(STAGE.fnRemoveSpace_SpChar(CMPNY_ADDR_2))
    -- WHERE STAT_CD < 10 
    -- 33 sec
    
    -- TAKE OUT # FROM ADDR 2  
    UPDATE MDM_STAGE.CMS_COMPANY SET 
      CMPNY_ADDR_2 = STAGE.fnRemoveSpace(REPLACE(CMPNY_ADDR_2,'#','UNIT ')),
      STAT_CD = 2
    WHERE LEFT(CMPNY_ADDR_2,1) = '#' 
    AND STAT_CD = 0 ; -- Untouched record (0) or only ADDR1 is okay (1)
    -- 1 sec 27k record
    
  UPDATE C SET
    CMPNY_ADDR_2 = STAGE.fnRemoveSpace(REPLACE(CMPNY_ADDR_2,'#',' ')),
    STAT_CD = 2
  FROM MDM_STAGE.CMS_COMPANY C
  JOIN REF.ADDR_STD A ON CMPNY_ADDR_2 LIKE '%'+A.ADDR_VAR+'#%' AND A.CAT = 'ADDR2_KEEP'  AND A.ADDR_VAR <> '#'
  WHERE STAT_CD = 0;
  -- 35 SEC
  -- 2K
  
  -- Now take care of addr 2 first
    UPDATE T
      SET T.CMPNY_ADDR_2 =  REPLACE(T.CMPNY_ADDR_2,A.ADDR_VAR, A.ADDR_STD),
      STAT_CD = 2
    FROM 
      MDM_STAGE.CMS_COMPANY T,
      REF.ADDR_STD A 
    WHERE  
      STAGE.fnFirstWord(T.CMPNY_ADDR_2) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP'      
      AND T.CMPNY_ADDR_2 IS NOT NULL 
      OPTION (MERGE JOIN);
   -- 11 SECOND
   
    UPDATE T
      SET T.CMPNY_ADDR_2 = A.ADDR_STD,
      STAT_CD = 2
    FROM 
      MDM_STAGE.CMS_COMPANY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(T.CMPNY_ADDR_2) +' '+STAGE.fnSecondWord(T.CMPNY_ADDR_2) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.CMPNY_ADDR_2 IS NOT NULL 
      AND T.STAT_CD = 0
      OPTION (MERGE JOIN);
    -- 34 SECOND  
    
  -- But if the word count is more than two in addr 2 it might be a bad address   
  UPDATE MDM_STAGE.CMS_COMPANY
    SET STAT_CD = 0
  WHERE STAT_CD = 2
  AND STAGE.fnwordcount(CMPNY_ADDR_2) > 2
    
    
    -- TAKE OUT DIRECTION
    UPDATE  C 
      SET DIR = ltrim(rtrim(A.ADDR_STD)), 
      CMPNY_ADDR_1 = STAGE.fnGet_FirstPart(CMPNY_ADDR_1,LEN(CMPNY_ADDR_1)-LEN(A.ADDR_VAR))
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_VAR
    AND A.CAT = 'DIRECTION' 
    OPTION (MERGE JOIN); 
   -- 40 SEC   
   
    UPDATE  C 
      SET STAT_CD = 10
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_STD 
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.CMPNY_ADDR_2  IS NULL
    OPTION (MERGE JOIN)  ;
    -- 42 seconds 
    -- 1.9 MILLION IS TAKEN CARE OFF
    
    UPDATE  C 
      SET STAT_CD = 10,
      CMPNY_ADDR_1 = STAGE.fnGet_FirstPart(CMPNY_ADDR_1,LEN(CMPNY_ADDR_1)-LEN(A.ADDR_VAR))+' '+A.ADDR_STD
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_VAR  
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.CMPNY_ADDR_2  IS NULL
    OPTION(MERGE JOIN);
    --1.5 MIN 
    
    UPDATE  C 
      SET STAT_CD = 12
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_STD 
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.STAT_CD = 2 
    OPTION(MERGE JOIN);
    -- 11 SEC
    
    -- ADDR_STD is also ADD_VAR - doing the ones above - reduces burden on the one following
    UPDATE  C 
      SET STAT_CD = 12,
      CMPNY_ADDR_1 = STAGE.fnGet_FirstPart(CMPNY_ADDR_1,LEN(CMPNY_ADDR_1)-LEN(A.ADDR_VAR))+' '+A.ADDR_STD 
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_VAR 
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.STAT_CD = 2  
    OPTION(MERGE JOIN);
    
    UPDATE  C 
      SET STAT_CD = 1
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_STD 
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.CMPNY_ADDR_2  IS NOT NULL
    AND C.STAT_CD = 0
    OPTION (MERGE JOIN)  ;
    -- 9 SEC
    -- 190K IS TAKEN CARE OFF
    
    UPDATE  C 
      SET STAT_CD = 1,
      CMPNY_ADDR_1 = STAGE.fnGet_FirstPart(CMPNY_ADDR_1,LEN(CMPNY_ADDR_1)-LEN(A.ADDR_VAR))+' '+A.ADDR_STD
    FROM MDM_STAGE.CMS_COMPANY C
    JOIN REF.ADDR_STD A ON STAGE.fnLastWord(CMPNY_ADDR_1) = A.ADDR_VAR  
    AND A.CAT IN ('Roadway','Location')
    WHERE ISNUMERIC(STAGE.fnFirstWord(C.CMPNY_ADDR_1)) = 1
    AND C.CMPNY_ADDR_2  IS NOT NULL
    AND C.STAT_CD = 0
    OPTION(MERGE JOIN);
  
 

  END;