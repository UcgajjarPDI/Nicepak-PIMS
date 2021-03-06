﻿CREATE PROCEDURE [TRC].[spTRC_GET_ERR_PNC]
@vSales_Period varchar(10), @vDIST_ID varchar(20) = null, @vCNT_ID varchar(30) = null, @vPROD_ID varchar(15) = null
WITH EXEC AS CALLER
AS
BEGIN

SELECT DISTINCT 
  SALES_PERIOD, 
  S.UPD_CNT_ID as CNT_ID, 
  S.UPD_PROD_ID as PROD_ID,
  C.Group_Name as Buyer_Group,
  X.UPD_CNT_ID AS Replacing_With,
  L.LKUP_CD_DES as Err_Desc
FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] C 
    ON S.UPD_CNT_ID = C.CONTRACT_NO and C.CURRENT_INDICATOR = 'Y'
  JOIN PDI_SALESTRACING_DEV.REF.LKUP_CD L 
    ON S.ERR_CD = L.LKUP_CD AND L.LKUP_DOMAIN_CD = 'SLS_TRC_CALC' AND L.CD_TYP = 'ERROR'
  LEFT JOIN PDI_SALESTRACING_DEV.STAGE.TRC_CNT_CORR_XREF X 
    ON S.UPD_CNT_ID = X.TRC_CNT_ID AND S.UPD_PROD_ID = X.PROD_ID
WHERE S.Err_Cd = 'PNC' 
  AND S.SALES_PERIOD = isnull(@vSales_Period, S.SALES_PERIOD)
  AND S.DIST_ID = isnull(@vDIST_ID,S.DIST_ID)
  ORDER BY S.UPD_CNT_ID
END