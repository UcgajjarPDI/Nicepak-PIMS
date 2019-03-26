CREATE proc [dbo].[usp_show_after_NON_EDI_Calc] 
@vSalesPeriod varchar(10)
as
/*
sp_who

	exec usp_show_after_NON_EDI_Calc '20180901'
	select distinct dist_id from [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_NON_EDI_ETL]
	select distinct dist_id from [PDI_SALESTRACING_DEV].[STG0].[SALES_TRACING_NON_EDI_ETL]
	rollback tran
*/

-- NON EDI onth end calculation results
--declare @vsalesperiod varchar(10)
--select @vsalesperiod = '20180901'
select a.DIST, c.dist_id
,a.TotRecs as OurTotRecs, b.TotRecs as SAFTotRecs
, round(a.QtySold,0) as OurQtySold, round(b.QtySold,0) as SAFQtySold
,round(a.SalesAmt,0) as OurSalesAmt, round(b.SalesAmt,0) as SAFSalesAmt
--,a.trc_qty_sld as TrcQtySold
,round(a.Rebate_Amt,0) as OurRebateAmt, round(b.Rebate_Amt,0) as SafRebateAmt

from
(
(select   DIST_NR as DIST,count(*) as TotRecs,sum(isnull(UPD_CS_QTY,0)) as QtySold,sum(trc_qty_sld) as trc_qty_sld
,sum(isnull(UPD_SALES_AMT,0) ) as SalesAmt ,	sum(upd_rbt_amt) as Rebate_Amt
  from [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_NON_EDI_ETL]
  where  sales_period = @vSalesPeriod 
  and isnull(trc_qty_sld,0) <> 0
  group by dist_NR
  )a
  LEFT JOIN 
(select   DISTCOID as DIST,count(*) as TotRecs, convert(decimal,sum(COQTYSOLD),2) as QtySold
,convert(decimal,sum(COTOTALSALESAMNT),2) as SALESAMT,sum([REBATEAPPROVEDAMNT]) as Rebate_Amt
from PDI_SALESTRACING_DEV.STAGE.DDS_PDI_SAF_EXTRACT
where salesperiod = @vsalesPeriod and sourcefiletype = 'BLK'
group by distcoid
)b
on  a.dist = b.dist
)
left join 
(
select distinct dist_id,dist_nr 
  from [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_NON_EDI_ETL] 
)
 c
on a.dist = c.dist_nr 
order by dist_id