﻿CREATE PROCEDURE [STAGE].[spNAME_LAUNDRY_3K] 
WITH EXEC AS CALLER
AS
BEGIN  
  DECLARE @cnt smallint = 1;
  
  UPDATE STAGE.TRC_ENDUSER_3K
  SET UPD_NAME = DISTACCTSHIPNAME;
  
  UPDATE STAGE.TRC_ENDUSER_3K 
    SET UPD_NAME =  STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(REPLACE(UPD_NAME, '-', ' '), '''S', 'S'), '/', ' '),'?', ' ')) ;
  
  -- REMOVE NUMERIC WORD FROM THE END
  UPDATE STAGE.TRC_ENDUSER_3K 
    SET UPD_NAME = STAGE.fnGet_FirstPart(UPD_NAME, CHARINDEX(STAGE.fnLastWord(UPD_NAME),REVERSE(UPD_NAME)) ) 
  WHERE ISNUMERIC(STAGE.fnLastWord(UPD_NAME)) = 1;  

  -- FIX LAST WORD
  UPDATE T
    SET UPD_NAME = REPLACE(UPD_NAME, A.ADDR_VAR, A.ADDR_STD ) 
  FROM STAGE.TRC_ENDUSER_3K T
  JOIN REF.ADDR_STD A ON STAGE.fnLastWord(T.UPD_NAME) = LTRIM(RTRIM(A.ADDR_VAR))
  AND A.ADDR_TYP = 'NAME';
  
  -- FIX FIRST WORD
  UPDATE T
    SET UPD_NAME = REPLACE(UPD_NAME, A.ADDR_VAR, A.ADDR_STD ) 
  FROM STAGE.TRC_ENDUSER_3K T
  JOIN REF.ADDR_STD A ON STAGE.fnFirstWord(T.UPD_NAME) = LTRIM(RTRIM(A.ADDR_VAR))
  AND A.ADDR_TYP = 'NAME';
  
  -- FIX WORDS IN THE MIDDLE
  -- need to run multiple times to fix multiple issues
  WHILE @cnt <=5
    BEGIN
      UPDATE T
        SET UPD_NAME = REPLACE(UPD_NAME, A.ADDR_VAR, A.ADDR_STD ) 
      FROM STAGE.TRC_ENDUSER_3K T
      JOIN REF.ADDR_STD A ON T.UPD_NAME LIKE '% '+A.ADDR_VAR+' %'
      AND A.ADDR_TYP = 'NAME';
      
      SET @cnt = @cnt + 1
    END 
    
  UPDATE STAGE.TRC_ENDUSER_3K
  SET PROPER_NM = UPD_NAME;
  
    UPDATE STAGE.TRC_ENDUSER_3K 
    SET PROPER_NM =  STAGE.fnRemoveSpace(REPLACE(REPLACE(REPLACE(UPD_NAME, 'LUM', ' '), 'LLC', ' '),'INC', ' ')) ;
    
  UPDATE T
        SET PROPER_NM  = STAGE.fnRemoveSpace(REPLACE(PROPER_NM , A.ADDR_STD, ' ') )
      FROM STAGE.TRC_ENDUSER_3K T
      JOIN REF.ADDR_STD A ON PROPER_NM LIKE '% '+A.ADDR_STD
      AND A.ADDR_TYP = 'NAME';
  
  SET @cnt = 1;
  
  WHILE @cnt <=5
    BEGIN
      UPDATE T
        SET PROPER_NM  = STAGE.fnRemoveSpace(REPLACE(PROPER_NM , A.ADDR_STD, ' ') )
      FROM STAGE.TRC_ENDUSER_3K T
      JOIN REF.ADDR_STD A ON PROPER_NM LIKE '% '+A.ADDR_STD+' %'
      AND A.ADDR_TYP = 'NAME';
      
      SET @cnt = @cnt + 1
    END 
  
  END;