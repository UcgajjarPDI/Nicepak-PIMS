CREATE  proc usp_test_code_for_gaps_non_edi
as
--NDC
/*

delete a
from [PDI_SALESTRACING_DEV].[STG0].[SALES_TRACING_NON_EDI_ETL] a
where a.DIST_ID in ('medplus','ndc') and a.BILLTO_ID in ('100009','100010','100017','100051','110005','110068','500104','710293','720254','720217')

*/
-- check on rec count
-- In a salesperiod / inv_id matching?
--468 invoices matching 467 invoices
/*

declare @sales_period varchar(10), @dist_id varchar(15)
select @sales_period = '20180901', @dist_id = 'DCI'

select * from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = '20180901'
and a.DIST_ID = 'DCI'
and a.inv_id not  in

(
select b.distinvoiceid
from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id
and b.salesperiod = @sales_period and sourcefiletype = 'BLK'
)

-- add product to match deeper
declare @sales_period varchar(10), @dist_id varchar(15)
select @sales_period = '20180901', @dist_id = 'DCI'

select * from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = '20180901'
and a.DIST_ID = 'DCI'
--and  a.inv_id is not null
and a.inv_id not  in

(
select b.distinvoiceid
from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id
and b.salesperiod = @sales_period and sourcefiletype = 'BLK'
and a.trc_prod_id = b.DISTITEMID
)

--- count(*) 
declare @sales_period varchar(10), @dist_id varchar(15)
select @sales_period = '20180901', @dist_id = 'DCI'

select count(*) as tot_recs,sum(trc_qty_sld) as tot_trc_qty_sld,sum(upd_cs_qty) as tot_upd_qty_sld from [STAGE].[SALES_TRACING_NON_EDI_ETL] b
where b.dist_id = @dist_id and b.sales_period = @sales_period and  isnull(trc_qty_sld,0) <> 0
select count(*) as tot_recs,sum(distqtysold) as tot_distqtysold,sum(coqtysold) as tot_coqtysold from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id and b.salesperiod = @sales_period and sourcefiletype = 'BLK'


-- check on qty (do we have same trc_qty versus thiers)
declare @sales_period varchar(10), @dist_id varchar(15)
select @sales_period = '20180901', @dist_id = 'DCI'

select * from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = @sales_period
and a.DIST_ID = @dist_id
--and  a.inv_id is not null
and a.trc_qty_sld not  in

(
select b.DISTQTYSOLD
from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id
and b.salesperiod = @sales_period and sourcefiletype = 'BLK'
and a.inv_id = b.DISTINVOICEID
and a.trc_prod_id = b.DISTITEMID
)

-- check on qty (do we have same trc_upd_qty versus theirs)
declare @sales_period varchar(10), @dist_id varchar(15)
select @sales_period = '20180901', @dist_id = 'DCI'

-- list saf
select sum(x.coqtysold) as SAF_QTY_SLD,sum(y.upd_cs_qty) as PDI_QTY_SLD,sum(x.distqtysold) as SAF_DIST_QTY_SLD, sum(trc_qty_sld) as TRC_QTY_SLD 
--x.DISTID,x.DISTCOID,x.DISTITEMID,x.DISTQTYSOLD,x.DISTITEMUOM,x.COITEMUOM,x.COQTYSOLD,Y.upd_cs_qty  
from [STAGE].[DDS_PDI_SAF_EXTRACT] x
,

-- list pdi
(
select DIST_ID,DIST_nr,TRC_PROD_ID, trc_qty_sld, trc_unit, TRC_UPD_UNIT,upd_cs_qty,inv_id from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = @sales_period
and a.DIST_ID = @dist_id
--and  a.inv_id is not null
and a.UPD_CS_QTY not in 
--and a.UPD_CS_QTY in

(
select b.COQTYSOLD
from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id
and b.salesperiod = @sales_period and sourcefiletype = 'BLK'
and a.inv_id = b.DISTINVOICEID
and a.trc_prod_id = b.DISTITEMID
)
)y
where y.dist_id = x.distid
and @sales_period = x.salesperiod
and y.inv_id = x.DISTINVOICEID
and y.trc_prod_id = x.DISTITEMID

UNION

-- list saf
select sum(x.coqtysold) as SAF_QTY_SLD,sum(y.upd_cs_qty) as PDI_QTY_SLD,sum(x.distqtysold) as SAF_DIST_QTY_SLD, sum(trc_qty_sld) as TRC_QTY_SLD 
--x.DISTID,x.DISTCOID,x.DISTITEMID,x.DISTQTYSOLD,x.DISTITEMUOM,x.COITEMUOM,x.COQTYSOLD,Y.upd_cs_qty  
from [STAGE].[DDS_PDI_SAF_EXTRACT] x
,

-- list pdi
(
select DIST_ID,DIST_nr,TRC_PROD_ID, trc_qty_sld, trc_unit, TRC_UPD_UNIT,upd_cs_qty,inv_id from [STAGE].[SALES_TRACING_NON_EDI_ETL] a
where a.sales_period = @sales_period
and a.DIST_ID = @dist_id
--and  a.inv_id is not null
--and a.UPD_CS_QTY not in 
and a.UPD_CS_QTY in

(
select b.COQTYSOLD
from [STAGE].[DDS_PDI_SAF_EXTRACT] b
where b.distid = @dist_id
and b.salesperiod = @sales_period and sourcefiletype = 'BLK'
and a.inv_id = b.DISTINVOICEID
and a.trc_prod_id = b.DISTITEMID
)
)y
where y.dist_id = x.distid
and @sales_period = x.salesperiod
and y.inv_id = x.DISTINVOICEID
and y.trc_prod_id = x.DISTITEMID




--sp_who

-- for same inovice
select DISTID,DISTCOID,DISTITEMID,DISTQTYSOLD,DISTITEMUOM,COITEMUOM,COQTYSOLD from [STAGE].[DDS_PDI_SAF_EXTRACT] where distinvoiceid = '761014'
select DIST_ID,DIST_nr,TRC_PROD_ID, trc_qty_sld, trc_unit, TRC_UPD_UNIT,UPD_CS_QTY from [STAGE].[SALES_TRACING_NON_EDI_ETL] where Inv_id = '761014'

-- PDI has added qty_sold 0  whereas VC has skipped this row
DCI	41070	Q55172	0	EA 	EA
inv_id 761014

*/

