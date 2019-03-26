create function fnGetListEAPrice
(
@PROD_ID varchar(55)
)
RETURNS decimal(38,8)
as
begin
	declare @EA_PRICE decimal(38,8)
	select @EA_PRICE = a.EA_PRICE from stage.list_price a
	where a.[ITEM NO] = @PROD_ID
	return @EA_PRICE
end