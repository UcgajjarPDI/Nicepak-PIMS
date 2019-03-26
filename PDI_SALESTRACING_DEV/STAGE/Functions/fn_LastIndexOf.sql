CREATE FUNCTION [stage].[fn_LastIndexOf] 
(@String NVARCHAR(MAX)
, @FindString NVARCHAR(MAX))
RETURNS INT
AS 
BEGIN
    DECLARE @ReturnVal INT = 0
    IF CHARINDEX(@FindString,@String) > 0
        SET @ReturnVal = (SELECT LEN(@String) - 
        (CHARINDEX(REVERSE(@FindString),REVERSE(@String)) + 
        LEN(@FindString)) + 2)  
    RETURN @ReturnVal
END