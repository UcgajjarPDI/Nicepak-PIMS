-- PRICE AUTHORIZATION
 
  CREATE proc [dbo].[List_Prc_Auth]
  as
  SELECT distinct --top 100 
  --g.group_id,c.group_id,
  g.[GPO_AFF_ID] as GPO_ID
  ,
  a.[Intalere Facility #] as [GPO_MMBR_ID]
  ,x.PDI_UserID as [EU_ID]
  --, a.[Primary Distributor]
  ,a.[Contract #] as [PDI_CNT_NR]
  ,a.[Intalere Contract #] as [GPO_CNT_NR]
  , 
  (
  case when tier like '%Tier 1%' then 1
       when tier like '%Tier 2%' then 2
	   else 0
  end
  ) as TIER_NR
  ,a.[Activation Date] as [ACTVN_DT]
  ,d.DIST_ID
  ,getdate() as LAST_MOD_DT
  ,0 as EDI_SENT
  --  ,rtrim(ltrim(Tier)) as TierName
  FROM TEMP_Amerinet a
  INNER JOIN [GPO_XREF] x on (cast(a.[Intalere Facility #] as nvarchar(150)) = x.[Facility Number])
  INNER JOIN STAGE.DIM_DISTRIBUTOR d on (  soundex(a.[Primary Distributor])  = soundex(d.DIST_NAME)  )
  INNER join STAGE.DIM_CONTRACT c on (c.[Contract_NO] = a.[CONTRACT #]) 
 --inner JOIN STAGE.DIM_GROUP g  on  (g.GROUP_ID = c.GROUP_ID )
  INNER JOIN PDI_SALESTRACING.REPORT.DIM_GPO_AFFILIATION g  on  (g.GROUP_ID = c.GROUP_ID )


  /*
  UNION

  SELECT distinct --top 100 
  --g.group_id,c.group_id,
  --g.[GPO_AFF_ID] as GPO_ID
  --,
  a.[Intalere Facility #] as [GPO_MMBR_ID]
  ,x.PDI_UserID as [EU_ID], a.[Primary Distributor]
  ,a.[Contract #] as [PDI_CNT_NR]
  ,a.[Intalere Contract #] as [GPO_CNT_NR]
  ,a.[Activation Date] as [ACTVN_DT]
  ,d.DIST_ID
  , 
  (
  case when tier like '%Tier 1%' then 'Tier 1'
       when tier like '%Tier 2%' then 'Tier 2'
	   else 'Unknown'
  end
  ) as TierLevel
  --  ,rtrim(ltrim(Tier)) as TierName
  FROM Temp_MedAssets a
  INNER JOIN [GPO_XREF] x on (cast(a.[Intalere Facility #] as nvarchar(150)) = x.[Facility Number])
  INNER JOIN STAGE.DIM_DISTRIBUTOR d on (  soundex(a.[Primary Distributor])  = soundex(d.DIST_NAME)  )
  INNER join STAGE.DIM_CONTRACT c on (c.[Contract_NO] = a.[CONTRACT #]) 
  --LEFT JOIN STAGE.DIM_GROUP g  on  (g.GROUP_ID = c.GROUP_ID )
  INNER JOIN PDI_SALESTRACING.REPORT.DIM_GPO_AFFILIATION g  on  (g.GROUP_ID = c.GROUP_ID )
  */

  
  /*
  and 
  (a.[Primary Distributor] = d.DIST_NAME
  or
  a.[Primary Distributor] = d.DIST_PARENT_NAME
  or
  a.[Primary Distributor] = d.DIST_TOP_PARENT_NAME
  or
  a.[Primary Distributor] = d.TRACING_NAME
  )
  */



  /*

  select count(*) from dbo.temp_amerinet

-- Contract
SELECT TOP (1000) [CONTRACT_KEY]      ,[CONTRACT_NO]     ,[GROUP_KEY]      ,[GROUP_ID]      ,[GROUP_NAME]      ,[REFERENCE_NO]
      ,[CONTRACT_TYPE]      ,[TIER_LEVEL]      ,[GROUP_ADMIN_FEES]      ,[CURRENT_INDICATOR]      ,[EFF_DATE]      ,[EXP_DATE]      ,[DIST_CONTRACT_NO]
      ,[ETL_AUDIT_KEY]      ,[CURRENT TIMESTAMP]
	  
FROM [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT]


-- Prc_Auth
SELECT TOP (1000) [PRC_AUTH_ID]      ,[GPO_ID]      ,[GPO_MMBR_ID]      ,[EU_ID]      ,[PDI_CNT_NR]      ,[GPO_CNT_NR]
      ,[TIER_NR]      ,[ACTVN_DT]      ,[PRIM_DIST_ID]
  FROM [PDI_SALESTRACING_DEV].[STAGE].[PRC_AUTH]


  SELECT EU.ENDUSER_ID,EU.ENDUSER_NAME,X.[FACILITY NUMBER] AS GPO_ID, X.[GPO NAME] AS PRIMARY_GPO_NAME
  from STAGE.DIM_ENDUSER eu, PDI_SALESTRACING_DEV.DBO.GPO_XREF X
  WHERE EU.ENDUSER_ID = X.PDI_USERID 
  ORDER BY X.[GPO NAME]

  select [Primary Distributor]
  from Temp_Amerinet
  where [Primary Distributor] not in 
  (
  select dist_parent_name from stage.dim_distributor
  )
  select dist_parent_name from stage.dim_distributor
  where dist_parent_name like '%Medline%'

  
  select dist_name from stage.dim_distributor
  where dist_name like '%Medline%'

  select top 100 * from stage.dim_group
  where group_id = '376182'

  select distinct [Intalere Contract #] from temp_amerinet

  select [Intalere Contract #],count(*)
  from temp_amerinet
  group by [Intalere Contract #]
  
  --NULL	6735
  --VH22800	7235
  select distinct [Contract #] from temp_amerinet

  select [Contract #],count(*)
  from temp_amerinet
  group by [Contract #]

  NULL	1127
CNT1871	9941
CNT1870	2902

select * from stage.dim_contract
where contract_no in (NULL,'CNT1871','CNT1870')
    */

