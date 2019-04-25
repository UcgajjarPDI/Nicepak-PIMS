CREATE PROCEDURE [TRC].[spUpdateContractReconStat] @reconStat [TRC].[ContractReconStat] READONLY
AS
    BEGIN
        UPDATE cr
          SET 
              cr.RECON_STAT_CD = p.ReconStat
        FROM STAGE.TRC_CNT_CORR_XREF cr
             JOIN @reconStat p ON cr.TRC_CNT_ID = p.CNT_ID
                                  AND cr.PROD_ID = p.PROD_ID;
    END;