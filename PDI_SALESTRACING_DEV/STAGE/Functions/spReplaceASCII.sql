CREATE FUNCTION [stage].[spReplaceASCII](@inputString VARCHAR(8000))
RETURNS VARCHAR(255)
AS
     BEGIN
         DECLARE @badStrings VARCHAR(100);
         DECLARE @increment INT= 1;
         WHILE @increment <= DATALENGTH(@inputString)
             BEGIN
                 IF(ASCII(SUBSTRING(@inputString, @increment, 1)) < 33)
                     BEGIN
                         SET @badStrings = CHAR(ASCII(SUBSTRING(@inputString, @increment, 1)));
                         SET @inputString = REPLACE(@inputString, @badStrings, '');
                 END;
                 SET @increment = @increment + 1;
             END;
         RETURN @inputString;
     END;