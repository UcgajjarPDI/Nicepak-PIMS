
CREATE PROCEDURE CNT.spGET_PRODUCT_BY_ID
	  @name varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;
	select top 10 [PROD_ID] from [PROD].[PRODUCT] where prod_id like + @name +'%'

END




