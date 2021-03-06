﻿CREATE PROCEDURE [CMPNY].[spSRCH_CMPNY]
@CO_NM varchar(200) = null, @CO_ADDR varchar(200) = null, @CO_CITY varchar(100) = null, @CO_ST varchar(20) = null, @CO_ZIP varchar(20) = null
WITH EXEC AS CALLER
AS
BEGIN


  SELECT 
    c.[CMPNY_ID]as COMPANY_ID, 
	c.[CMPNY_NM] as CMPNY_NM,
	c.[CMPNY_ALT_NM] as CMPNY_ALT_NM,
  S.CMPNY_SGMNT_NM AS COMPANY_TYPE, 
	c.[CMPNY_ADDR_1]as ADDR_1,
	c.[CMPNY_CITY]as CITY,
	c.[CMPNY_ST]as ST,
	c.[CMPNY_ZIP]as ZIP, 
	c.CMPNY_SGMNT_ID,
	c.BUYER_INDICATOR as BI,
	CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT,
	'MDM' as source
    FROM [CMPNY].[COMPANY] c
    JOIN CMPNY.COMPANY_SEGMENT S ON c.CMPNY_SGMNT_ID = S.CMPNY_SGMNT_ID
	LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = c.CMPNY_ID
  WHERE 
  (     ltrim(rtrim(c.[CMPNY_NM])) LIKE '%'+ISNULL(@CO_NM,[CMPNY_NM])+'%'  
     or ltrim(rtrim(c.[CMPNY_ALT_NM])) like '%'+ISNULL(@CO_NM,[CMPNY_ALT_NM])+'%')
    and ltrim(rtrim(c.[CMPNY_ADDR_1])) LIKE '%'+ISNULL(@CO_ADDR,[CMPNY_ADDR_1])+'%'
    and ltrim(rtrim(c.[CMPNY_CITY])) LIKE '%'+ISNULL(@CO_CITY,[CMPNY_CITY])+'%'
    and ltrim(rtrim(c.[CMPNY_ST])) LIKE '%'+ISNULL(@CO_ST,[CMPNY_ST])+'%'
    and ltrim(rtrim(c.[CMPNY_ZIP])) LIKE '%'+ISNULL(@CO_ZIP,[CMPNY_ZIP])+'%'
 
   -- SET @MSG  = '';
 END