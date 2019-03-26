CREATE PROCEDURE [SNDBX].[spSRCH_CMPNY_TEST]
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

  SELECT TOP 100
    [CMPNY_ID]as COMPANY_ID, [CMPNY_NM] as COMPANY_NM,[CMPNY_ALT_NM] as COMPANY_ALT_NM,[CMPNY_ADDR_1]as ADDR_1,[CMPNY_CITY]as CITY,[CMPNY_ST]as ST,[CMPNY_ZIP]as ZIP, CMPNY_SGMNT_ID
    FROM [CMPNY].[COMPANY] 
 WHERE 
  ( [CMPNY_NM] LIKE '%'+ISNULL(@CO_NM,[CMPNY_NM])+'%'  
    or [CMPNY_ALT_NM] like '%'+ISNULL(@CO_NM,[CMPNY_ALT_NM])+'%')
    and [CMPNY_ADDR_1] LIKE '%'+ISNULL(@CO_ADDR,[CMPNY_ADDR_1])+'%'
    and [CMPNY_CITY] LIKE '%'+ISNULL(@CO_CITY,[CMPNY_CITY])+'%'
    and [CMPNY_ST] LIKE '%'+ISNULL(@CO_ST,[CMPNY_ST])+'%'
    and [CMPNY_ZIP] LIKE '%'+ISNULL(@CO_ZIP,[CMPNY_ZIP])+'%' 
    ;
 
   -- SET @MSG  = '';
 END