CREATE FUNCTION [STAGE].[fnSecondPart]
(@str varchar(MAX), @pos smallint)
RETURNS varchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@ret_str AS varchar(MAX)

  IF LEN(@str) < = @pos
    BEGIN
      SET @ret_str = NULL
    END
  ELSE
    BEGIN
      SELECT @ret_str = LTRIM(RTRIM(SUBSTRING(@str,@pos,LEN(@str)-@pos+1)))
    END
    
   
  RETURN @ret_str
END