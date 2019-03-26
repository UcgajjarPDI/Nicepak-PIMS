
CREATE PROCEDURE CNT.spGET_PRODUCT_BY_Name
	  @name varchar(30)      
AS
BEGIN
	
	SET NOCOUNT ON;
	select top 10 lTrim(rTrim([PROD_ID]))+'~'+lTrim(rTrim(PROD_DESC_ERP)) from [PROD].[PRODUCT] where PROD_DESC_ERP like '%' + @name +'%'

END




