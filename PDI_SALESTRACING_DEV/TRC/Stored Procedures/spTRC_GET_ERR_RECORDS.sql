CREATE PROCEDURE [TRC].[spTRC_GET_ERR_RECORDS] 
( @vSales_Period varchar(10), @vDIST_ID VARCHAR(20) = NULL
,@vCNT_ID varchar(30) = NULL, @vPROD_ID varchar(15) = NULL, @vErr_Cd varchar(6) = NULL)
WITH EXEC AS CALLER
AS
BEGIN
/*
ERR_CD	                                                            ERR_DESC
PRODE1	                                                            No Such product
PRODE2	                                                            Unknown Product on Contract
UOME1	                                                            UOM Could not be calculated
CNTE1	                                                            Invalid Contract Number
CNTE2	                                                            Contract Expired
exec [TRC].[spTRC_GET_ERR_RECORDS] @vSales_Period = '20181001'
exec [TRC].[spTRC_GET_ERR_RECORDS] @vSales_Period = '20180901'
exec [TRC].[spTRC_GET_ERR_RECORDS] @vSales_Period = '20181001',@vErr_Cd = 'Product not on Contract'
exec [TRC].[spTRC_GET_ERR_RECORDS] @vSales_Period = '20181001',@vErr_Cd = 'Invalid Product ID'

*/

DECLARE @CNT_NR VARCHAR(20);
DECLARE @RecCnt int;

SELECT distinct DIST_ID, DIST_NR, SALES_PERIOD,TRC_CNT_ID,TRC_PROD_ID, ERR_CD as Err_Desc
--,convert(char(10),TRC_CNT_EXP_DT,101) as CNT_EXP_DT
FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
WHERE S.SALES_PERIOD = @vSales_Period
and S.DIST_ID = isnull(@vDIST_ID,S.DIST_ID)
and S.TRC_CNT_ID = isnull(@vCNT_ID,S.TRC_CNT_ID)
and S.TRC_PROD_ID = isnull(@vProd_ID,S.TRC_PROD_ID)
--and S.rtrim(ltrim(ERR_CD)) = isnull(@vErr_Cd, ERR_CD)
and S.ERR_CD is not NULL
--and S.rtrim(ltrim(ERR_CD)) = 'Product not on Contract'
--and err_cd like '%'+@vErr_cd + '%'
--and S.ERR_CD in (isnull(@vErr_Cd,S.Err_Cd))

END