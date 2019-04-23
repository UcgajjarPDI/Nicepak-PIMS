CREATE PROCEDURE [TRC].[spTRC_GET_ERR_EXC_CONTRACTS] @vSales_Period VARCHAR(10)  = NULL, 
                                                    @vDIST_ID      VARCHAR(20)  = NULL, 
                                                    @contractId    VARCHAR(20)  = NULL, 
                                                    @buyersNm      VARCHAR(100) = NULL
AS
    BEGIN
        SELECT DISTINCT 
               X.TRC_CNT_ID AS UPD_CNT_ID
        FROM STAGE.TRC_CNT_CORR_XREF X
             JOIN CNT.[CONTRACT] C ON X.TRC_CNT_ID = C.CNT_NR
                                      AND C.REC_STAT_CD = 'A'
        WHERE RECON_STAT_CD = 'P'
              AND RECON_TYP = 'EXC'
              AND C.BUYER_GRP_NM = ISNULL(@buyersNm, C.BUYER_GRP_NM)
              AND X.TRC_CNT_ID = ISNULL(@contractId, X.TRC_CNT_ID)
        ORDER BY X.TRC_CNT_ID DESC;
    END;