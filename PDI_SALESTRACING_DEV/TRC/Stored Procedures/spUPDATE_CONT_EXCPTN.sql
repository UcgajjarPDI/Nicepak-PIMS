-- =============================================
-- Author:	Habib Tarafder
-- This is the full update abter submission button
-- need session id of the user to be paased
-- =============================================
CREATE PROCEDURE [TRC].[spUPDATE_CONT_EXCPTN]

(@CNT_NR [varchar](40),
@prod_ID [varchar](20),
@UserID [varchar](40)
)
	as
BEGIN

	update [STAGE].[TRC_CNT_CORR_XREF]
    SET RECON_STAT_CD = 'C', RECON_DT = convert(date, getdate()), RECON_BY = @UserID
	WHERE TRC_CNT_ID =@CNT_NR AND PROD_ID =@prod_ID and RECON_STAT_CD = 'P';

END