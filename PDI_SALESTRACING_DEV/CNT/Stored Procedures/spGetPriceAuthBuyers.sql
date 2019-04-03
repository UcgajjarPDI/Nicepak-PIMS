CREATE PROCEDURE CNT.spGetPriceAuthBuyers
AS
    BEGIN
        SELECT DISTINCT 
               C.BUYER_GRP_ID AS buyerGrpId,
               G.CMS_NM AS gpoName
        FROM [SNDBX].[PRC_AUTH_EB] P
             JOIN [CNT].[CONTRACT] C ON C.CNT_NR = P.MFG_CNT_NR
                                        AND C.REC_STAT_CD = 'A'
             JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
			   WHERE PRC_AUTH_STAT_CD = 'P' 
    END;