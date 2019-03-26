﻿CREATE PROCEDURE [TRC].[spGET_IDN_HIER]
(@CMPNY_ID INT)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @REC_CNT smallint, @PRNT_ID INT;


SELECT TOP 1 @PRNT_ID = RL.REL_CMPNY_ID
FROM CMPNY.CMPNY_REL RL 
JOIN CMPNY.COMPANY_REL_TYPE RT ON RL.REL_TYPE_ID = RT.REL_TYP_ID
WHERE RT.REL_TYP_NM = 'PARENT' AND RT.REL_SUB_TYP_CD = 'IDN'
    AND RL.CMPNY_ID = @CMPNY_ID;
    

IF @PRNT_ID IS NOT NULL 
  BEGIN
    select 
      UPPER(CP.CMPNY_NM)+' at '+CP.CMPNY_CITY+', '+CP.CMPNY_ST+' '+CP.CMPNY_ZIP AS IDN, 
      CC.CMPNY_ID, CC.CMPNY_NM, UPPER(CC.CMPNY_ADDR_1) ADDR, CC.CMPNY_CITY, CC.CMPNY_ST, CC.CMPNY_ZIP, 
      SUM(E.SALES_SUM) AS SALES_AMT
    FROM CMPNY.CMPNY_REL RL 
    JOIN CMPNY.COMPANY CP ON CP.CMPNY_ID = RL.REL_CMPNY_ID
    JOIN CMPNY.COMPANY CC ON CC.CMPNY_ID = RL.CMPNY_ID
    JOIN CMPNY.COMPANY_REL_TYPE RT ON RL.REL_TYPE_ID = RT.REL_TYP_ID
    LEFT JOIN STAGE.TRC_ENDUSER_1 E ON RL.CMPNY_ID = E.COMPANY_ID
    WHERE RT.REL_TYP_NM = 'PARENT' AND RT.REL_SUB_TYP_CD = 'IDN'
      AND RL.REL_CMPNY_ID = @PRNT_ID
    GROUP BY
    UPPER(CP.CMPNY_NM)+' at '+CP.CMPNY_CITY+', '+CP.CMPNY_ST+' '+CP.CMPNY_ZIP,
    CC.CMPNY_ID, CC.CMPNY_NM, UPPER(CC.CMPNY_ADDR_1), CC.CMPNY_CITY, CC.CMPNY_ST, CC.CMPNY_ZIP;
  END
    SELECT
      'IDN not found' AS IDN, 
      CC.CMPNY_ID, CC.CMPNY_NM, UPPER(CC.CMPNY_ADDR_1) ADDR, CC.CMPNY_CITY, CC.CMPNY_ST, CC.CMPNY_ZIP, 
      SUM(ISNULL(E.SALES_SUM,0)) AS SALES_AMT
    FROM CMPNY.COMPANY CC
    LEFT JOIN STAGE.TRC_ENDUSER_1 E ON CC.CMPNY_ID = E.COMPANY_ID
    WHERE CC.CMPNY_ID = @CMPNY_ID
    GROUP BY
    CC.CMPNY_ID, CC.CMPNY_NM, UPPER(CC.CMPNY_ADDR_1), CC.CMPNY_CITY, CC.CMPNY_ST, CC.CMPNY_ZIP;

END