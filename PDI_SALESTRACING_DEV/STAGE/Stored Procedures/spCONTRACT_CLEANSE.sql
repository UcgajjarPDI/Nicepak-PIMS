﻿CREATE PROCEDURE [STAGE].[spCONTRACT_CLEANSE] 
WITH EXEC AS CALLER
AS
BEGIN  

  UPDATE CONT.[CONTRACT] 
  SET TIER_ID = SUBSTRING(STAGE.fnRemoveSpace(CNT_DESC), CHARINDEX('TIER ',STAGE.fnRemoveSpace(CNT_DESC))+5,1)
  WHERE CNT_DESC LIKE '%TIER%'
  and STAGE.fnRemoveSpace(CNT_DESC) <> 'Access Tier'

  UPDATE CONT.[CONTRACT] 
  SET TIER_ID = SUBSTRING(TIER_DESC,6,1)
  FROM CONT.[CONTRACT]
  WHERE TIER_DESC LIKE '%TIER %'
  AND STAGE.fnRemoveSpace(CNT_DESC) <> 'Access Tier'
  

  END;