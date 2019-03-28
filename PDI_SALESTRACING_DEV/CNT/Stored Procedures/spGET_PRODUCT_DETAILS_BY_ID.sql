﻿
CREATE PROCEDURE [CNT].[spGET_PRODUCT_DETAILS_BY_ID]
	  @productId varchar(30)      
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT 
	TOP 1 [PROD_ID],
		[PRODUCT_DESC],
		[LIST_PRICE],
		[ASP6],
		[ASP12],
		[VIZ_TIER_1],
		[AMERI_TIER_1],
		[AMERI_TIER_2],
		[HPG_PRC],
		[CURR_VOL] 
	FROM [PROD].[PROD_PRC_COMPARISON] 
	where [PROD_ID] like   @productId + '%'
END



