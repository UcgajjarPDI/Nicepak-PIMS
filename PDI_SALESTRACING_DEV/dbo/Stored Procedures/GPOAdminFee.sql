Create Proc GPOAdminFee

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 Select 
 s.salesperiod,s.distname,s.coitemid,s.coqtysold,s.cototalsalesamnt,s.cocontid,s.coacctid,s.coacctshipname,s.coacctshipaddr1,s.coacctshipaddr2,
 s.coacctshipaddr3,s.coacctshipcity,s.coacctshipstate,s.coacctshipzip,
 x.[GroupName],x.[GroupAcctID],x.[GroupAltID]

from [PDI_SALESTRACING_DEV].[STAGE].[DDS_PDI_SAF_EXTRACT] s 
Left Join [PDI_SALESTRACING_DEV].[dbo].[GPOxREF] x on s.[COACCTID] = x.CoAcctNum
where s.[SALESPERIOD] = '20180801' 
and s.[COCONTID] in ('CNT2534','CNT2533','CNT2363','CNT2536','CNT2364','CNT2601','CNT2599','CNT2361','CNT2535','CNT2605','CNT2389','CNT2366','CNT2367','CNT2379')

--s.salesperiod,s.distname,s.coitemid,s.coqtysold,s.cototalsalesamnt,s.cocontid,s.coacctid,s.coacctshipname,s.coacctshipaddr1,s.coacctshipaddr2,
--s.coacctshipaddr3,s.coacctshipcity,s.coacctshipstate,s.coacctshipzip,
--x.[GroupName],x.[GroupAcctID],x.[GroupAltID]
      
END
