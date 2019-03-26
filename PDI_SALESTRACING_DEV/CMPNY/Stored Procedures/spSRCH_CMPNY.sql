CREATE PROCEDURE [CMPNY].[spSRCH_CMPNY]
@CO_NM varchar(200) = null, @CO_ADDR varchar(200) = null, @CO_CITY varchar(100) = null, @CO_ST varchar(20) = null, @CO_ZIP varchar(20) = null
WITH EXEC AS CALLER
AS
BEGIN

--DECLARE @MSG VARCHAR(200);

--IF @CO_NM IS NULL AND @CO_ADDR IS NULL
--  BEGIN
--    SET @MSG  = 'At least name or alternate name or street address is needed to run a search'
--  END
--ELSE
--  BEGIN
--SET @CO_NM  = '%'+@CO_NM+'%';
--SET @CO_ALT_NM  = '%'+@CO_ALT_NM+'%';
--SET @CO_ADDR  = '%'+@CO_ADDR+'%';
--SET @CO_CITY  = '%'+@CO_CITY+'%';
--SET @CO_ST  = '%'+@CO_ST+'%';
    
  SELECT 
    c.[CMPNY_ID]as COMPANY_ID, 
	c.[CMPNY_NM] as CMPNY_NM,
	c.[CMPNY_ALT_NM] as CMPNY_ALT_NM,
	c.[CMPNY_ADDR_1]as ADDR_1,
	c.[CMPNY_CITY]as CITY,
	c.[CMPNY_ST]as ST,
	c.[CMPNY_ZIP]as ZIP, 
	c.CMPNY_SGMNT_ID,
	c.BUYER_INDICATOR as BI,
	CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT,
	'MDM' as source
    FROM [CMPNY].[COMPANY] c
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