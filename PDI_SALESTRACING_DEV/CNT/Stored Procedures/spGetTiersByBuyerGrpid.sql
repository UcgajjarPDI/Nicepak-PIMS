-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CNT].[spGetTiersByBuyerGrpid] 
	@buyerGroupId INT
AS
    BEGIN
       
	       SELECT DISTINCT C.CNT_TIER_LVL
        FROM  [CNT].[CONTRACT] C where C.REC_STAT_CD = 'A'
										and  C.BUYER_GRP_ID = @buyerGroupId;
    END;