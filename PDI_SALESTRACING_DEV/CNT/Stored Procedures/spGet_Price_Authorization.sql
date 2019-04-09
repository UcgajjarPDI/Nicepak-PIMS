-- =============================================
-- Author: HABIB TARAFDER
-- Create date: 03/28/2019
-- Description:	PRICE AUTHORIZATION aggregate
-- =============================================
CREATE PROCEDURE [CNT].[spGet_Price_Authorization]-- 115, null, null
	 @buyerGroupId INT,
	 @mfgCntNr varchar(7) = null
AS
    BEGIN
       SELECT P.GPO_MBR_ID, 
               P.GPO_MBR_NM AS GPOCompany, 
			   CM.CMPNY_NM AS PDICompany,
			   S.[TOTAL SALES PRIOR YEAR] AS Sales, 
			   0 AS ParSales,
			   0 AS NetworkSales,
			   1 AS CurrTier,
               P.TIER_NR AS ReqtTier,
			   CM.BUYER_INDICATOR AS BI		
        FROM [SNDBX].[PRC_AUTH_EB] P -- REMOVE THIS LINE AND COMMENT OUT NEXT LINE - WHEN WE GO LIVE
             --[CNT].[PRC_AUTH_EB] P
             JOIN [CNT].[CONTRACT] C ON C.CNT_NR = P.MFG_CNT_NR
                                        AND C.REC_STAT_CD = 'A'
										AND C.BUYER_GRP_ID = @buyerGroupId
             JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
             JOIN CMPNY.CMPNY_SALES S ON P.CMPNY_ID = S.CMPNY_ID
             JOIN CMPNY.COMPANY CM ON P.CMPNY_ID = CM.CMPNY_ID
        WHERE PRC_AUTH_STAT_CD = 'P' 
			AND (ISNULL(@mfgCntNr,'') = '' or P.MFG_CNT_NR = @mfgCntNr)
		ORDER BY P.GPO_MBR_NM

    END;