-- =============================================
-- Author:	Habib Tarafder
-- To make preliminary update of the contract, from pop-up page
-- This proc expects 'REPLACE', 'REJECT' or 'PASS' as value of RECON_ACTN
-- =============================================
CREATE PROCEDURE [TRC].[spTEMP_UPDATE_CONT_EXCPTN]
(@CNT_NR      [VARCHAR](40), 
 @prod_ID     [VARCHAR](20), 
 @RECON_ACTN  VARCHAR(20), 
 @REPL_CNT    [VARCHAR](40), 
 @Recon_Apply BIT
)
AS
    BEGIN
        IF @Recon_Apply = 0
            BEGIN
                SELECT DISTINCT 
                       a.PROD_ID
                INTO #allProducts
                FROM CNT_DEV.CNT_PROD A
                WHERE a.[CNT_NR] = @REPL_CNT
                      AND A.REC_STAT_CD = 'A';
                SELECT PROD_ID
                INTO #productsToUpdate
                FROM [STAGE].[TRC_CNT_CORR_XREF]
                WHERE TRC_CNT_ID = @CNT_NR
                      AND RECON_STAT_CD = 'P'
                      AND PROD_ID IN
                (
                    SELECT PROD_ID
                    FROM #allProducts
                );
                UPDATE [STAGE].[TRC_CNT_CORR_XREF]
                  SET 
                      RECON_ACTN = CASE
                                       WHEN @RECON_ACTN = 'REPLACE'
                                       THEN 'R'
                                       WHEN @RECON_ACTN = 'REJECT'
                                       THEN 'X'
                                       WHEN @RECON_ACTN = 'PASS'
                                       THEN 'A'
                                   END, 
                      UPD_CNT_ID = @REPL_CNT
                WHERE TRC_CNT_ID = @CNT_NR
                      AND PROD_ID IN
                (
                    SELECT PROD_ID
                    FROM #productsToUpdate
                )
                      AND RECON_STAT_CD = 'P'
					  AND RECON_ACTN IS NULL
        END;
            ELSE
            BEGIN
                UPDATE [STAGE].[TRC_CNT_CORR_XREF]
                  SET 
                      RECON_ACTN = CASE
                                       WHEN @RECON_ACTN = 'REPLACE'
                                       THEN 'R'
                                       WHEN @RECON_ACTN = 'REJECT'
                                       THEN 'X'
                                       WHEN @RECON_ACTN = 'PASS'
                                       THEN 'A'
                                   END, 
                      UPD_CNT_ID = @REPL_CNT
                WHERE TRC_CNT_ID = @CNT_NR
                      AND PROD_ID = @prod_ID
                      AND RECON_STAT_CD = 'P';
        END;
    END;