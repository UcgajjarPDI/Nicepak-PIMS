CREATE FUNCTION [STAGE].[fnLastWord]
(@str nvarchar(255))
RETURNS nvarchar(100)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@ret_str AS varchar(100)


SET @str = LTRIM(RTRIM(@str));

IF CHARINDEX(' ', REVERSE(@str))>0
  BEGIN
    select @ret_str = LTRIM(RTRIM(RIGHT(@str ,
                      CHARINDEX(' ', REVERSE(@str))-1)));
  END
ELSE
  BEGIN
    SET @ret_str = LTRIM(RTRIM(@str))
  END 
  
RETURN @ret_str
END