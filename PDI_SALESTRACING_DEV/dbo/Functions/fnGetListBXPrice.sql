create function fnGetListBXPrice
(
@PROD_ID varchar(55)
)
RETURNS decimal(38,8)
as
begin
	declare @BX_PRICE decimal(38,8)
	select @BX_PRICE = a.BX_PRICE from stage.list_price a
	where a.[ITEM NO] = @PROD_ID
	return @BX_PRICE
end