CREATE PROCEDURE [TRC].[spReplaceExpiredContracts] @vSales_Period VARCHAR(10) = NULL, 
                                                  @vDIST_ID      VARCHAR(20) = NULL, 
                                                  @buyerGrp      VARCHAR(50) = NULL, 
                                                  @vTRC_CNT_ID   VARCHAR(30), 
                                                  @vUPD_CNT_ID   VARCHAR(30), 
                                                  @vPROD_ID      VARCHAR(15)
AS
    BEGIN
        UPDATE STAGE.TRC_CNT_CORR_XREF
          SET 
              UPD_CNT_ID = @vUPD_CNT_ID
        WHERE TRC_CNT_ID = @vTRC_CNT_ID
              AND PROD_ID = @vPROD_ID;
    END;