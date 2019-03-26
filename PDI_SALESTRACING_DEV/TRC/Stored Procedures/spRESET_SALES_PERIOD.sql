CREATE PROCEDURE [TRC].[spRESET_SALES_PERIOD]
@vSales_Period varchar(10)
WITH EXEC AS CALLER
AS
BEGIN

  -- The proc will set the data load indicator to the desired sales period
  -- the ETL job will use this sales period to find the files and also assign it to data loaded
  
  DECLARE @REC_CNT SMALLINT;
  
  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[SALES_PERIOD] 
  WHERE SALES_PERIOD = @vSales_Period;
  
  -- First make all sales period load indicator = 'N'

  UPDATE [STAGE].[SALES_PERIOD] SET LOAD_IN = 'N'
  WHERE LOAD_IN = 'Y';
  
  IF @REC_CNT > 0 
    BEGIN
      UPDATE [STAGE].[SALES_PERIOD] SET LOAD_IN = 'Y'
      WHERE SALES_PERIOD = @vSales_Period;
    END
  ELSE
    BEGIN
      INSERT INTO [STAGE].[SALES_PERIOD] 
        (SALES_PERIOD, LOAD_IN, STATUS)
      VALUES 
        (@vSales_Period, 'Y', 'TEMP');
    END

END