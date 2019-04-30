CREATE PROCEDURE [TRC].[spUpdateContractReconStat] @UserID    VARCHAR(20), 
                                                  @reconStat [TRC].[ContractReconStat] READONLY
AS
    BEGIN
        UPDATE cr
          SET 
              cr.RECON_STAT_CD = 'C', 
              cr.RECON_DT = CONVERT(DATE, GETDATE()), 
              cr.RECON_BY = @UserID
        FROM STAGE.TRC_CNT_CORR_XREF cr
             JOIN @reconStat p ON cr.TRC_CNT_ID = p.CNT_ID
                                  AND cr.PROD_ID = p.PROD_ID
        WHERE cr.RECON_STAT_CD = 'P';
    END;