﻿CREATE PROCEDURE [PCM].[spPCM_Get_Contract] 
( @UNM VARCHAR(20))
WITH EXEC AS CALLER
AS
BEGIN

DECLARE @CNT_NR VARCHAR(20);
DECLARE @RecCnt int;

SELECT @RecCnt = COUNT(*)
FROM PDI_SALESTRACING_DEV.PCM.PCM_CNT_USR 
WHERE USR_ID =  @UNM AND ACTIVE_IN = 'Y';

IF @RecCnt = 1
  BEGIN
    SELECT @CNT_NR = CNT_NR
    FROM PDI_SALESTRACING_DEV.PCM.PCM_CNT_USR 
    WHERE USR_ID =  @UNM AND ACTIVE_IN = 'Y'
    
    IF @CNT_NR = 'ALL'
    BEGIN
      SELECT CNT_NR, 
      G.GRP_SHRT_NM ,CNT_TYP_CD , CNT_TIER_LVL, 
      CONVERT(VARCHAR(10),CNT_EFF_DT,101) CNT_EFF_DT, 
      CONVERT(VARCHAR(10),CNT_EXP_DT,101) CNT_EXP_DT
      FROM PDI_SALESTRACING_DEV.PCM.PCM_CONTRACT C
      JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID
    END
    ELSE
    BEGIN
      SELECT C.CNT_NR, G.GRP_SHRT_NM ,CNT_TYP_CD , CNT_TIER_LVL, 
      CONVERT(VARCHAR(10),CNT_EFF_DT,101) CNT_EFF_DT, 
      CONVERT(VARCHAR(10),CNT_EXP_DT,101) CNT_EXP_DT
      FROM PDI_SALESTRACING_DEV.PCM.PCM_CONTRACT C
      JOIN PDI_SALESTRACING_DEV.PCM.PCM_CNT_USR U ON U.CNT_NR = C.CNT_NR
      JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID
      WHERE U.USR_ID = @UNM
    END
  END
ELSE
  BEGIN
      SELECT C.CNT_NR, G.GRP_SHRT_NM,CNT_TYP_CD , CNT_TIER_LVL, 
      CONVERT(VARCHAR(10),CNT_EFF_DT,101) CNT_EFF_DT, 
      CONVERT(VARCHAR(10),CNT_EXP_DT,101) CNT_EXP_DT
      FROM PDI_SALESTRACING_DEV.PCM.PCM_CONTRACT C
      JOIN PDI_SALESTRACING_DEV.PCM.PCM_CNT_USR U ON U.CNT_NR = C.CNT_NR
      JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID
      WHERE U.USR_ID = @UNM
  END


END