CREATE FUNCTION [STAGE].[fnNextWord]
(
@str AS nvarchar(255), @WrdAfter varchar(40)
)
RETURNS nvarchar(100)
AS
BEGIN

DECLARE
  @first_part AS varchar(100),
  @next_part AS varchar(100),
  @next_word AS varchar(100)

  SET @first_part = LTRIM(RTRIM(STAGE.fnGet_FirstPart(@str, CHARINDEX(@WrdAfter,@str)+LEN(@WrdAfter))));
  SET @next_part = LTRIM(RTRIM(STAGE.fnSecondPart(@str,LEN(@first_part)+1)));  
  SET @next_word = LTRIM(RTRIM(STAGE.fnFirstWord(@next_part)));
          
RETURN @next_word

END