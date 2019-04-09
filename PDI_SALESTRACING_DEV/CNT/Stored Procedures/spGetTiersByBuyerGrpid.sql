-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CNT].[spGetTiersByBuyerGrpid] 
	@buyerGroupId INT
AS
    BEGIN
        SELECT DISTINCT 
                C.CNT_NR + ' - ' + C.CNT_TIER_LVL AS TierId, 
               C.CNT_DESC AS Description
        FROM [CNT].[CONTRACT] C
        WHERE C.REC_STAT_CD = 'A'
              AND C.BUYER_GRP_ID = @buyerGroupId
			and c.CNT_TIER_LVL != '1'
    END;