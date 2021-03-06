﻿CREATE PROCEDURE [TRC].[spTRC_SAVE_UCI_CORR]
@vTRC_CNT_ID varchar(30), @vUPD_CNT_ID varchar(30) 
WITH EXEC AS CALLER
AS
BEGIN

  BEGIN
    MERGE [PDI_SALESTRACING_DEV].[STAGE].[TRC_CNT_CORR_XREF] T
      USING
         (SELECT TRC_CNT_ID = @vTRC_CNT_ID,  PROD_ID='ALL', UPD_CNT_ID=@vUPD_CNT_ID, 
        TRC_CNT_TYP=CASE WHEN LEFT(@vTRC_CNT_ID,3)='CNT' THEN 'PDI' ELSE 'GPO' END ) AS S 
        ON T.TRC_CNT_ID = S.TRC_CNT_ID 
      
      WHEN NOT MATCHED BY TARGET THEN
      INSERT 
        (TRC_CNT_ID, PROD_ID, UPD_CNT_ID, TRC_CNT_TYP)
      VALUES
        (S.TRC_CNT_ID, S.PROD_ID, S.UPD_CNT_ID, S.TRC_CNT_TYP)
      
      WHEN MATCHED THEN
      UPDATE 
        SET T.UPD_CNT_ID = S.UPD_CNT_ID;
      
  END;

END