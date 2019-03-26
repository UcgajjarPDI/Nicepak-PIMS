  create function dbo.Saf6MonthAvgQty
  (
  @vsalesperiod varchar(10)
  ,@vDistId varchar(50)
  )
  returns numeric(38,2)
  as
 -- select dbo.Saf6MonthAvgQty('20181001','Palmtree')
  --select CONVERT(DATE,CONVERT(CHAR(8),'20181001'),112), dateadd(MM,-6,( CONVERT(DATE,CONVERT(CHAR(8),'20181001'),112)))
  begin
  declare @Ret decimal (38,2)
  select @ret = round(avg(TotQtySold),2)
  from [STAGE].[SAF_REF_SUMMARY_COUNTS]
  where DistId = @vDistId
  and
	CONVERT(DATE,CONVERT(CHAR(8),SalesPeriod),112) >= dateadd(MM,-6,( CONVERT(DATE,CONVERT(CHAR(8),@vsalesPeriod),112)))
  and
	CONVERT(DATE,CONVERT(CHAR(8),SalesPeriod),112)  <= CONVERT(DATE,CONVERT(CHAR(8),@vSalesPeriod),112)
 
	return @ret
 end

