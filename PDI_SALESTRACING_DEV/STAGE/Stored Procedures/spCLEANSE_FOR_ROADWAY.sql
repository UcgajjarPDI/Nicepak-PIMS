﻿CREATE PROCEDURE [STAGE].[spCLEANSE_FOR_ROADWAY] 
WITH EXEC AS CALLER
AS
BEGIN
       
    UPDATE T 
      SET 
        ST_TYP_1 = A.ADDR_STD, 
        ST_NM_1 = STAGE.fnGet_FirstPart(T.ST_1, LEN(T.ST_1)-LEN(A.ADDR_VAR)),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 1
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_1))) = LTRIM(RTRIM(A.ADDR_VAR)) AND A.CAT IN ('Location','Roadway')
    WHERE T.ST_1 IS NOT NULL ;

    UPDATE T 
      SET 
        ST_TYP_2 = A.ADDR_STD, 
        ST_NM_2 = STAGE.fnGet_FirstPart(T.ST_2, LEN(T.ST_2)-LEN(A.ADDR_VAR)),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 2
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(STAGE.fnLastWord(T.ST_2))) = LTRIM(RTRIM(A.ADDR_VAR)) AND A.CAT IN ('Location','Roadway')
    WHERE T.ST_2 IS NOT NULL 
    AND ADDR_SRCE IS NULL;
    
    UPDATE T 
      SET 
        ST_TYP_1 = A.ADDR_STD, 
        ST_NM_1 = STAGE.fnGet_FirstPart(T.ST_1, CHARINDEX(' '+A.ADDR_VAR+' ', ST_1)),
        SUFFIX = LTRIM(STAGE.fnSecondPart(ST_1, CHARINDEX(' '+A.ADDR_VAR+' ', ST_1)+LEN(A.ADDR_VAR)+1)),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 1
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON T.ST_1 LIKE '% '+A.ADDR_VAR+' %' AND A.CAT = 'Roadway'
    WHERE T.ST_1 IS NOT NULL 
    AND ADDR_SRCE IS NULL
    AND LTRIM(RTRIM(A.ADDR_VAR)) <> 'ST';
    
    UPDATE T 
      SET 
        ST_TYP_2 = A.ADDR_STD, 
        ST_NM_2 = STAGE.fnGet_FirstPart(T.ST_2, CHARINDEX(' '+A.ADDR_VAR+' ', ST_2)),
        SUFFIX = LTRIM(STAGE.fnSecondPart(ST_2, CHARINDEX(' '+A.ADDR_VAR+' ', ST_2)+LEN(A.ADDR_VAR)+1)),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 2
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON T.ST_2 LIKE '% '+A.ADDR_VAR+' %' AND A.CAT = 'Roadway'
    WHERE T.ST_2 IS NOT NULL 
    AND ADDR_SRCE IS NULL
    AND LTRIM(RTRIM(A.ADDR_VAR)) <> 'ST';
    
    UPDATE STAGE.TEMP_ADDR_LAUNDRY 
      SET 
        ST_TYP_1 = 'ST', 
        ST_NM_1 = RTRIM(LEFT(ST_1,STAGE.fnFind_Rdwy_Pos(ST_1,'ST'))),
        SUFFIX = LTRIM(RIGHT(ST_1, LEN(ST_1)-STAGE.fnFind_Rdwy_Pos(ST_1,'ST')-LEN('ST'))),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 1
    WHERE ST_1 LIKE '% ST %'
      AND ST_1 IS NOT NULL
      AND ADDR_SRCE IS NULL;
    
    UPDATE STAGE.TEMP_ADDR_LAUNDRY 
      SET 
        ST_TYP_2 = 'ST', 
        ST_NM_2 = RTRIM(LEFT(ST_2,STAGE.fnFind_Rdwy_Pos(ST_2,'ST'))),
        SUFFIX = LTRIM(RIGHT(ST_2, LEN(ST_2)-STAGE.fnFind_Rdwy_Pos(ST_2,'ST')-LEN('ST'))),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 2
    WHERE ST_2 LIKE '% ST %'
      AND ST_2 IS NOT NULL
      AND ADDR_SRCE IS NULL;
    
    UPDATE T 
      SET 
        ST_TYP_1 = A.ADDR_STD, 
        ST_NM_1 = NULL,
        SUFFIX = LTRIM(RTRIM(STAGE.fnSecondPart(ST_1, LEN(A.ADDR_VAR)+1))),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 1
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(ST_1) = A.ADDR_VAR 
    WHERE A.CAT = 'Roadway'
      AND ST_1 IS NOT NULL
      AND ADDR_SRCE IS NULL
      AND STAGE.fnFirstWord(ST_1) <> 'ST';
 
    UPDATE T 
      SET 
        ST_TYP_2 = A.ADDR_STD, 
        ST_NM_2 = NULL,
        SUFFIX = LTRIM(RTRIM(STAGE.fnSecondPart(ST_2, LEN(A.ADDR_VAR)+1))),
        ADDR_SRC_CNFD = 100, ADDR_SRCE = 2
    FROM STAGE.TEMP_ADDR_LAUNDRY T
    JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(ST_2) = A.ADDR_VAR 
    WHERE A.CAT = 'Roadway'
      AND ST_2 IS NOT NULL
      AND ADDR_SRCE IS NULL
      AND STAGE.fnFirstWord(ST_2) <> 'ST';
      
    --SELECT REPLACE('30 NORTH',' NORTH',' N')
    
END