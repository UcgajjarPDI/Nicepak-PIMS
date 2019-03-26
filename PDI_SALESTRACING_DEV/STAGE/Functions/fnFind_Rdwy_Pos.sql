CREATE FUNCTION [STAGE].[fnFind_Rdwy_Pos]
(@ST nvarchar(255), @AVAR varchar(50))
RETURNS smallint
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@POS AS SMALLINT;

  WHILE CHARINDEX(' ',@ST)>0
  BEGIN
    --SET @ST = RTRIM(STAGE.fnGet_FirstPart(@ST, CHARINDEX(STAGE.fnLastWord(@ST),@ST)-1));
    SET @ST = RTRIM(STAGE.fnGet_FirstPart(@ST, LEN(@ST)-CHARINDEX(STAGE.fnLastWord(@ST),REVERSE(@ST))-1));
    IF STAGE.fnLastWord(@ST) = @AVAR
      BEGIN
        SET @POS = LEN(@ST ) - LEN(@AVAR)
        BREAK
      END
  END
  
  RETURN @POS
END