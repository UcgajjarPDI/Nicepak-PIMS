CREATE FUNCTION [STAGE].[fnSecondWord]
(
@str AS nvarchar(255)
)
RETURNS nvarchar(100)
AS
BEGIN

DECLARE
@first_word AS varchar(100),
@second_part AS varchar(100),
@second_word AS varchar(100)

IF CHARINDEX(' ',(@str))>0
  BEGIN
    select @first_word = LTRIM(RTRIM(left(@str , CHARINDEX(' ',(@str))-1)));    
    SELECT @second_part = LTRIM(RTRIM(STAGE.fnSecondPart(@str,LEN(@first_word)+1)));  
    IF CHARINDEX(' ',(@second_part))>0
      BEGIN
        SELECT @second_word = LTRIM(RTRIM(left(@second_part , CHARINDEX(' ',(@second_part))-1)));
      END
    ELSE
      BEGIN
        SET @second_word = @second_part
      END
  END
ELSE
  BEGIN
    SET @second_word = NULL
  END                     
                      
RETURN @second_word

END