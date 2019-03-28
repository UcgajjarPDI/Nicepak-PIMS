﻿CREATE PROCEDURE [CNT].[spLOAD_PRC_AUTH_EB]
WITH EXEC AS CALLER
AS
BEGIN  

  -- THERE ARE MANY DUPLICATES WITH MULTIPLE ACTIVATION OF SAME RECORDS -- SO NEED TO TAKE THE MAX ACTIVATION DATE
  INSERT INTO CNT.PRC_AUTH_EB
  ( 
  GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, 
  GPO_CNT_NR, MFG_CNT_NR, TIER_NR, PRC_EFF_DT, PRC_EXP_DT, PRC_ACT_NR, PRC_ACT_DT, 
  LIC_NR, STATUS, DEA, GLN, HIN, SEGMENT, 
  REC_STAT_CD,  EDI_TRANSFER_STAT, [CURRENT_TIMESTAMP])
  SELECT
   GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, 
   GPO_CNT_NR, MFG_CNT_NR, TIER_NR, MAX(PRC_EFF_DT), max(PRC_EXP_DT), MAX(PRC_ACT_NR), MAX(PRC_ACT_DT), 
   LIC_NR, STATUS, DEA, GLN, HIN, SEGMENT, 
   REC_STAT, 'P', max([CURRENT_TIMESTAMP])
  FROM STAGE.PRC_AUTH
  -- WHERE LOAD_IN = 'P'
  GROUP BY
    GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, 
    GPO_CNT_NR, MFG_CNT_NR, TIER_NR,LIC_NR, STATUS, DEA, GLN, HIN, SEGMENT,  REC_STAT;
 
 -- DIX REC EFF AND EXP DATE
  UPDATE CNT.PRC_AUTH_EB SET REC_EFF_DT = CASE 
        WHEN PRC_ACT_DT IS NULL AND PRC_EFF_DT IS NOT NULL THEN PRC_EFF_DT
        WHEN PRC_ACT_DT IS NOT NULL AND PRC_EFF_DT IS NULL THEN PRC_ACT_DT
        ELSE CONVERT(DATE,[CURRENT_TIMESTAMP]) end,
    REC_EXP_DT = CONVERT(DATE,'9999-12-31')
  WHERE EDI_TRANSFER_STAT = 'P';
  
  --UPDATE STAGE.PRC_AUTH SET LOAD_IN = 'C' WHERE LOAD_IN = 'P';
  
  -- ADDRESS CLEANSING --
  TRUNCATE TABLE MDM_STAGE.TEMP_ADDR;
  
  INSERT INTO MDM_STAGE.TEMP_ADDR (SRC_ID, ADDR_1, ADDR_2 )
  SELECT PRC_AUTH_ID, GPO_MBR_ADDR1, GPO_MBR_ADDR2
  FROM CNT.PRC_AUTH_EB
  WHERE EDI_TRANSFER_STAT = 'P';

  -- Process Address -- This will have clean address in the 'TEMP_ADDR_PARTS table
  EXEC [STAGE].[spADDR_LAUNDRY];

  UPDATE T SET
    GPO_MBR_ADDR1 =  S.ADDR_1,
    GPO_MBR_ADDR2 = S.ADDR_2
  FROM CNT.PRC_AUTH_EB T
  JOIN MDM_STAGE.TEMP_ADDR_PARTS S ON T.PRC_AUTH_ID = S.SRC_ID
  WHERE EDI_TRANSFER_STAT = 'P';

  -- FIX ZIP CODE
  UPDATE CNT.PRC_AUTH_EB
  SET GPO_MBR_ZIP= '0'+GPO_MBR_ZIP
  WHERE LEN(GPO_MBR_ZIP ) = 4
  AND EDI_TRANSFER_STAT = 'P';
  
  -- FIX STATE NAME
  UPDATE E
    SET  E.GPO_MBR_ST = Z.State
   FROM CNT.PRC_AUTH_EB E
 JOIN REF.ZIP_CODE Z ON E.GPO_MBR_ZIP = Z.Zipcode
  WHERE LEN(E.GPO_MBR_ST) > 2
  AND EDI_TRANSFER_STAT = 'P';
  
    -- EXCLUDE BAD RECORDS
  UPDATE E
    SET E.REC_STAT_CD = 'I'
  FROM CNT.PRC_AUTH_EB E --REF.STATE_LIST
  LEFT JOIN REF.STATE_LIST S ON E.GPO_MBR_ST = S.ST
  WHERE  S.ST IS NULL
  AND EDI_TRANSFER_STAT = 'P';
  
  /*
  UPDATE T SET
    T.CMPNY_ID = C.SRC_ID 
  FROM CNT.PRC_AUTH_EB T
  JOIN MDM_STAGE.TEMP_ADDR_PARTS A ON T.PRC_AUTH_ID = A.SRC_ID
  JOIN MDM_STAGE.CMPNY_ADDR_PARTS C ON 
    ISNULL(A.ST_NR,'na') = ISNULL(C.ST_NR,'na') 
    AND ISNULL(A.ST_NM,'na') = ISNULL(C.ST_NM,'na')
    AND ISNULL(A.STE_NR,'na') = ISNULL(C.STE_NR,'na');
    
  TRUNCATE TABLE MDM_STAGE.TEMP_ADDR_PARTS;
  */
  

  
  
END