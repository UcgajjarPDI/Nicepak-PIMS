CREATE PROCEDURE [TRC].[spEraseReplacedContract]
                                                  @vTRC_CNT_ID   VARCHAR(30), 
                                                  @vPROD_ID      VARCHAR(15)
AS
    BEGIN
        UPDATE STAGE.TRC_CNT_CORR_XREF
          SET 
              UPD_CNT_ID = NULL	
        WHERE TRC_CNT_ID = @vTRC_CNT_ID
              AND PROD_ID = @vPROD_ID;
    END;