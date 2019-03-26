
CREATE PROCEDURE CNT.spGET_COMPANY_SALES_DETAILS 
	@cmpnyId int
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT [CMPNY_ID]
      ,[Sani Surface] as SANI_SURFACE
      ,[Prevantics]
      ,[Specialty]
      ,[Sani Hands] AS SANI_HANDS
      ,[Iodine]
      ,[Baby Wipes] AS BABY_WIPES
      ,[Hygea]
      ,[Adult Wipes] as ADULT_WIPES
      ,[Compliance Accessories] as Comp_Acc
      ,[Profend]
      ,[All Other] AS OTHER
      ,CONVERT(varchar, CAST( ROUND([TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT
  FROM [CMPNY].[CMPNY_SALES]
	WHERE [CMPNY_ID] =@cmpnyId

END