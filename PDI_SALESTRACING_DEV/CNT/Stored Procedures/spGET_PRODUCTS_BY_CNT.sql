﻿
CREATE PROCEDURE CNT.spGET_PRODUCTS_BY_CNT 
	  @cntNr varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
	a.CNT_PROD_PK, 
      a.PROD_ID,b.[PRODUCT_DESC],a.[PROD_PRC]
        FROM CONT.CNT_PROD A
		JOIN [PROD].[PROD_PRC_COMPARISON] B on a.PROD_ID=b.PROD_ID WHERE 
		a.[CNT_NR] = @cntNr
AND A.REC_STAT_CD = 'A' 
  ORDER BY [CURRENT TIMESTAMP] DESC

END


