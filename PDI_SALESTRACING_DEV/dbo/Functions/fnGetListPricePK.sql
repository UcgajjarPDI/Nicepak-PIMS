﻿create function fnGetListPricePK
(
@PROD_ID varchar(55)
)
RETURNS decimal(38,8)
as
begin
	declare @retI int 
	select @retI = a.PK from stage.list_price a
	where a.[ITEM NO] = @PROD_ID
	return @retI
end