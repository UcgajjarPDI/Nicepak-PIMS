﻿
CREATE PROCEDURE CNT.spDELETE_CONTRACT_PRODUCT
	  @cntNr int
AS
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM CONT.CNT_PROD  WHERE CNT_PROD_PK = @cntNr	

END

