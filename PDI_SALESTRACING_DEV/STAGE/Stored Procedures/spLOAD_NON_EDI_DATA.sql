﻿CREATE PROCEDURE [STAGE].[spLOAD_NON_EDI_DATA]
@vSales_Period varchar(8) = null, @vdist_id varchar(50) = null
WITH EXEC AS CALLER
AS
/*
exec [Test_Reload_Curr_from_Stg0_non_Edi] '20181001','AEROMD'
exec [STAGE].[spSALES_TRACING_PROCESS_v2] '20181001','AEROMD'
exec [dbo].[usp_show_after_NON_EDI_Calc_curr] '20181001'
*/
    
  BEGIN
    MERGE [STAGE].[SLS_TRC_LOAD_DTL] T
      USING (
        SELECT DIST_NR, DIST_ID, SALES_PERIOD, SALES_PERIOD AS RECVD_DTE,
        'PENDING' AS LOAD_STAT, 'BLK' AS SRC_FILE_TYP, COUNT(*) AS REC_CNT
        FROM [STG0].[SALES_TRACING_NON_EDI_ETL_STAGE]
        WHERE SALES_PERIOD =  isnull(@vSales_Period, SALES_PERIOD )
        AND DIST_ID = isnull(@vdist_Id, DIST_ID)
        AND LOAD_IN = 'P'
        GROUP BY DIST_NR, DIST_ID, SALES_PERIOD
        ) S ON T.DIST_ID = S.DIST_NR AND T.SALES_PERIOD = S.SALES_PERIOD
      
      WHEN NOT MATCHED BY TARGET THEN   -- That means it is a new Contract

      INSERT 
      ( DIST_ID, DIST_TRC_NM, SALES_PERIOD, RECVD_DTE, LOAD_STAT,SRC_FILE_TYP, REC_CNT)
      VALUES
      ( DIST_NR, DIST_ID, SALES_PERIOD, RECVD_DTE, LOAD_STAT,SRC_FILE_TYP, REC_CNT)
      
      WHEN MATCHED THEN
        UPDATE SET T.REC_CNT = S.REC_CNT, T.LOAD_STAT = S.LOAD_STAT ;
          
  END
  -- DELETE EXISTONG RECORDS, IF THERE IS ANY TO AVOID DUPLICATES --
     
  DELETE C FROM [STAGE].[SALES_TRACING_CURR] C
  INNER JOIN [STAGE].[SLS_TRC_LOAD_DTL] L 
    ON C.DIST_NR = L.DIST_ID 
    AND C.SALES_PERIOD = L.SALES_PERIOD
    AND L.LOAD_STAT = 'PENDING' AND L.SRC_FILE_TYP = 'BLK' ;
  
/*
if @vdist_id is null
	delete from  [STAGE].[SALES_TRACING_CURR]
	where sales_period = @vSales_Period
else
	delete from  [STAGE].[SALES_TRACING_CURR]
	where sales_period = @vSales_Period
	and dist_id = @vDist_id*/

  INSERT INTO [STAGE].[SALES_TRACING_CURR](
    [MNTH] ,  [DAY], [SALES_PERIOD],[YEAR] , [DIST_ID], [DIST_NR] ,
	  [TRC_TRNS_TYP] , [TRC_CNT_ID] , [TRC_PROD_ID] , [TRC_PRC_TYP],
    [INV_ID] , [INV_DT] ,[INV_DT_NR] ,[TRC_UNIT] ,[TRC_QTY_SLD] ,
    [TRC_CNT_PRC] ,[TRC_LIST_PRC] ,[TRC_DIST_PRC],[TRC_RBT_AMT] ,[LINE_NR] ,
    [SHPTO_ID] ,[SHPTO_NM] ,[SHPTO_ADDR_1] ,[SHPTO_ADDR_2] ,[SHPTO_CITY] ,[SHPTO_ST] ,[SHPTO_ZIP] ,[SHPTO_TYP] ,
    [BILLTO_ID] ,[BILLTO_NM] ,[BILLTO_ADDR_1],[BILLTO_ADDR_2],[BILLTO_CITY] ,[BILLTO_ST] ,[BILLTO_ZIP],[BILLTO_TYP],
    [DBT_MEMO] ,[CURRENT TIMESTAMP] 
	  ,[TRC_EXT_LIST_COSt], [TRC_EXT_CNT_COST] --, [TRC_EXT_DIST_COST]
	  , [TRC_EXT_RBT_AMT] ,[TRC_PROD_DESC] ,[SLS_CALC_STAT], [RBT_CALC_STAT]   ,[SRC_FILE_TYP], LOAD_ID
	  )
    SELECT  [MNTH],[DAY],L.[SALES_PERIOD],[YEAR],E.[DIST_ID] ,[DIST_NR]
      ,left([TRC_TRANS_TYP],2) ,left([TRC_CNT_ID],30),left([TRC_PROD_ID],48)
      ,left([TRC_PRC_TYP],15) ,left([INV_ID],30),TRY_CONVERT(DATE,[INV_DT]),
      [INV_DT_NR],TRY_convert(char(3),left([TRC_UNIT],3))
      ,TRY_convert(float,[TRC_QTY_SLD]),TRY_convert(float,[TRC_CNT_PRC]) ,TRY_convert(float,[TRC_LIST_PRC]),TRY_convert(float,[TRC_DIST_PRC])
      ,TRY_convert(float,[TRC_RBT_AMT]) ,TRY_convert(int,[LINE_NR]),left([SHPTO_ID],20),left([SHPTO_NM],200),left([SHPTO_ADDR_1],100)
      ,left([SHPTO_ADDR_2],100),left([SHPTO_CITY],100),left([SHPTO_ST],10),left([SHPTO_ZIP],12),left([SHPTO_TYP],100) ,left([BILLTO_ID],20)
      ,left([BILLTO_NM],200) ,left([BILLTO_ADDR_1],150),left([BILLTO_ADDR_2],150),left([BILLTO_CITY],100),left([BILLTO_ST],10),left([BILLTO_ZIP],12)
      ,left([BILLTO_TYP],100) ,left([DBT_MEMO],40) ,left([CURRENT TIMESTAMP],50)  ,TRY_convert(float,[TRC_EXT_LIST_COST]),TRY_convert(float,[TRC_EXT_CNT_COST])
	     --,TRY_convert(float,[TRC_EXT_DIST_COST])
	    ,TRY_convert(float,[TRC_EXT_RBT_AMT])  ,[TRC_PROD_DESC]  ,'P','P', 'BLK', L.LOAD_ID
    FROM [STG0].[SALES_TRACING_NON_EDI_ETL_STAGE] E
    JOIN [STAGE].[SLS_TRC_LOAD_DTL] L ON E.DIST_NR = L.DIST_ID AND E.SALES_PERIOD = L.SALES_PERIOD
    AND L.LOAD_STAT = 'PENDING'
    WHERE E.sales_period = isnull(@vSales_Period, E.sales_period )
    AND E.dist_id = isnull(@vdist_Id, E.dist_id);

    UPDATE [STAGE].[SLS_TRC_LOAD_DTL]
    SET LOAD_STAT = 'COMPLETE'
    WHERE LOAD_STAT = 'PENDING'
    AND DIST_TRC_NM =  isnull(@vdist_Id, DIST_TRC_NM) 
    AND SALES_PERIOD  =  isnull(@vSales_Period,SALES_PERIOD)
    ;
    
    UPDATE [STG0].[SALES_TRACING_NON_EDI_ETL_STAGE]
      SET LOAD_IN = 'C'
    WHERE 
        SALES_PERIOD = isnull(@vSales_Period, SALES_PERIOD )
        AND DIST_ID =  isnull(@vdist_Id, DIST_ID)
        AND LOAD_IN = 'P';

  --------------------------  LOADING COMPLETE ---------------------------------------------
  
    UPDATE STAGE.SALES_TRACING_CURR
    SET TRC_RBT_AMT = TRC_EXT_RBT_AMT
    WHERE TRC_RBT_AMT IS NULL AND TRC_EXT_RBT_AMT IS NOT NULL;
    
    --- Specific Hard-coded business rules -- 
    --- for Medact - get rid of records with prod description = 'DFU'
    DELETE S1 
    FROM STAGE.SALES_TRACING_CURR S1
    JOIN STG0.SALES_TRACING_NON_EDI_ETL_STAGE S0 ON S1.EDISDTLSEQ = S0.ID
    WHERE S0.DIST_NR = '131043'
    AND S0.TRC_PROD_DESC LIKE '%DFU%';
    
    -- For Quick Med -- with product 'KIT' and no shipto nm
    DELETE S1 
    FROM STAGE.SALES_TRACING_CURR S1
    JOIN STG0.SALES_TRACING_NON_EDI_ETL_STAGE S0 ON S1.EDISDTLSEQ = S0.ID
    WHERE S0.DIST_NR = '180130'
    AND (S0.TRC_PROD_ID LIKE '%KIT%' AND LEN(S0.SHPTO_NM) = 0);

	 delete e from [STAGE].[SALES_TRACING_CURR] e 
	  where e.TRC_PROD_ID is null