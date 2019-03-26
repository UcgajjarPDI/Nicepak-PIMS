create function fnGetListCSPrice
(
@PROD_ID varchar(55)
)
RETURNS decimal(38,8)
as
begin
	declare @CS_PRICE decimal(38,8)
	select @CS_PRICE = a.CS_PRICE from stage.list_price a
	where a.[ITEM NO] = @PROD_ID
	return @CS_PRICE
end