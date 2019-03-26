CREATE proc  [dbo].[Test_Reload_Stage_from_Stg0_non_Edi]
@vSales_Period varchar(10), @vDist_Id varchar(25) = NULL

as

--truncate table [STAGE].[SALES_TRACING_CURR]
--begin tran

insert into [STAGE].[SALES_TRACING_CURR](

       [MNTH] ,       [DAY],       [SALES_PERIOD],       [YEAR] ,

       [DIST_ID],       [DIST_NR] ,

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

       [TRC_DIST_PRC], [TRC_EXT_LIST_COST],[TRC_EXT_CNT_COST],

       [TRC_RBT_AMT] , [TRC_EXT_RBT_AMT],

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
	   ,SLS_CALC_STAT, TRC_PROD_DESC
	   )

 

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

      ,convert(float,[TRC_DIST_PRC]),convert(float,[TRC_EXT_LIST_COST]),convert(float,[TRC_EXT_CNT_COST])

      ,convert(float,[TRC_RBT_AMT]),convert(float,[TRC_EXT_RBT_AMT])

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

	  ,'P' -- pending to be used by calc proc
	  ,TRC_PROD_DESC

FROM [STG0].[SALES_TRACING_NON_EDI_ETL]
where sales_period = @vSales_Period
and dist_id = isnull(@vDist_Id, dist_id)

/*

  select count(*)  
  FROM [STG0].[SALES_TRACING_NON_EDI_ETL]
where sales_period = '20180901'
and dist_id  in ('CARDINAL','HENRYSCHEIN')

 select distinct dist_id from  [STAGE].[SALES_TRACING_CURR]
 where sales_period = '20180901'
 select  SLS_CALC_STAT,count(*) from  [STAGE].[SALES_TRACING_CURR]
 where sales_period = '20180901' --and sls_calc_stat is NULL
 group by SLS_CALC_STAT
 begin tran
 rollback tran
 commit tran

 update a
 set a.SLS_CALC_STAT = 'P'
 from [STAGE].[SALES_TRACING_CURR] a
 where a.SLS_CALC_STAT is NULL
*/

