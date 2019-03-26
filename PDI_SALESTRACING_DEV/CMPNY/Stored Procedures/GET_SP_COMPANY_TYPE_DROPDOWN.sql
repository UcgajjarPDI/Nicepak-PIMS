-- =============================================
-- Author:		KRUNAL TRIVEDI
-- Create date: <Create Date,,>
-- Description:	DROP DOWN FOR PDI1 WEBSITE PAGE=NEW_CONTRACT.ASPX
-- =============================================
CREATE PROCEDURE CMPNY.GET_SP_COMPANY_TYPE_DROPDOWN 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  CMPNY_TYP_ID, CASE WHEN CMPNY_TYP_NM = 'EU' THEN 'LOCAL' ELSE CMPNY_TYP_NM END AS CMPNY_TYP_NM
FROM CMPNY.COMPANY_TYPE
WHERE CMPNY_TYP_NM IN ('GPO','IDN','EU')
ORDER BY 1   

END
