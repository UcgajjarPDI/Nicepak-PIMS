-- =============================================
-- Author: HABIB TARAFDER
-- Create date: 03/28/2019
-- Description:	PRICE AUTHORIZATION aggregate
-- =============================================
CREATE PROCEDURE [CNT].[spUpdateBuyersGroupTiers] 
	@buyers dbo.MemberTiers READONLY
AS
    BEGIN
        UPDATE p
          SET 
              APPRD_CONTRACT_TIER = b.TierNr
        FROM [SNDBX].[PRC_AUTH_EB] p
             INNER JOIN @buyers b ON b.MemberNr = P.GPO_MBR_ID
        WHERE p.GPO_MBR_ID = b.MemberNr;
    END;