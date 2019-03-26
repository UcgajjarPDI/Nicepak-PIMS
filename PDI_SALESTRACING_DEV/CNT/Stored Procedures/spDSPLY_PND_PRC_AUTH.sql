﻿CREATE PROCEDURE [CNT].[spDSPLY_PND_PRC_AUTH]
WITH EXEC AS CALLER
AS
BEGIN

SELECT GPO_NM AS GPO, GPO_MBR_ID, GPO_MBR_NM AS [NAME], GPO_MBR_ADDR1 [ADDR], GPO_MBR_CITY [CITY], GPO_MBR_ST [ST], GPO_MBR_ZIP [ZIP], MFG_CNT_NR [CNT NR], TIER_NR [TIER]
FROM CNT.PRC_AUTH_EB
WHERE EDI_TRANSFER_STAT = 'P'
AND REC_STAT_CD = 'A' 

END