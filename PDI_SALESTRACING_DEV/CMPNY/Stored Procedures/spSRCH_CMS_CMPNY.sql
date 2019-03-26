CREATE PROCEDURE [CMPNY].[spSRCH_CMS_CMPNY]
@CO_NM varchar(200) = null, @CO_ADDR varchar(200) = null, @CO_CITY varchar(100) = null, @CO_ST varchar(20) = null, @CO_ZIP varchar(20) = null
WITH EXEC AS CALLER
AS
BEGIN

--DECLARE @MSG VARCHAR(200);
SELECT 
  SRC_CMPNY_ID as COMPANY_ID, CMPNY_NM, CMPNY_ALT_NM,  
  CMPNY_ADDR_1 as ADDR_1, CMPNY_CITY AS CITY, CMPNY_ST AS ST, CMPNY_ZIP AS ZIP, 
  CMPNY_TYP_ID AS CMPNY_SGMNT_ID,'CMS' as source
FROM MDM_STAGE.CMS_COMPANY
where
  ( ltrim(rtrim([CMPNY_NM])) LIKE '%'+ISNULL(@CO_NM,[CMPNY_NM])+'%'  
    or ltrim(rtrim([CMPNY_ALT_NM])) like '%'+ISNULL(@CO_NM,[CMPNY_ALT_NM])+'%')
    and ltrim(rtrim([CMPNY_ADDR_1])) LIKE '%'+ISNULL(@CO_ADDR,[CMPNY_ADDR_1])+'%'
    and ltrim(rtrim([CMPNY_CITY])) LIKE '%'+ISNULL(@CO_CITY,[CMPNY_CITY])+'%'
    and ltrim(rtrim([CMPNY_ST])) LIKE '%'+ISNULL(@CO_ST,[CMPNY_ST])+'%'
    and ltrim(rtrim([CMPNY_ZIP])) LIKE '%'+ISNULL(@CO_ZIP,[CMPNY_ZIP])+'%'




 END