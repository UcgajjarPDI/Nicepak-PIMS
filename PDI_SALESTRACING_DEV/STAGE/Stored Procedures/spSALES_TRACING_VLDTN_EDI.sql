﻿CREATE PROCEDURE [STAGE].[spSALES_TRACING_VLDTN_EDI]
@SalesPeriod varchar(10)
WITH EXEC AS CALLER
AS
BEGIN

  EXEC [PDI_SALESTRACING_TEST].[STAGE].spTRC_VLDTN_LOAD_SAF_TEMP @vSalesPeriod = @SalesPeriod;
  EXEC [PDI_SALESTRACING_TEST].[STAGE].spTRC_VLDTN_LOAD_REF_TABLE;
  EXEC [PDI_SALESTRACING_TEST].[STAGE].spTRC_VLDTN_CONTID_CORR @vSalesPeriod = @SalesPeriod;
  EXEC [PDI_SALESTRACING_TEST].[STAGE].spTRC_VLDTN_RUN_CALC @vSalesPeriod = @SalesPeriod;
  EXEC [PDI_SALESTRACING_TEST].[STAGE].spTRC_VLDTN_ERROR @vSalesPeriod = @SalesPeriod;

END