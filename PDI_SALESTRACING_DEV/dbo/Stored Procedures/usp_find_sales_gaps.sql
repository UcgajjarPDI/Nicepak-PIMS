
CREATE proc usp_find_sales_gaps @vSales_Period varchar(10), @vDist_Id varchar(50) = NULL
as
/*

-----******************   SALES AMOUNT
exec usp_find_sales_gaps @vSales_Period = '20180901', @vDist_Id = NULL
exec usp_find_sales_gaps @vSales_Period = '20180901', @vDist_Id = 'NDC'
exec usp_find_sales_gaps @vSales_Period = '20180901', @vDist_Id = 'PALMTREE'
exec usp_find_sales_gaps @vSales_Period = '20180901', @vDist_Id = 'KREISR'
exec usp_find_sales_gaps @vSales_Period = '20180901', @vDist_Id = 'MEDPLUS'
*/
if exists 
(select name from sysobjects where name = '#t1' ) drop table #t1
if exists 
(select name from sysobjects where name = '#t2' ) drop table #t2
-- Sales Total for SAF
--declare @vsales_period varchar(10), @vdist_id varchar(15)
--select @vsales_period = '20180901', @vdist_id = 'NDC'
--select @vsales_period = '20180901', @vdist_id = NULL

select 
--* 
--count(*) as recs,sum(a.coqtysold) as SAF_QTY, sum(a.COTOTALSALESAMNT) as SAF_SALES 
a.DISTID as DIST_ID, a.COITEMUOM as SAF_UOM,sum(a.COQTYSOLD) SAF_QTY,sum(a.COTOTALSALESAMNT) SAF_SALES, count(*) as RecCount
--a.DISTID,a.DISTCOID,a.DISTITEMID,a.DISTQTYSOLD,a.DISTITEMUOM,a.COITEMUOM,a.COQTYSOLD,a.coitemcost,a.cototalsalesamnt
into #t1
from [STAGE].[DDS_PDI_SAF_EXTRACT] a
where a.salesperiod = @vSales_Period
and a.DISTID = isnull(@vDist_Id,a.DistId) and a.SOURCEFILETYPE = 'BLK'
group by a.DISTID,a.coitemuom
order by a.DISTID,a.coitemuom


-- Sales Total for PDI
--declare @vsales_period varchar(10), @vdist_id varchar(15)
--select @vsales_period = '20180901', @vdist_id = 'NDC'
--select @vsales_period = '20180901', @vdist_id = NULL

select 
--* 
--count(*) as recs,sum(a.UPD_CS_QTY) as PDI_QTY,sum(trc_qty_sld) as TRC_QTY_SLD 
a.DIST_ID, a.TRC_UPD_UNIT as PDI_UOM,sum(a.UPD_CS_QTY) as PDI_QTY,sum(a.UPD_SALES_AMT) PDI_SALES, count(*) as RecCount
--a.DISTID,a.DISTCOID,a.DISTITEMID,a.DISTQTYSOLD,a.DISTITEMUOM,a.COITEMUOM,a.COQTYSOLD,a.coitemcost,a.cototalsalesamnt
into #t2
from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = @vSales_Period
and a.DIST_ID = isnull(@vDist_Id,a.Dist_Id)
group by a.DIST_ID,a.TRC_UPD_UNIT
order by a.DIST_ID,a.TRC_UPD_UNIT

-- JOIN SAF sales and PDF sales
select 'SAF AND PDI has',*
from #t1 a
inner join #t2 b
on a.DIST_ID = b.DIST_ID and a.saf_UOM = b.pdi_UOM 
order by a.DIST_ID,a.SAF_UOM

select 'SAF has but PDI DONT',*
from #t1 a
LEFT join #t2 b
on a.DIST_ID = b.DIST_ID and a.saf_UOM = b.pdi_UOM 
order by a.DIST_ID,a.SAF_UOM

select 'SAF dont but PDI has',* 
from #t1 a
RIGHT join #t2 b
on a.DIST_ID = b.DIST_ID and a.saf_UOM = b.pdi_UOM 
order by b.DIST_ID,b.PDI_UOM

/*******************************
select *
from #t1 a
full join #t2 b
on a.DIST_ID = b.DIST_ID and a.saf_UOM = b.pdi_UOM 

select * from #t1 order by dist_id
select * from #t2 order by dist_id

**********************************************************
*/

