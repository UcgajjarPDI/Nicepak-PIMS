CREATE FUNCTION [STAGE].[fnWordCount]
(
@str AS nvarchar(255)
)
RETURNS nvarchar(100)
AS
BEGIN

DECLARE @WRD_cnt AS int

IF LEN(@str)>0
  BEGIN
    SET @WRD_CNT = SUM(LEN(@str) - LEN(REPLACE(@str, ' ', '')) + 1);
  END
ELSE
  BEGIN
    SET @WRD_CNT = 0;
  END                     
                      
RETURN @WRD_CNT

END