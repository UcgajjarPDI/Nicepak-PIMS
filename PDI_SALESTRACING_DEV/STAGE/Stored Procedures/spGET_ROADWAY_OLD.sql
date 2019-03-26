CREATE PROCEDURE [STAGE].[spGET_ROADWAY_OLD] 
WITH EXEC AS CALLER
AS
BEGIN

DECLARE @LOC_TYP VARCHAR(20), @LOC_VAR VARCHAR(20), @LOC_STD VARCHAR(20), @CAT VARCHAR(20);
 
   DECLARE iCur CURSOR FOR
    SELECT ADDR_TYP, ADDR_VAR, ADDR_STD 
    FROM REF.ADDR_STD
    WHERE CAT = 'Location'
    --AND ADDR_VAR = 'HIGHWAY'
    ;
    
  OPEN iCur
    FETCH NEXT FROM iCur into 
    @LOC_TYP, @LOC_VAR, @LOC_STD;
    
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @LOC_VAR = LTRIM(RTRIM(@LOC_VAR));
   
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_1 = @LOC_STD, 
          ST_NM_1 = STAGE.fnGet_FirstPart(ST_1,CHARINDEX(' '+@LOC_VAR, ST_1)),
          ADDR_SRC_CNFD = 100, ADDR_SRCE = 1
      WHERE STAGE.fnLastWord(ST_1) = @LOC_VAR
      AND ST_1 IS NOT NULL  
      ;

      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_2 = @LOC_STD, 
          ST_NM_2 = STAGE.fnGet_FirstPart(ST_2,CHARINDEX(' '+@LOC_VAR, ST_2)),
          ADDR_SRC_CNFD = 100, ADDR_SRCE = 2
      WHERE STAGE.fnLastWord(ST_2) = @LOC_VAR
      AND ST_2 IS NOT NULL 
      AND ADDR_SRCE IS NULL ;
            
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_1 = @LOC_STD, 
          ST_NM_1 = STAGE.fnGet_FirstPart(ST_1,CHARINDEX(' '+@LOC_VAR+' ', ST_1)),
          SUFFIX = STAGE.fnSecondPart(ST_1, CHARINDEX(' '+@LOC_VAR+' ', ST_1)+LEN(@LOC_VAR)+2) , 
          ADDR_SRC_CNFD = 90,  ADDR_SRCE = 1
      WHERE ST_1 LIKE '% '+@LOC_VAR+' %'
      AND ST_1 IS NOT NULL
      AND ADDR_SRCE IS NULL;
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_1 = @LOC_STD, 
          ST_NM_1 = NULL,
          SUFFIX = STAGE.fnSecondPart(ST_1, CHARINDEX(' '+@LOC_VAR+' ', ST_1)+LEN(@LOC_VAR)+2) ,
          ADDR_SRC_CNFD = 90, ADDR_SRCE = 1
      WHERE STAGE.fnFirstWord(ST_1) = @LOC_VAR
      AND ST_1 IS NOT NULL
      AND ADDR_SRCE IS NULL
      AND STAGE.fnFirstWord(ST_1) <> 'ST';
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_2 = @LOC_STD, 
          ST_NM_2 = STAGE.fnGet_FirstPart(ST_2,CHARINDEX(' '+@LOC_VAR+' ', ST_2)),
          SUFFIX = STAGE.fnSecondPart(ST_2, CHARINDEX(' '+@LOC_VAR+' ', ST_2)+LEN(@LOC_VAR)+2) , 
          ADDR_SRC_CNFD = 90,  ADDR_SRCE = 2
      WHERE ST_2 LIKE '% '+@LOC_VAR+' %'
      AND ST_2 IS NOT NULL
      AND ADDR_SRCE IS NULL ;
      
      UPDATE STAGE.TEMP_ADDR_LAUNDRY
        SET 
          ST_TYP_2 = @LOC_STD, 
          ST_NM_2 = NULL,
          SUFFIX = STAGE.fnSecondPart(ST_2, CHARINDEX(' '+@LOC_VAR+' ', ST_2)+LEN(@LOC_VAR)+2) ,
          ADDR_SRC_CNFD = 90, ADDR_SRCE = 1
      WHERE STAGE.fnFirstWord(ST_2) = @LOC_VAR
      AND ST_2 IS NOT NULL
      AND ADDR_SRCE IS NULL
      AND STAGE.fnFirstWord(ST_2) <> 'ST';
      
              
      FETCH NEXT FROM iCur into 
      @LOC_TYP, @LOC_VAR, @LOC_STD;
      
    END;
    CLOSE iCur; DEALLOCATE iCur;
 
 
    
END