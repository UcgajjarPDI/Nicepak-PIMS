CREATE PROCEDURE [CONT].[GET_PRODUCT_PAGER]
       @SearchTerm VARCHAR(50) = ''
     
AS
BEGIN
    SELECT TOP 1 [PROD_ID]
      ,[PRODUCT_DESC]
      ,[LIST_PRICE]
      ,[ASP6]
      ,[ASP12]
      ,[VIZ_TIER_1]
      ,[AMERI_TIER_1]
      ,[AMERI_TIER_2]
      ,[HPG_PRC]
      ,[CURR_VOL]
  FROM [PROD].[PROD_PRC_COMPARISON] 
  where [PROD_ID]= @SearchTerm +'%'
END