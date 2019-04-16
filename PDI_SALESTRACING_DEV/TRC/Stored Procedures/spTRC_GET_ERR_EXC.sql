CREATE PROCEDURE [TRC].[spTRC_GET_ERR_EXC] @vSales_Period VARCHAR(10), 
                                          @vDIST_ID      VARCHAR(20) = NULL,
										  @contractId      VARCHAR(20) = NULL,
										  @buyerGrp VARCHAR (50) = NULL	
AS
    BEGIN
        SELECT DISTINCT 
               S.UPD_CNT_ID, 
               S.UPD_PROD_ID, 
               C.GROUP_NAME, 
               CONVERT(VARCHAR, CONVERT(DATE, S.CNT_EXP_DT), 101) AS CNT_EXP_DT,
               CASE
                   WHEN S.CNT_EXP_DAYS BETWEEN 1 AND 30
                   THEN '30 DAYS or less'
                   WHEN S.CNT_EXP_DAYS BETWEEN 31 AND 90
                   THEN '30-90 DAYS'
                   WHEN S.CNT_EXP_DAYS > 90
                   THEN '90 DAYS or more'
               END AS EXP_DAYS, 
               X.UPD_CNT_ID AS Replacing_With, 
               L.LKUP_CD_DES AS ERROR_DESC,
			   S.CNT_EXP_DAYS
        FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
             JOIN [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] C ON S.UPD_CNT_ID = C.CONTRACT_NO
                                                                     AND C.CURRENT_INDICATOR = 'Y'
             JOIN PDI_SALESTRACING_DEV.REF.LKUP_CD L ON S.ERR_CD = L.LKUP_CD
                                                        AND L.LKUP_DOMAIN_CD = 'SLS_TRC_CALC'
                                                        AND L.CD_TYP = 'ERROR'
             LEFT JOIN PDI_SALESTRACING_DEV.STAGE.TRC_CNT_CORR_XREF X ON S.TRC_CNT_ID = X.TRC_CNT_ID
                                                                         AND S.UPD_PROD_ID = X.PROD_ID
        WHERE S.RBT_CALC_STAT = 'E'--  S.Err_Cd = 'EXC'
              AND S.SALES_PERIOD = ISNULL(@vSales_Period, S.SALES_PERIOD)
              AND S.DIST_ID = ISNULL(@vDIST_ID, S.DIST_ID)
			  AND S.UPD_CNT_ID = ISNULL(@contractId, S.UPD_CNT_ID)
			  AND C.GROUP_NAME = ISNULL(@buyerGrp, C.GROUP_NAME)
			Order by S.CNT_EXP_DAYS
    END;

	--SELECT * FROM [STAGE].[SALES_TRACING_CURR] S