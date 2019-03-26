CREATE PROCEDURE [TRC].[spUPDATE_NONEDI_SALESPEIOD]
@vSales_Period varchar(10)
WITH EXEC AS CALLER
AS
BEGIN

  -- The proc will assign the correct sales period to all new non-edi data loads right
  --  after ETL trunactes and loads the STG0 daily table
  
  DECLARE @REC_CNT SMALLINT;
  
  SELECT @REC_CNT = COUNT(*) 
  FROM STG0.SALES_TRACING_NON_EDI_ETL;
  
  IF @REC_CNT > 0 
    BEGIN
      UPDATE STG0.SALES_TRACING_NON_EDI_ETL
      SET SALES_PERIOD = @vSales_Period;
    END
    
END