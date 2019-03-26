CREATE FUNCTION [STAGE].[fnFirstWord]
(
@str AS nvarchar(255)
)
RETURNS nvarchar(100)
AS
BEGIN

DECLARE
@ret_str AS varchar(100)

IF CHARINDEX(' ',(@str))>0
  BEGIN
    select @ret_str = LTRIM(RTRIM(left(@str , CHARINDEX(' ',(@str))-1)));
  END
ELSE
  BEGIN
    SET @ret_str = LTRIM(RTRIM(@str))
  END                     
                      
RETURN @ret_str

END