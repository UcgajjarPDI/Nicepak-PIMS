-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CNT].[spGetPriceAuthCntByBuyerGrpid] 
@buyerGroupId INT
AS
    BEGIN
        SELECT DISTINCT 
               P.MFG_CNT_NR + ' - '  + c.CNT_TIER_LVL AS MFG_CNT_NR 
        FROM [SNDBX].[PRC_AUTH_EB] P
             JOIN [CNT].[CONTRACT] C ON C.CNT_NR = P.MFG_CNT_NR
                                        AND C.REC_STAT_CD = 'A'
        WHERE PRC_AUTH_STAT_CD = 'P'
              AND C.BUYER_GRP_ID = @buyerGroupId;
    END;