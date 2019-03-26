CREATE FUNCTION [STAGE].[fnMiddlePart]
(@str varchar(MAX), @FirstPart varchar(100), @LastPart Varchar(100))
RETURNS varchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@ret_str AS varchar(MAX)

  SET @ret_str = STAGE.fnSecondPart(@str, len(@FirstPart)+1);
  SET @ret_str = STAGE.fnGet_FirstPart(@ret_str, LEN(@ret_str)-LEN(@LastPart) );
  SET @ret_str = RTRIM(LTRIM(@ret_str));

  RETURN @ret_str
END