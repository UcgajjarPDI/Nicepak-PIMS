﻿CREATE PROCEDURE [MDM].[spTRC_GET_CO_USR_FEEDBK]
@TERR_ID varchar(10), @RSTATUS varchar(20)
WITH EXEC AS CALLER
AS
BEGIN

  SELECT TOP 100 C.USER_FEEDBK_CO_ID, 
    C.COACCTSHIPNAME_Source, 
    C.COACCTSHIPADDR1_Source, C.COACCTSHIPADDR2_Source, 
    C.COACCTSHIPCITY_Source, C.COACCTSHIPSTATE_Source, 
    C.COACCTSHIPZIP_Source, 
    C.COACCTSHIPNAME_Output, C.COACCTSHIPADDR1_Output, 
    C.COACCTSHIPADDR2_Output, C.COACCTSHIPCITY_Output, 
    C.COACCTSHIPSTATE_Output, C.COACCTSHIPZIP_Output 
  FROM 
    PDI_SALESTRACING_DEV.[CMPNY].[USR_FEEDBK_CO] C--change by krunal
  WHERE C.USR_FEEDBK_CD IS NULL
    AND C.Record_Status = ISNULL(@RSTATUS,C.Record_Status)  
    AND C.TERR_ID = ISNULL(@TERR_ID,C.TERR_ID)
    
END