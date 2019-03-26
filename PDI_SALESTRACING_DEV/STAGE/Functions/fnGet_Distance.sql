CREATE FUNCTION [STAGE].[fnGet_Distance]
(@zip_1 nvarchar(20), @zip_2 nvarchar(20))
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @distnace AS INT;
  DECLARE @LAT1 AS FLOAT, @LONG1 AS FLOAT, @LAT2 AS FLOAT, @LONG2 AS FLOAT;
  
  SELECT @LAT1 = Lat, @LONG1 = [Long]  FROM STG0.ZIP_CODE WHERE Zipcode = @zip_1;
  SELECT @LAT2 = Lat, @LONG2 = [Long]  FROM STG0.ZIP_CODE WHERE Zipcode = @zip_2;
  
--    SELECT @distnace = GEOGRAPHY::Point(@LAT1, @LONG1 , 4326).STDistance(GEOGRAPHY::Point(@LONG2, -74.62, 4326))
    SELECT @distnace = GEOGRAPHY::Point(@LAT1, @LONG1 , 4748).STDistance(GEOGRAPHY::Point(@LAT2, @LONG2, 4748))
  
 --     SET @distnace = @distnace * 0.000621371;

RETURN @distnace
END