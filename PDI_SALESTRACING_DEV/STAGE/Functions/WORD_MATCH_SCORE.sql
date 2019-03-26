CREATE FUNCTION [STAGE].[WORD_MATCH_SCORE](@MD_NM VARCHAR(MAX), @V_NM  VARCHAR(MAX))
RETURNS FLOAT
AS
BEGIN
 
DECLARE @MatchingCount FLOAT, @SCORE FLOAT , @MD_NM_CNT FLOAT, @V_NM_CNT FLOAT
DECLARE @WordTable1 TABLE(String VARCHAR(MAX))
DECLARE @WordTable2 TABLE(String VARCHAR(MAX))
 
--SELECT  @String1 = CASE WHEN @CaseSensitive = 0 THEN UPPER(@String1)    ELSE @String1   END
--SELECT  @V_NM = CASE WHEN @CaseSensitive = 0 THEN UPPER(@V_NM)    ELSE @V_NM   END
 
--SELECT  @MD_NM = REPLACE(REPLACE(REPLACE(@MD_NM, ' ', ' X'), 'X ', ''), 'X', '')
--SELECT  @V_NM = REPLACE(REPLACE(REPLACE(@V_NM, ' ', ' X'), 'X ', ''), 'X', '')


 IF @MD_NM = @V_NM 
  BEGIN
    SET @SCORE = 100
  END
 ELSE
  BEGIN
    ;WITH   CTE (Word, String1) AS
    (
    SELECT  CASE    WHEN CHARINDEX(' ', @MD_NM) > 0   THEN SUBSTRING(@MD_NM, 1, CHARINDEX(' ', @MD_NM)-1) ELSE @MD_NM   END AS Word
            , CASE  WHEN CHARINDEX(' ', @MD_NM) > 0   THEN SUBSTRING(@MD_NM, CHARINDEX(' ', @MD_NM)+1, LEN(@MD_NM)) ELSE @MD_NM   END AS String1
    UNION ALL
    SELECT  CASE    WHEN CHARINDEX(' ', C.String1) > 0  THEN SUBSTRING(C.String1, 1, CHARINDEX(' ', C.String1)-1)   ELSE C.String1  END AS Word
            , CASE  WHEN CHARINDEX(' ', C.String1) > 0  THEN SUBSTRING(C.String1, CHARINDEX(' ', C.String1)+1, LEN(C.String1))  ELSE '' END AS String1
    FROM    CTE C
    WHERE   LEN(C.String1) < LEN(@MD_NM)  AND C.String1 <> ''
    )
    INSERT  INTO    @WordTable1
    SELECT  Word    FROM    CTE
     
    ;WITH   CTE2 (Word, String2) AS
    (
    SELECT  CASE    WHEN CHARINDEX(' ', @V_NM) > 0   THEN SUBSTRING(@V_NM, 1, CHARINDEX(' ', @V_NM)-1) ELSE @V_NM   END AS Word
            , CASE  WHEN CHARINDEX(' ', @V_NM) > 0   THEN SUBSTRING(@V_NM, CHARINDEX(' ', @V_NM)+1, LEN(@V_NM)) ELSE @V_NM   END AS String2
    UNION ALL
    SELECT  CASE    WHEN CHARINDEX(' ', C.String2) > 0  THEN SUBSTRING(C.String2, 1, CHARINDEX(' ', C.String2)-1)   ELSE C.String2  END AS Word
            , CASE  WHEN CHARINDEX(' ', C.String2) > 0  THEN SUBSTRING(C.String2, CHARINDEX(' ', C.String2)+1, LEN(C.String2))  ELSE '' END AS String2
    FROM    CTE2 C
    WHERE   LEN(C.String2) < LEN(@V_NM)  AND C.String2 <> ''
    )
    INSERT  INTO    @WordTable2
    SELECT  Word    FROM    CTE2
     
    ;WITH   CTE3    (Word, WordMatchCount) AS
    (
    SELECT  T1.String AS Word, COUNT(*) AS WordMatchCount
    FROM    @WordTable1 T1
    INNER JOIN  @WordTable2 T2  ON  T1.String = T2.String
    GROUP BY    T1.String
    )
    SELECT  @MatchingCount = ISNULL(SUM(WordMatchCount), 0) FROM CTE3;
    SET @MD_NM_CNT = STAGE.fnWordCount(@MD_NM);
    SET @V_NM_CNT = STAGE.fnWordCount(@V_NM);
    
    SET @SCORE = CONVERT(INT, (@MatchingCount/@V_NM_CNT)*100)

/*
    SET @SCORE = CASE 
                  WHEN @MD_NM_CNT < @V_NM_CNT THEN CONVERT(INT, (@MatchingCount/@V_NM_CNT)*100)
                  WHEN @MD_NM_CNT > @V_NM_CNT THEN CONVERT(INT, (@MatchingCount/@V_NM_CNT)*100)
                  ;*/
  END;
  
  RETURN  @SCORE
END