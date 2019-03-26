create proc usp_test_laod_curr_rbt_from_stg0_medline_rbt
as

/*
update [STAGE].[SALES_TRACING_CURR_MEDLINE_RBT]
set  sales_period = '20181001'
from [STAGE].[SALES_TRACING_CURR_MEDLINE_RBT]
*/

insert into [STAGE].[SALES_TRACING_CURR_MEDLINE_RBT](
       [MNTH] ,  [DAY], [SALES_PERIOD],[YEAR] , [DIST_ID], [DIST_NR] ,
	   [TRC_TRNS_TYP] ,
	   [TRC_CNT_ID] ,
	   [TRC_PROD_ID] ,
	   [TRC_PRC_TYP],

       [INV_ID] ,

       [INV_DT] ,

       [INV_DT_NR] ,

       [TRC_UNIT] ,

       [TRC_QTY_SLD] ,

       [TRC_CNT_PRC] ,

       [TRC_LIST_PRC] ,

       [TRC_DIST_PRC],

       [TRC_RBT_AMT] ,

       [LINE_NR] ,

       [SHPTO_ID] ,

       [SHPTO_NM] ,

       [SHPTO_ADDR_1] ,

       [SHPTO_ADDR_2] ,

       [SHPTO_CITY] ,

       [SHPTO_ST] ,

       [SHPTO_ZIP] ,

       [SHPTO_TYP] ,

       [BILLTO_ID] ,

       [BILLTO_NM] ,

       [BILLTO_ADDR_1],

       [BILLTO_ADDR_2],

       [BILLTO_CITY] ,

       [BILLTO_ST] ,

       [BILLTO_ZIP],

       [BILLTO_TYP],

       [DBT_MEMO] ,

       [CURRENT TIMESTAMP] 
	  ,[TRC_EXT_LIST_COSt], [TRC_EXT_CNT_COST]
	  --, [TRC_EXT_DIST_COST]
	  , [TRC_EXT_RBT_AMT]
	  ,[TRC_PROD_DESC]
	  ,[SLS_CALC_STAT]
    ,[SRC_FILE_TYP]
	, [Vendor] 
	, MedlineCon 
	, GpoId 
	, MedlineItm 
	, [Material GTIN] 
	, [Sold-To DEA#] 
	, [Sold-To GLN] 
	, [DocType] 
	, [Plant] 
	,[PlantStreet] 
	, [PlantAddress] 
	, [PremiumAmt] 
	, [PremiumPct] 
	, [CondPrcUni] 
	,[CondUnitDo] 
	, [ContDisc] 
	, [CustGrp] 
	, [PDI Denied Rebate] 
	, [PDI Comments]  
	  )
-- where sales_period = @vSales_Period
 
       select  [MNTH]

      ,[DAY]

      ,[SALES_PERIOD]

      ,[YEAR]

      ,[DIST_ID]

      ,[DIST_NR]

      ,left([TRC_TRANS_TYP],2)

      ,left([TRC_CNT_ID],30)

      ,left([TRC_PROD_ID],48)

      ,left([TRC_PRC_TYP],15)

      ,left([INV_ID],30)

      ,[INV_DT]

      ,[INV_DT_NR]

      ,convert(char(3),left([TRC_UNIT],3))

      ,convert(float,[TRC_QTY_SLD])

      ,convert(float,[TRC_CNT_PRC])

      ,convert(float,[TRC_LIST_PRC])

      ,convert(float,[TRC_DIST_PRC])

      ,convert(float,[TRC_RBT_AMT])

      ,convert(int,[LINE_NR])

      ,left([SHPTO_ID],20)

      ,left([SHPTO_NM],200)

      ,left([SHPTO_ADDR_1],100)

      ,left([SHPTO_ADDR_2],100)

      ,left([SHPTO_CITY],100)

      ,left([SHPTO_ST],10)

      ,left([SHPTO_ZIP],12)

      ,left([SHPTO_TYP],100)

      ,left([BILLTO_ID],20)

      ,left([BILLTO_NM],200)

      ,left([BILLTO_ADDR_1],150)

      ,left([BILLTO_ADDR_2],150)

      ,left([BILLTO_CITY],100)
      ,left([BILLTO_ST],10)
      ,left([BILLTO_ZIP],12)
      ,left([BILLTO_TYP],100)
      ,left([DBT_MEMO],40)
      ,left([CURRENT TIMESTAMP],50)  
	  ,convert(float,[TRC_EXT_LIST_COST]),convert(float,[TRC_EXT_CNT_COST])
	  --,convert(float,[TRC_EXT_DIST_COST])
	  ,convert(float,[TRC_EXT_RBT_AMT])
	  ,[TRC_PROD_DESC]
	  ,'P'
    , 'BLK'
	, [Vendor] 
	, MedlineCon 
	, GpoId 
	, MedlineItm 
	, [Material GTIN] 
	, [Sold-To DEA#] 
	, [Sold-To GLN] 
	, [DocType] 
	, [Plant] 
	,[PlantStreet] 
	, [PlantAddress] 
	, [PremiumAmt] 
	, [PremiumPct] 
	, [CondPrcUni] 
	,[CondUnitDo] 
	, [CondDisc] 
	, [CustGrp] 
	, [PDI Denied Rebate] 
	, [PDI Comments]  
	

  FROM [STG0].[SALES_TRACING_NON_EDI_ETL_MEDLINE_RBT]


--  and dist_id = isnull(@vdist_Id, dist_id)

