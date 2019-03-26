CREATE FUNCTION STAGE.fnLesserOf
(@val1 float, @val2 float)
RETURNS float
AS
BEGIN

  if @val1 < @val2
    return @val1
  return isnull(@val2,@val1)

END