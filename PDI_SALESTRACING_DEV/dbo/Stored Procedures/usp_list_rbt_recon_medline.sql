CREATE proc [dbo].[usp_list_rbt_recon_medline]
	@vSalesPeriod varchar(10)
	--, @vDistId varchar(15)

  as
  begin
 /*
 select distinct err_cd from  [STAGE].[SALES_TRACING_CURR_MEDLINE_RBT]   -- PNC EXC NULL 
 exec usp_list_rbt_recon_medline '20180901' --, 'MEDLINE'
 exec usp_list_rbt_recon_medline '20181001' --, 'MEDLINE'
 exec usp_list_rbt_recon '20180901', 'NDC'
 exec usp_list_rbt_recon '20180901', 'CARDINAL'
 exec usp_list_rbt_recon '20180901', 'OWNMIN'
 exec usp_list_rbt_recon '20180901', 'MCKEXT'
 exec usp_list_rbt_recon '20180901', 'MCKMED'
 select top 100 * from [STAGE].[SALES_TRACING_CURR] where dist_id = 'medline' and inv_id is not null and sales_period = '20181001'  order by inv_id desc
 select top 100 * from [STAGE].[MedlineVDR$] where invoicedat > '20180930' order by invoice

 */
 

 -- MEDLINE


 select distinct s.Vendor, s.MedlineCon
 ,s.trc_cnt_id as VendorCont, s.inv_id as Invoice, s.line_nr as Line, s.inv_dt as InvoiceDat
 ,trc_prod_id as Vendoritm, upd_prod_id as [Correct Item], s.MedlineItm, s.[Material GTIN]
 ,s.SHPTO_ID as Customer, s.[SHPTO_NM] as CustName, s.[SHPTO_ADDR_1] as CustStreet, s.[SHPTO_CITY] as CustCity, s.[SHPTO_ST] as CustState, s.[SHPTO_ZIP] as CustZipCode
 ,s.[Sold-To DEA#], s.[Sold-To GLN], s.TRC_PROD_DESC as [VendItmDes], s.DocType
 ,TRC_QTY_SLD as Quantity, s.trc_unit as UoM
 ,s.[Plant], s.[PlantStreet], s.[PlantAddress]

 , TRC_LIST_PRC as AcqCost
 , TRC_EXT_RBT_AMT as RebateAmt
 , TRC_CNT_PRC as ContrCost
 , s.PremiumAmt
 , s.PremiumPct
 , s.CondPrcUni
 , s.CondUnitDo
 , s.ContDisc
 , s.CustGrp
 , DBT_MEMO as DebitMemo
 , s.UPD_PROD_ID + cast(s.TRC_LIST_PRC as varchar(35)) as [Prod & Acq Cost]

 ,s.TRC_UPD_UNIT as UOM
 ,' ' as [UOM UNITS]
 ,round(s.upd_cs_qty,4) as [CASES SOLD]
 
 ,s.UPD_CNT_ID + s.UPD_PROD_ID as [CNT PROD]
 ,s.upd_CS_PRC as [List Price]
 --,isnull(s.CNT_CS_PRC, ' ') as [CNT PRICE]
 ,' ' as [CNT PRICE]
 --,s.cnt_cs_prc as [Contract Price]
 --, cast(p.[EFFECTIVE_DATE] as date)  as [PRODUCT EFFECTIVE DATE], cast(p.[EXPIRATION_DATE] as date) as [PRODUCT EXPIRATION DATE]
 , cast(s.[CNT_EXP_DT] as date)  as [PRODUCT EFFECTIVE DATE], cast(s.[CNT_EXP_DT] as date) as [PRODUCT EXPIRATION DATE]
 ,' ' as xx1
 ,s.cnt_exp_days as xx2
 --,isnull(s.rbt_list_PRC,0) - isnull(s.CNT_CS_PRC,0) 
 ,' '  as [UNIT REBATE]
 ,round(s.upd_rbt_amt,2) as [TOTAL REBATE]
 --,(s.UPD_CS_PRC - s.CNT_CS_PRC) * s.UPD_CS_QTY as [TOTAL REBATE]

 ,round(s.TRC_EXT_RBT_AMT - s.upd_rbt_amt , 2) as [PDI DENIED REBATES]
 , case when ERR_CD = 'PNC' then 'Product Not In Contract'
		when ERR_CD = 'EXC' then 'Expired Contract'
		else ' '
		end as [PDI COMMENTS]

 
 from --[STAGE].[SALES_TRACING_CURR] s
 --INNER JOIN STAGE.MedlineVDR$ s on s.invoice = s.invoicedat = s.inv_dt_nr and s.vendoritm = s.trc_prod_id and s.Quantity = s.trc_qty_sld --and s.trc_rbt_amt = s.rebateamt
 
 --INNER JOIN STAGE.DIM_PRODUCT p on s.upd_prod_id = p.product_id
 [STAGE].[SALES_TRACING_CURR_MEDLINE_RBT] s
INNER JOIN STAGE.CONT_PRICE c on  s.rbt_cnt_id = c.[Contract Id] and s.trc_prod_id = c.ItemId
 where s.sales_period = @vSalesPeriod and s.dist_id = 'MEDLINE' -- @vDistId
 --and vendoritm = 'Q55172'
 --order by s.InvoiceDat,s.Invoice

 

 





 end 
