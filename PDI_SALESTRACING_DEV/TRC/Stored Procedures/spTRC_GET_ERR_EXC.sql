CREATE PROCEDURE [TRC].[spTRC_GET_ERR_EXC] @vSales_Period VARCHAR(10)=NULL, 
                                          @vDIST_ID      VARCHAR(20) = NULL, 
                                          @contractId    VARCHAR(20) = NULL, 
                                          @buyerGrp      VARCHAR(50) = NULL
AS
    BEGIN
        SELECT X.TRC_CNT_ID AS UPD_CNT_ID, 
               X.PROD_ID AS UPD_PROD_ID, 
               C.BUYER_GRP_ID, 
               C.BUYER_GRP_NM AS GROUP_NAME ,
               CASE
                   WHEN X.DAYS_EXPIRED BETWEEN 31 AND 60
                   THEN '30-60 DAYS'
                   WHEN X.DAYS_EXPIRED BETWEEN 61 AND 90
                   THEN '60-90 DAYS'
                   WHEN X.DAYS_EXPIRED > 90
                   THEN '90 DAYS or more'
               END AS EXP_DAYS,
			   X.UPD_CNT_ID AS Replacing_With,
			   CONVERT(VARCHAR, CONVERT(DATE, C.CNT_EXP_DT), 101) AS CNT_EXP_DT
        FROM STAGE.TRC_CNT_CORR_XREF X
             JOIN CNT.[CONTRACT] C ON X.TRC_CNT_ID = C.CNT_NR
                                      AND C.REC_STAT_CD = 'A'
        WHERE RECON_STAT_CD = 'P' AND RECON_TYP = 'EXC'
		AND C.BUYER_GRP_NM = ISNULL(@buyerGrp, C.BUYER_GRP_NM)
		AND X.TRC_CNT_ID = ISNULL(@contractId, X.TRC_CNT_ID)
        ORDER BY X.DAYS_EXPIRED DESC;

    END;