CREATE PROCEDURE [REF].[spLoad_Zip_code]
WITH EXEC AS CALLER
AS
BEGIN

  TRUNCATE TABLE REF.ZIP_CODE_FULL;

  INSERT INTO REF.ZIP_CODE_FULL (Zipcode, ZipCodeType, City, State, LocationType, TaxReturnsFiled, EstimatedPopulation, TotalWages)
  SELECT Zipcode, ZipCodeType, City, State, LocationType, TaxReturnsFiled, EstimatedPopulation, TotalWages FROM STG0.ZIP_CODE;


  TRUNCATE TABLE REF.ZIP_CODE;

  INSERT INTO REF.ZIP_CODE (Zipcode, ZipCodeType, City, State, LocationType, TaxReturnsFiled, EstimatedPopulation, TotalWages)
  SELECT Zipcode, ZipCodeType, City, State, LocationType, TaxReturnsFiled, EstimatedPopulation, TotalWages FROM STG0.ZIP_CODE
  WHERE LocationType = 'PRIMARY';
 
END