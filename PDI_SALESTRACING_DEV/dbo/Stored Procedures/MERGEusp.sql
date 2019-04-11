﻿--SP_HELPTEXT 'MERGEusp'

--Select top 10 * from [STG0].[CONTRACT]  
  
--select top 10 * from [SNDBX].[CONTRACT]  
  
--Select top 10 * from [STG0].[CONTRACT]  
  
--select top 10 * from [SNDBX].[CONTRACT]  
  
CREATE  PROCEDURE MERGEusp   
  
AS   
  
BEGIN  
  
MERGE [SNDBX].[CONTRACT] A  
  
USING [STG0].[CONTRACT] B  
  
ON A.[CONTRACT_ID_PK] =B.[CONTRACT_ID_PK]  
  
WHEN MATCHED AND (A.[ORIG_EXP_DTE]<=B.[ORIG_EXP_DTE])   THEN   
  
UPDATE SET   [CNT_UPD_TYP]='EXTENDED CONTRACT'   

  
--WHEN NOT MATCHED AND (A.[CNT_UPD_TYP]<=B.[CNT_UPD_TYP])  AND (A.[ORIG_EXP_DTE]>=B.[ORIG_EXP_DTE])  THEN   
  
--UPDATE SET   [CNT_UPD_TYP]='EXPIRED CONTRACT'  
  
WHEN NOT MATCHED   BY TARGET THEN    
  
INSERT  (CNT_UPD_TYP) VALUES ('EXPIRED CONTRACT')  
  
WHEN NOT MATCHED BY SOURCE THEN   
DELETE   
;  
  
  
  
 END