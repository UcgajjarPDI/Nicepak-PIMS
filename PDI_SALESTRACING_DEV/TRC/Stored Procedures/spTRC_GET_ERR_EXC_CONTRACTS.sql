CREATE PROCEDURE [TRC].[spTRC_GET_ERR_EXC_CONTRACTS]
		 @vSales_Period VARCHAR(10), 
		 @vDIST_ID      VARCHAR(20) = NULL,
		@contractId      VARCHAR(20) = NULL,
		@buyersNm  varchar(100)= null
AS
    BEGIN
        SELECT DISTINCT 
               S.UPD_CNT_ID
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
			  AND C.GROUP_NAME = ISNULL(@buyersNm, C.GROUP_NAME)

    END;