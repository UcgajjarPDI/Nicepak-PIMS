CREATE PROCEDURE CNT.spGET_PRODUCT_DETAILS
		@cntNr AS  VARCHAR(7), 
		@prodId AS VARCHAR(7)
AS
    BEGIN
        --'CNT6046'
        --'A500F48'
        SET NOCOUNT ON;
        SELECT A.CNT_NR, 
               a.PROD_ID, 
               b.PRODUCT_DESC, 
               a.PROD_EFF_DT, 
               a.[PROD_EXP_DT], 
               a.[PROD_PRC], 
               pr.RATIONALE
        FROM CONT.CNT_PROD A
             INNER JOIN [PROD].[PROD_PRC_COMPARISON] B ON a.PROD_ID = b.PROD_ID
             LEFT JOIN CNT.PROD_RATIONALE pr ON pr.[CNT_NR] = @cntNr
                                                AND pr.PROD_ID = @prodId
                                                AND pr.REC_STAT_CD = 'A'
        WHERE a.[CNT_NR] = @cntNr
              AND b.PROD_ID = @prodId
              AND A.REC_STAT_CD = 'A'
        ORDER BY [CURRENT TIMESTAMP] DESC;
    END;