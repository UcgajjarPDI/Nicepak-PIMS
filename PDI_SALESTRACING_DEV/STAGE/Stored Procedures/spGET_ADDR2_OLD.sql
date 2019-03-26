CREATE PROCEDURE [STAGE].[spGET_ADDR2_OLD]
WITH EXEC AS CALLER
AS
BEGIN

-- REMOVE site, building etc
  DECLARE @LOC_TYP VARCHAR(20), @LOC_VAR VARCHAR(20), @LOC_STD VARCHAR(20), @CAT VARCHAR(20);
 
   DECLARE iCur CURSOR FOR
    SELECT ADDR_TYP, ADDR_VAR, ADDR_STD , CAT
    FROM REF.ADDR_STD
    WHERE CAT LIKE 'ADDR2%'
    
  OPEN iCur
    FETCH NEXT FROM iCur into 
    @LOC_TYP, @LOC_VAR, @LOC_STD, @CAT;
    
  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF   @LOC_TYP = 'FLOOR'
        BEGIN
          UPDATE STAGE.TEMP_ADDR_LAUNDRY 
            SET
              ADDR_2_CNDT = @LOC_VAR,
              ADDR1 = STAGE.fnGet_FirstPart(ADDR1,CHARINDEX(' '+@LOC_VAR, ADDR1)),  --- REMOVE THIS ONE IF NOT NEEDED
              ST_1 = STAGE.fnGet_FirstPart(ST_1,CHARINDEX(' '+@LOC_VAR, ST_1))
          WHERE ADDR1 IS NOT NULL AND ADDR1 LIKE '% '+@LOC_VAR+'%' 
              ;
          
          UPDATE STAGE.TEMP_ADDR_LAUNDRY 
            SET
              ADDR_2_CNDT = @LOC_VAR,
              ADDR1 = NULL  , ST_1 = NULL            
          WHERE ADDR1 IS NOT NULL AND ADDR1 LIKE @LOC_VAR+'%' 
              ;
      
          UPDATE STAGE.TEMP_ADDR_LAUNDRY 
            SET
              ADDR_2_CNDT = @LOC_VAR,
              ADDR2 = STAGE.fnGet_FirstPart(ADDR2,CHARINDEX(' '+@LOC_VAR, ADDR2)),  --- REMOVE THIS ONE IF NOT NEEDED
              ST_2 = STAGE.fnGet_FirstPart(ST_2,CHARINDEX(' '+@LOC_VAR, ST_2))
          WHERE ADDR2 IS NOT NULL AND ADDR2 LIKE '% '+@LOC_VAR+'%' 
              ;
              
          UPDATE STAGE.TEMP_ADDR_LAUNDRY 
            SET
              ADDR_2_CNDT = @LOC_VAR,
              ADDR2 = NULL, ST_2 = NULL
          WHERE ADDR2 IS NOT NULL AND ADDR2 LIKE @LOC_VAR+'%' 
              ;
        END
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET
          ADDR_2_CNDT = CASE WHEN @CAT = 'ADDR2_KEEP' THEN RIGHT(ADDR1 ,LEN(ADDR1)-charindex(@LOC_VAR,ADDR1)+1)
                                  WHEN @CAT = 'ADDR2_REMOVE' THEN NULL END,
          ADDR1 = NULL, ST_1 = NULL
      WHERE  ADDR1 IS NOT NULL AND ADDR1 LIKE @LOC_VAR+'%' AND charindex(@LOC_VAR,ADDR1)>0
      ;
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
      SET --ADDR1 = LEFT(ADDR1,(charindex(@LOC_VAR,ADDR1)-1)),
          ADDR_2_CNDT = CASE WHEN @CAT = 'ADDR2_KEEP' THEN RIGHT(ADDR2 ,LEN(ADDR2)-charindex(@LOC_VAR,ADDR2)+1)
                                  WHEN @CAT = 'ADDR2_REMOVE' THEN NULL END,
          ADDR2 = NULL, ST_2 = NULL
      WHERE ADDR2 IS NOT NULL 
            AND ADDR2 LIKE @LOC_VAR+'%' AND charindex(@LOC_VAR,ADDR2)>0
      ;
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
      SET 
          ADDR_2_CNDT = CASE WHEN @CAT = 'ADDR2_KEEP' THEN RIGHT(ADDR1 ,LEN(ADDR1)-charindex(@LOC_VAR,ADDR1)+1)
                                  WHEN @CAT = 'ADDR2_REMOVE' THEN NULL END,
          ADDR1 = STAGE.fnGet_FirstPart(ADDR1,CHARINDEX(' '+@LOC_VAR, ADDR1)),    --- REMOVE THIS ONE IF NOT NEEDED
          ST_1 = STAGE.fnGet_FirstPart(ST_1,CHARINDEX(' '+@LOC_VAR, ST_1))
      WHERE ADDR1 IS NOT NULL AND  ADDR1 LIKE '% '+@LOC_VAR+'%' 
      --AND CHARINDEX(@LOC_VAR,ADDR1)>0
      ;
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
      SET 
          ADDR_2_CNDT = CASE WHEN @CAT = 'ADDR2_KEEP' THEN RIGHT(ADDR2 ,LEN(ADDR2)-charindex(@LOC_VAR,ADDR2)+1)
                                  WHEN @CAT = 'ADDR2_REMOVE' THEN NULL END,
          ADDR2 = STAGE.fnGet_FirstPart(ADDR2,CHARINDEX(' '+@LOC_VAR, ADDR2)), --- REMOVE THIS ONE IF NOT NEEDED
          ST_2 = STAGE.fnGet_FirstPart(ST_2,CHARINDEX(' '+@LOC_VAR, ST_2))
      WHERE ADDR2 IS NOT NULL AND  ADDR2 LIKE '% '+@LOC_VAR+'%' 
      --AND CHARINDEX(@LOC_VAR,ADDR2)>0
      ;

      FETCH NEXT FROM iCur into 
      @LOC_TYP, @LOC_VAR, @LOC_STD, @CAT;
      
    END;
    CLOSE iCur; DEALLOCATE iCur;
    
    
    -- MAKE THE ADDR2 STANDARD - Suite to STE, Building to BLDG
    
    UPDATE E
      SET ADDR_2_CNDT = REPLACE(ADDR_2_CNDT,LEFT(ADDR_2_CNDT,charindex(' ',ADDR_2_CNDT)),A.ADDR_STD)
    FROM STAGE.TEMP_ADDR_LAUNDRY E
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(LEFT(ADDR_2_CNDT,charindex(' ',ADDR_2_CNDT)))) = A.ADDR_VAR
    WHERE ADDR_2_CNDT IS NOT NULL 
    AND CAT = 'ADDR2_KEEP'
      ;
    -- This will take care of Floor
    UPDATE E
      SET ADDR_2_CNDT = A.ADDR_STD
    FROM STAGE.TEMP_ADDR_LAUNDRY E
    JOIN REF.ADDR_STD A ON LTRIM(RTRIM(ADDR_2_CNDT)) = A.ADDR_VAR
    WHERE 
    ADDR_2_CNDT IS NOT NULL
    AND CAT = 'ADDR2_KEEP'
      ;

END