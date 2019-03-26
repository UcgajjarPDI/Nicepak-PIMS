CREATE FUNCTION [STAGE].[fnGet_FirstPart]
(@str nvarchar(255), @pos smallint)
RETURNS nvarchar(100)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@ret_str AS varchar(100)

  IF LEN(ltrim(RTRIM(@str))) < = @pos
    BEGIN
      SET @ret_str = NULL
    END
  ELSE
    BEGIN
      SELECT @ret_str =  RTRIM(LEFT(@str,@pos))
    END
    
   
  RETURN @ret_str
END