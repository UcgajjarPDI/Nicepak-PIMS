 CREATE proc uspGetSalesByDist
as
declare @FromDate Datetime, @ToDate Datetime

select @ToDate = getdate()
select @FromDate  = dateadd(year,-2,@ToDate)
select @FromDate,@ToDate
declare @Months int
select datediff(mm,@FromDate,@ToDate)

select distinct
DISTID
--,datepart(year,salesperiod) year 
,count(*)/@Months  as AvgMonthlyTotalRecords
, cast(sum(COTOTALSALESAMNT/@Months) as money) as AvgSalesTotal
from PDI_SALESTRACING.STAGE.DDS_PDI_SAF_EXTRACT
where datepart(year,salesperiod) between @FromDate and @ToDate
group by DISTID--,datepart(year,salesperiod)
order by DISTID--,datepart(year,salesperiod)

