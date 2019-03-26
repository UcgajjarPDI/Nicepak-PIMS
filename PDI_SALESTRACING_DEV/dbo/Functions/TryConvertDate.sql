CREATE FUNCTION dbo.TryConvertDate
(
  @value varchar(max)
)
RETURNS date
AS
BEGIN
  RETURN (SELECT CONVERT(date, CASE 
    WHEN ISDATE(@value) = 1 THEN @value END)
  );
END
