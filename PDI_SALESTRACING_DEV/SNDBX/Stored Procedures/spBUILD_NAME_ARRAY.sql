CREATE PROCEDURE [SNDBX].[spBUILD_NAME_ARRAY]

WITH EXEC AS CALLER
AS
BEGIN  
 
  --DECLARE @MatchingCount INT
  --DECLARE @WordTable1 TABLE(String VARCHAR(MAX))
  --DECLARE @WordTable2 TABLE(String VARCHAR(MAX))

  DECLARE db_cursor CURSOR FOR SELECT CMPNY_ID, NM FROM SNDBX.TEST_1;
  DECLARE @String1 VARCHAR(256);
  DECLARE @CID INT;
  
  OPEN db_cursor;
  
  FETCH NEXT FROM db_cursor INTO @CID, @String1;
    WHILE @@FETCH_STATUS = 0  
      BEGIN  
        ;WITH   CTE (Word, String1) AS
          (
          SELECT  CASE    WHEN CHARINDEX(' ', @String1) > 0   THEN SUBSTRING(@String1, 1, CHARINDEX(' ', @String1)-1) ELSE @String1   END AS Word
                  , CASE  WHEN CHARINDEX(' ', @String1) > 0   THEN SUBSTRING(@String1, CHARINDEX(' ', @String1)+1, LEN(@String1)) ELSE @String1   END AS String1
          UNION ALL
          SELECT  CASE    WHEN CHARINDEX(' ', C.String1) > 0  THEN SUBSTRING(C.String1, 1, CHARINDEX(' ', C.String1)-1)   ELSE C.String1  END AS Word
                  , CASE  WHEN CHARINDEX(' ', C.String1) > 0  THEN SUBSTRING(C.String1, CHARINDEX(' ', C.String1)+1, LEN(C.String1))  ELSE '' END AS String1
          FROM    CTE C
          WHERE   LEN(C.String1) < LEN(@String1)  AND C.String1 <> ''
          )
          
          INSERT INTO SNDBX.TEMP_NM_ARRAY_1 ( CMPNY_ID, NM_PARTS)
          SELECT  @CID, Word    FROM    CTE;
          
          FETCH NEXT FROM db_cursor INTO @CID, @String1;
      END;
      
  CLOSE db_cursor;
  DEALLOCATE db_cursor;

RETURN  --@MatchingCount
END