CREATE PROCEDURE [STAGE].[spNAD_LAUNDRY_LITE] 
WITH EXEC AS CALLER
AS
BEGIN  

-- If both Addr1 and Addr2 is same then delete Addr2 
  UPDATE STAGE.TEMP_ADDR_LAUNDRY
    SET ADDR2 = NULL
  WHERE ADDR1 = ADDR2;

-- Remove all extra spaces from the fields

  UPDATE STAGE.TEMP_ADDR_LAUNDRY with(tablock)
    SET 
      ADDR1 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR1)), 
      ADDR2 = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR2)),
      ADDR_2_CNDT = UPPER(STAGE.fnRemoveSpace_SpChar(ADDR2)), -- will keep triming this to null
      ADDR1_STAT_CD = 9, 
      ISSUE_CD = 'P'
      ; -- meaning in progress
  

  UPDATE STAGE.TEMP_ADDR_LAUNDRY
    SET ADDR2 = NULL  
  WHERE LTRIM(RTRIM(ADDR2)) = ''     ;
  
-- Remove po box from ADDR2 and make it alternate address
  UPDATE STAGE.TEMP_ADDR_LAUNDRY
  SET 
    ALT_ADDR1 = ADDR2, 
    ADDR2 = NULL
    WHERE LTRIM(ADDR2) LIKE 'PO%'    ;

-- Change all string numbers to numeric. It will help to find street numbers in next step
-- No Need
/*
  UPDATE C
  SET  ADDR1 =
    CONVERT(VARCHAR(10),N.NBR_NUM)+' '+ RIGHT(C.ADDR1 ,LEN(C.ADDR1)-charindex(' ',C.ADDR1 ))
  FROM 
    STAGE.TEMP_ADDR_LAUNDRY C, 
    REF.NBR_CNVRTR N
  WHERE 
    C.ADDR1 IS NOT NULL AND charindex(' ',C.ADDR1) > 0
    AND ISNUMERIC(LEFT(C.ADDR1,charindex(' ',C.ADDR1)-1)) = 0
    AND LEFT(C.ADDR1,charindex(' ',C.ADDR1)-1) = N.NBR_STR     ; */


 -------------------------------------------  ROADWAY START ------------------------------
 ------ Break Apart ADDR1 -- 
     
  ------ SEPARATE STREET NUMBER AND NAME
  --- Pull first words of each street address
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY -- 5 sec
    SET ST_NR_1 = STAGE.fnFirstWord(ADDR1);
  
    
  -- Convert it to number  
  UPDATE C
    SET  C.ST_NR_1 = N.NBR_NUM
  FROM STAGE.TEMP_ADDR_LAUNDRY C 
  JOIN REF.NBR_CNVRTR N ON C.ST_NR_1 = N.NBR_STR
  WHERE C.ST_NR_1 IS NOT NULL AND ISNUMERIC(C.ST_NR_1) = 0
  OPTION(MERGE JOIN);
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY -- 5 sec
    SET ST_NR_1 = NULL
  WHERE ISNUMERIC(ST_NR_1) = 1  ;
  
  
  
  -- Grab street name               
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET ST_1 = CASE WHEN (Len(ST_NR_1)>0  OR ST_NR_1 IS NULL)
                    THEN STAGE.fnSecondPart(ADDR1,Len(ST_NR_1)+1) ELSE ADDR1 END;   
     
     
  ----- TAKE OUT LAST WORD WHEN IT IS DIRECTION (N, NE, S ETC.) ------------- 
  ----- SECTION 101 ------------
  
    UPDATE T       
      SET 
        T.DIRECTION = A.ADDR_STD,
        T.ST_1 = LEFT(T.ST_1,LEN(T.ST_1)-LEN(LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1)))))
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1))) = LTRIM(RTRIM(A.ADDR_VAR)) AND A.CAT = 'DIRECTION'
    WHERE 
    T.ST_1 IS NOT NULL     ;
  
    -- LAST WORD IS ROADWAY --     
    UPDATE T        -- 10
      SET 
        ST_TYP_1 = A.ADDR_STD,
        ST_NM_1 = STAGE.fnGet_FirstPart(T.ST_1, CHARINDEX(' '+A.ADDR_VAR, ST_1)),
        T.ADDR1_STAT_CD = 0
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1))) = LTRIM(RTRIM(A.ADDR_VAR)) AND A.CAT IN ('Roadway','Location')
    WHERE T.ST_1 IS NOT NULL    ;   
      

 /*   
    This should take care of 97% of the addresses
    
    Next: 
    There is Addr2 or other information embedded in Addr 1
    Take out ADDR_2 if those are at the end of the ADDR_1
*/
  
    UPDATE T 
      SET T.ADRR2_TYP =  A.ADDR_STD,
          T.ADRR2_NR = STAGE.fnLastWord(ST_1),                     
          ST_1 = RTRIM(REPLACE(ST_1,A.ADDR_VAR +' '+ STAGE.fnLastWord(ST_1),'')), 
          ADDR1_STAT_CD = 1 -- a random number to separate the set of records we will work in this segment
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnLastWord(LEFT(ST_1,LEN(ST_1)- LEN(STAGE.fnLastWord(ST_1)))) = A.ADDR_VAR 
      AND A.CAT = 'ADDR2_KEEP'
      AND T.ST_1 IS NOT NULL 
      AND ADDR1_STAT_CD > 0        
    OPTION (MERGE JOIN);
  
    UPDATE T WITH(TABLOCKX)
      SET T.ADRR2_TYP = STAGE.fnFirstWord(A.ADDR_STD),
          T.ADRR2_NR = STAGE.fnLastWord(A.ADDR_STD),                     
          ST_1 = RTRIM(REPLACE(ST_1,A.ADDR_VAR,'')), 
          ADDR1_STAT_CD = 1 
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE
      STAGE.fnLastWord(LEFT(ST_1,LEN(ST_1)- LEN(STAGE.fnLastWord(ST_1)))) +' '+STAGE.fnLastWord(ST_1) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.ST_1 IS NOT NULL 
      AND ADDR1_STAT_CD > 0       
    OPTION (MERGE JOIN);
    
    -- SECOND ROUND - Suite, Unit etc.
    UPDATE T
      SET T.ADRR3_TYP =  A.ADDR_STD,
          T.ADRR3_NR = STAGE.fnLastWord(ST_1),                     
          ST_1 = RTRIM(REPLACE(ST_1,A.ADDR_VAR +' '+ STAGE.fnLastWord(ST_1),''))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE
      STAGE.fnLastWord(LEFT(ST_1,LEN(ST_1)- LEN(STAGE.fnLastWord(ST_1)))) = A.ADDR_VAR 
      AND A.CAT = 'ADDR2_KEEP'
      AND T.ST_1 IS NOT NULL 
      AND ADDR1_STAT_CD = 1  
    OPTION (MERGE JOIN);
      
    -- SECOND ROUND - Floor
    UPDATE T
      SET T.ADRR3_TYP = STAGE.fnFirstWord(A.ADDR_STD),
          T.ADRR3_NR = STAGE.fnLastWord(A.ADDR_STD),                     
          ST_1 = RTRIM(REPLACE(ST_1,A.ADDR_VAR,'')) 
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE
      STAGE.fnLastWord(LEFT(ST_1,LEN(ST_1)- LEN(STAGE.fnLastWord(ST_1)))) +' '+STAGE.fnLastWord(ST_1) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.ST_1 IS NOT NULL 
      AND ADDR1_STAT_CD = 1  
    OPTION (MERGE JOIN);   

  -- Repeat Direction or Roadways like before for above set of data  
 ----- REPEAT SECTION 101 ------------
    UPDATE T 
      SET 
        T.DIRECTION = A.ADDR_STD,
        T.ST_1 = LEFT(T.ST_1,LEN(T.ST_1)-LEN(LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1)))))
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1))) = LTRIM(RTRIM(A.ADDR_VAR)) AND A.CAT = 'DIRECTION'
    WHERE 
    T.ST_1 IS NOT NULL 
    AND ADDR1_STAT_CD = 1    ;
    -- 1 SEC
    
    -- LAST WORD IS ROADWAY -- 
    UPDATE T WITH(TABLOCKX)
      SET 
        ST_TYP_1 = A.ADDR_STD,
        ST_NM_1 = STAGE.fnGet_FirstPart(T.ST_1, CHARINDEX(' '+A.ADDR_VAR, ST_1)),
        T.ADDR1_STAT_CD = 0
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1))) = A.ADDR_VAR AND A.CAT IN ('Roadway','Location')
    WHERE T.ST_1 IS NOT NULL
    AND ADDR1_STAT_CD = 1
    OPTION(MERGE JOIN);     
    
  ------------------------------------------------    
  ---     HIGHWAY / ROUTE WITH NUMBER       ------ 
  ------------------------------------------------  
  
  UPDATE T
      SET  T.ST_NM_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
        T.ADDR1_STAT_CD = 0  
  FROM STAGE.TEMP_ADDR_LAUNDRY T
  JOIN  REF.ADDR_STD A
  ON STAGE.fnLastWord(LEFT(ST_1,LEN(ST_1)- LEN(STAGE.fnLastWord(ST_1)))) = A.ADDR_VAR 
  WHERE 
    T.ST_1 IS NOT NULL
    AND ISNUMERIC(STAGE.fnLastWord(ST_1)) = 1
    AND A.CAT = 'ROADWAY'
    AND ADDR1_STAT_CD > 0
   OPTION (HASH JOIN, MERGE JOIN)  ;        -- Makes performance blazing fast


  -- Take care of Interstate
  UPDATE STAGE.TEMP_ADDR_LAUNDRY SET ST_NM_1 = REPLACE(ST_1,'INTERSTATE', 'I')
  WHERE ST_NM_1 LIKE '% INTERSTATE %';

    
  ------------------------------------------------    
  ---   SUFFIX SEGMENT              ---- 
  ---   For rest of the few records  use suffix to separate issues     ------ 
  ------------------------------------------------ 
    
    UPDATE T
      SET
        ST_NM_1 = STAGE.fnGet_FirstPart(T.ST_1, CHARINDEX(' '+A.ADDR_VAR+' ', ST_1)),
        ST_TYP_1 = A.ADDR_VAR, 
        SUFFIX = LTRIM(STAGE.fnSecondPart(ST_1, CHARINDEX(' '+A.ADDR_VAR+' ', ST_1)+LEN(A.ADDR_VAR)+1)) ,
        T.ADDR1_STAT_CD = 1
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON T.ST_1 LIKE '% '+A.ADDR_VAR+' %' AND A.CAT = 'Roadway'
    WHERE 
      T.ST_1 IS NOT NULL 
      AND ADDR1_STAT_CD > 0    ;

    -- In case Suffix has first word is a roadway, that means there was another roadway that was part of street name
  UPDATE T
    SET 
      ST_NM_1 = ST_NM_1+' '+ST_TYP_1,
      ST_TYP_1 = A.ADDR_STD,
      SUFFIX = STAGE.fnSecondPart(SUFFIX,LEN(A.ADDR_VAR)+2)
  FROM STAGE.TEMP_ADDR_LAUNDRY T
  JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnFirstWord(SUFFIX))) = A.ADDR_VAR AND A.CAT IN ('Roadway','Location')
  WHERE
    SUFFIX IS NOT NULL
    AND ADDR1_STAT_CD = 1     ; 
  
  
  -- TAKE DIRECTION OUT OF SUFFIX
  UPDATE T
    SET 
      DIRECTION = A.ADDR_STD, 
      SUFFIX = STAGE.fnSecondPart(SUFFIX,LEN(A.ADDR_VAR)+2)
  FROM STAGE.TEMP_ADDR_LAUNDRY T
  JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnFirstWord(SUFFIX))) = A.ADDR_VAR AND A.CAT = 'DIRECTION'
  WHERE
    SUFFIX IS NOT NULL
    AND ADDR1_STAT_CD = 1
    OPTION (MERGE JOIN);

    
  --- NOW TAKE OUT ADDR 2
  
    UPDATE T
      SET T.ADRR2_TYP = A.ADDR_STD,
          T.ADRR2_NR =  STAGE.fnSecondWord(SUFFIX),                     
          SUFFIX = RTRIM(REPLACE(SUFFIX,A.ADDR_VAR +' '+ STAGE.fnSecondWord(SUFFIX),''))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(SUFFIX) = A.ADDR_VAR 
      AND A.CAT = 'ADDR2_KEEP'
      AND SUFFIX IS NOT NULL 
      AND T.ADRR2_TYP IS NULL
      AND ADDR1_STAT_CD = 1
      OPTION (MERGE JOIN);
    -- LESS THAN A SECOND
          
          
    UPDATE T
      SET T.ADRR2_TYP = STAGE.fnFirstWord(A.ADDR_STD),
          T.ADRR2_NR = STAGE.fnLastWord(A.ADDR_STD),                     
          SUFFIX =  RTRIM(REPLACE(SUFFIX,A.ADDR_VAR,'')) 
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(SUFFIX) +' '+STAGE.fnSecondWord(SUFFIX) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND SUFFIX IS NOT NULL 
      AND T.ADRR2_TYP IS NULL
      AND ADDR1_STAT_CD = 1
      OPTION (MERGE JOIN);
    -- LESS THAN A SEC
    
    UPDATE T
      SET T.ADRR3_TYP = A.ADDR_STD,
          T.ADRR3_NR =  STAGE.fnSecondWord(SUFFIX),                     
          SUFFIX = RTRIM(REPLACE(SUFFIX,A.ADDR_VAR +' '+ STAGE.fnSecondWord(SUFFIX),''))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(SUFFIX) = A.ADDR_VAR 
      AND A.CAT = 'ADDR2_KEEP'
      AND SUFFIX IS NOT NULL 
      AND T.ADRR2_TYP IS NOT NULL
      AND ADDR1_STAT_CD = 1
      OPTION (MERGE JOIN);
    -- LESS THAN A SECOND
          
          
    UPDATE T
      SET T.ADRR3_TYP = STAGE.fnFirstWord(A.ADDR_STD),
          T.ADRR3_NR = STAGE.fnLastWord(A.ADDR_STD),                     
          SUFFIX =  RTRIM(REPLACE(SUFFIX,A.ADDR_VAR,'')) 
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(SUFFIX) +' '+STAGE.fnSecondWord(SUFFIX) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND SUFFIX IS NOT NULL 
      AND T.ADRR2_TYP IS NOT NULL
      AND ADDR1_STAT_CD = 1
      OPTION (MERGE JOIN);
    -- LESS THAN A SEC
    
    
  -- Remaining PORTION OF SUFFIX is mostlikely alt name is saved as such
    UPDATE STAGE.TEMP_ADDR_LAUNDRY
      SET  ALT_NM = SUFFIX , SUFFIX = NULL, ADDR1_STAT_CD = 0
    WHERE SUFFIX IS NOT NULL AND ADDR1_STAT_CD = 1;
  --< 1 SEC
  
    -- IN CASE addr2 and addr3 is same , delete addr 3
    UPDATE STAGE.TEMP_ADDR_LAUNDRY
      SET ADRR3_TYP = NULL,
          ADRR3_NR = NULL
      WHERE ADRR2_TYP = ADRR3_TYP AND ADRR2_NR = ADRR3_NR ;
   -- <1 SEC   

  ----  When street number had a char -- need to be recognized as street number, even though not numeric        
   -- In rare occasion if the direction is attached with number

  UPDATE STAGE.TEMP_ADDR_LAUNDRY
    SET ST_NR_1 = LEFT(ST_NR_1,LEN(ST_NR_1)-1),
    ST_NM_1 = RIGHT(ST_NR_1,1)+' '+ST_NM_1
  WHERE RIGHT(ST_NR_1,1) IN ('N','W','E','S');

  UPDATE STAGE.TEMP_ADDR_LAUNDRY
    SET ST_NR_1 = LEFT(ST_NR_1,LEN(ST_NR_1)-2),
    ST_NM_1 =  RIGHT(ST_NR_1,2)+' '+ST_NM_1
  WHERE RIGHT(ST_NR_1,2) IN ('NW','NE','SE','SW');
  

 -------------------------------------------  ADDR LINE 1 END ------------------------------
 
 -------------------------------------------  ADDR LINE 2 START ----------------------------
 
  -- First round - addr2 stats with SUITE, BLDG ETC. when Addr2 has npo value
    UPDATE T
      SET T.ADRR2_TYP = A.ADDR_STD,
          T.ADRR2_NR =  STAGE.fnSecondWord(T.ADDR_2_CNDT) ,                     
          T.ADDR_2_CNDT =  RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR +' '+ STAGE.fnSecondWord(T.ADDR_2_CNDT),'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE  
      STAGE.fnFirstWord(T.ADDR_2_CNDT) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP'      
      AND T.ADDR_2_CNDT IS NOT NULL 
      AND T.ADRR2_TYP IS NULL
      OPTION (MERGE JOIN);
    
    -- 9 SEC 
    
    UPDATE T
      SET T.ADRR2_TYP = STAGE.fnFirstWord(A.ADDR_STD) ,
          T.ADRR2_NR = STAGE.fnLastWord(A.ADDR_STD) ,                     
          T.ADDR_2_CNDT = RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR,'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(T.ADDR_2_CNDT) +' '+STAGE.fnSecondWord(T.ADDR_2_CNDT) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.ADDR_2_CNDT IS NOT NULL 
      AND T.ADRR2_TYP IS NULL
      OPTION (MERGE JOIN);
    -- 1 SEC  
    
  -- First round - 2nd iteration - when Addr2 already has value 
    UPDATE T
      SET T.ADRR3_TYP = A.ADDR_STD,
          T.ADRR3_NR =  STAGE.fnSecondWord(T.ADDR_2_CNDT) ,                     
          T.ADDR_2_CNDT =  RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR +' '+ STAGE.fnSecondWord(T.ADDR_2_CNDT),'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE  
      STAGE.fnFirstWord(T.ADDR_2_CNDT) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP'
    AND T.ADDR_2_CNDT IS NOT NULL 
    AND T.ADRR2_TYP IS NOT NULL
    OPTION (MERGE JOIN);
    
    UPDATE T
      SET T.ADRR3_TYP = STAGE.fnFirstWord(A.ADDR_STD) ,
          T.ADRR3_NR = STAGE.fnLastWord(A.ADDR_STD) ,                     
          T.ADDR_2_CNDT = RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR,'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(T.ADDR_2_CNDT) +' '+STAGE.fnSecondWord(T.ADDR_2_CNDT) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.ADDR_2_CNDT IS NOT NULL 
      AND T.ADRR2_TYP IS NOT NULL
      OPTION (MERGE JOIN);
    
  -- Second round - We have second set of addr2 right after first
    UPDATE T
      SET T.ADRR3_TYP = A.ADDR_STD,
          T.ADRR3_NR =  STAGE.fnSecondWord(T.ADDR_2_CNDT) ,                     
          T.ADDR_2_CNDT =  RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR +' '+ STAGE.fnSecondWord(T.ADDR_2_CNDT),'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE  
      STAGE.fnFirstWord(T.ADDR_2_CNDT) = A.ADDR_VAR AND A.CAT = 'ADDR2_KEEP'
    AND T.ADDR_2_CNDT IS NOT NULL 
    AND T.ADRR2_TYP IS NOT NULL
    OPTION (MERGE JOIN);
    
    UPDATE T
      SET T.ADRR3_TYP = STAGE.fnFirstWord(A.ADDR_STD) ,
          T.ADRR3_NR = STAGE.fnLastWord(A.ADDR_STD) ,                     
          T.ADDR_2_CNDT = RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR,'')))
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
      STAGE.fnFirstWord(T.ADDR_2_CNDT) +' '+STAGE.fnSecondWord(T.ADDR_2_CNDT) = A.ADDR_VAR 
      AND A.ADDR_TYP = 'FLOOR'
      AND T.ADDR_2_CNDT IS NOT NULL 
      AND T.ADRR2_TYP IS NOT NULL
      OPTION (MERGE JOIN);
    
    -- The addr2 is somewhere inside Addr Line 2
    UPDATE T
      SET T.ADRR2_TYP = CASE WHEN A.ADDR_TYP = 'FLOOR' THEN STAGE.fnFirstWord(A.ADDR_STD) ELSE A.ADDR_STD END,
          T.ADRR2_NR = CASE WHEN A.ADDR_TYP = 'FLOOR' THEN STAGE.fnLastWord(A.ADDR_STD) ELSE STAGE.fnNextWord(T.ADDR_2_CNDT,A.ADDR_VAR) END,                     
          T.ADDR_2_CNDT = CASE WHEN A.ADDR_TYP = 'FLOOR' THEN RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR,'')))
                          ELSE RTRIM(LTRIM(REPLACE(T.ADDR_2_CNDT,A.ADDR_VAR +' '+ STAGE.fnNextWord(T.ADDR_2_CNDT,A.ADDR_VAR),''))) END
    FROM 
      STAGE.TEMP_ADDR_LAUNDRY T,
      REF.ADDR_STD A 
    WHERE 
    ( T.ADDR_2_CNDT LIKE '% '+A.ADDR_VAR+'%' AND A.CAT = 'ADDR2_KEEP')
    AND T.ADDR_2_CNDT IS NOT NULL
    AND T.ADRR2_TYP IS NULL;
    
    
  
 --   UPDATE STAGE.TEMP_ADDR_LAUNDRY SET ADDR_2_CNDT = NULL WHERE ADDR_2_CNDT IS NOT NULL;
 
    
 -------------------------------------------  ADDR LINE 2 END ----------------------------
     
    -- MAKE THE ADDR_TYP, DIRECTION, ADDR_TYP - STANDARD - ONE LAST TIME
    ----------------------------------------------------------------
--------------------------------------    
 -- TO ENSURE ROADWAYS ARE STANDARDIZED
 UPDATE T
      SET T.ST_TYP_1 = A.ADDR_STD
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE LTRIM(RTRIM(T.ST_TYP_1)) = A.ADDR_VAR
  OPTION (MERGE JOIN);
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR1 = STAGE.fnRemoveSpace (ST_NR_1+' '+ST_NM_1+' '+ST_TYP_1),
     ISSUE_CD = 'C'
  WHERE ST_NR_1 IS NOT NULL AND ST_NM_1 IS NOT NULL AND ST_TYP_1 IS NOT NULL AND DIRECTION IS NULL 
  AND UPD_ADDR1 IS NULL; 
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR1 = STAGE.fnRemoveSpace (ST_NR_1+' '+ST_NM_1+' '+ST_TYP_1+' '+DIRECTION),
     ISSUE_CD = 'C'
  WHERE ST_NR_1 IS NOT NULL AND ST_NM_1 IS NOT NULL AND ST_TYP_1 IS NOT NULL AND DIRECTION IS NOT NULL 
  AND UPD_ADDR1 IS NULL; 

  -- The remaining 5 %
  
  --  cleanup remaining of the ST_1

    -- AT the end of the name
  UPDATE T
      SET ST_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
      ISSUE_CD = 'I'
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE 
    ISSUE_CD = 'P'
    AND STAGE.fnLastWord(ST_1) = A.ADDR_VAR AND A.CAT IN ('ROADWAY','LOCATION')
  OPTION (MERGE JOIN);
  
  -- IN THE BEGINNING OF THE NAME
  UPDATE T
      SET ST_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
      ISSUE_CD = 'I'
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE 
    T.ST_1 IS NOT NULL
    AND ISSUE_CD = 'P'
    AND STAGE.fnFirstWord(ST_1) = A.ADDR_VAR AND A.CAT IN ('ROADWAY','LOCATION')
  OPTION (MERGE JOIN);
  
    -- IN THE MIDDLE OF THE NAME
  UPDATE T
      SET ST_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
      ISSUE_CD = 'I'
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE  
    T.ST_1 IS NOT NULL
    AND ISSUE_CD = 'P'
    AND STAGE.fnFirstWord(ST_1) = A.ADDR_VAR AND A.CAT IN ('ROADWAY','LOCATION')
  OPTION (MERGE JOIN);
  
    --Inside the name
  UPDATE T
      SET ST_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
      ISSUE_CD = 'I'
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE 
    T.ST_1 IS NOT NULL
    AND ISSUE_CD = 'P'
    AND T.ST_1 LIKE '% '+A.ADDR_VAR+' %' AND A.CAT = 'ROADWAY';
  
  UPDATE T
      SET ST_1 = REPLACE(ST_1,A.ADDR_VAR, A.ADDR_STD),
      ISSUE_CD = 'I'
  FROM STAGE.TEMP_ADDR_LAUNDRY T,
       REF.ADDR_STD A
  WHERE 
    T.ST_1 IS NOT NULL
    AND ISSUE_CD = 'P' 
    AND T.ST_1 LIKE '% '+A.ADDR_VAR+' %' AND A.CAT = 'LOCATION';
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR1 = 
          STAGE.fnRemoveSpace (
          CASE WHEN ST_NR_1 IS NOT NULL THEN ST_NR_1 ELSE '' END
          +' '+
          CASE WHEN ST_NM_1 IS NOT NULL THEN ST_NM_1 ELSE ST_1 END
          +' '+
          CASE WHEN ST_TYP_1 IS NOT NULL THEN ST_TYP_1 ELSE '' END
          +' '+ 
          CASE WHEN DIRECTION IS NOT NULL THEN DIRECTION ELSE '' END
          )
  WHERE UPD_ADDR1 IS NULL;
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY  SET UPD_ADDR1 = NULL   WHERE LEN(UPD_ADDR1) = 0;

  
  -- UPD_ADDR1 WHICH IS LEFT --
 
  -- Remains unclean - should flag this -- 
    UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR1 = ST_1,ISSUE_CD = 'E'  
    WHERE UPD_ADDR1 IS NULL ;
    
  -------------------------------------------------------------
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR2 = ADRR2_TYP+' '+ADRR2_NR
  WHERE ADRR2_TYP IS NOT NULL;
  
  UPDATE STAGE.TEMP_ADDR_LAUNDRY 
    SET UPD_ADDR3 = ADRR3_TYP+' '+ADRR3_NR
  WHERE ADRR3_TYP IS NOT NULL;
  
  
  UPDATE T 
    SET T.CITY = Z.City
  FROM STAGE.TEMP_ADDR_LAUNDRY T
  JOIN REF.ZIP_CODE Z ON LEFT(LTRIM(T.ZIP),5) = Z.Zipcode AND Z.LocationType = 'PRIMARY'
  WHERE T.CITY=Z.City
  OPTION(MERGE JOIN);  
  
 

  END;