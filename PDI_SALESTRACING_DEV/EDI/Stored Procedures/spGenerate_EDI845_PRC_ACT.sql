/*
 -- Based on Price authorization table load indicator, send data to 

*/
CREATE PROCEDURE [EDI].[spGenerate_EDI845_PRC_ACT]
WITH EXEC AS CALLER
AS
BEGIN
  
  DECLARE @REC_CNT INT, @EDI_REC_CNT INT, @TransferID INT; 

  --- C O N T R O L   T A B L E ---
  SELECT @EDI_REC_CNT = COUNT(*) FROM [EDI].[EDI_TRNSFR_CNTRL_TABLE];
  IF @EDI_REC_CNT = 0
    BEGIN
      SET @TransferID = 1
    END
  ELSE 
    BEGIN
      SELECT @TransferID = MAX([TRNSFR_ID])
      FROM [EDI].[EDI_TRNSFR_CNTRL_TABLE];      
      SET @TransferID = @TransferID + 1
    END; 
 
  SET @TransferID = @TransferID + 1;

    ---------------------------------------
    --- PRICE AUTHORIZATION  ----
    ----------------------------------------
    SELECT @REC_CNT = COUNT(*) 
    FROM [CNT].[PRC_AUTH_EB] P
    WHERE P.EDI_TRANSFER_STAT  = 'P'; 
  
  IF @REC_CNT>0    --- Then a updated contract for extend or expire has been added, 
    BEGIN  
  -- INSERT PRC_AUTH  from PRICE AUTHORIZATIONS  (from GPO) (for TIER 2 and up)
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT (
        [Transfer ID], 
        [MF Contract Number],[Contract Status Code],
        [Buyer Group Contract Number], [MF Contract Name], --[Previous Contract Number], 
        [Contract Effective Date], [Contract Expiration Date],-- [Replaced Contract Expiration Date], 
        [Contract Tier Number], 
        [Buyer Group Name], 
        [Eligible Buyer Name], 
        [Manufacturer Name], 
        [Buyer Group HIN], --[Manufacturer HIN], 
        [Eligible Buyer Account Number], [Eligible Buyer GPO Account Number], 
        [Eligible Buyer Address 1], --[Eligible Buyer Address 2], 
        [Eligible Buyer City], [Eligible Buyer State], [Eligible Buyer Zip], --[Eligible Buyer Country Code], 
        [Update Reason Code], [Eligible Buyer Effective Date], [Eligible Buyer Expiration Date], 
        SRC_REC_LST_MOD_DTTM_NR, [PDI Action Code], [Current Timestamp])
      SELECT DISTINCT 
      @TransferID, 
       C.CNT_NR, 'VA',
       CASE  WHEN C.CNT_TYP_CD = 'GPO' 
              THEN C.BUYER_GRP_CNT_NR   
              ELSE C.CNT_NR END AS [Buyer Group Contract Number],  
        CASE WHEN P.TIER_NR = 1 
             THEN 'ALL CUSTOMERS ELIGIBLE'
             ELSE C.CNT_NR+' Tier '+ cast(C.CNT_TIER_LVL_NR as varchar(2)) END
             AS [MF Contract Name],              
        C.CNT_EFF_DT_NR, C.CNT_EXP_DT_NR, 
		    C.CNT_TIER_LVL_NR AS [Contract Tier Number],
        G.GRP_NM AS [Buyer Group Name],
        --EU.ENDUSER_NAME as [Eligible Buyer Name],
        CASE WHEN LEN(P.GPO_MBR_NM)>60 THEN LEFT(LTRIM(RTRIM(P.GPO_MBR_NM)),60) ELSE P.GPO_MBR_NM END AS [Eligible Buyer Name],
        --P.GPO_MBR_NM as [Eligible Buyer Name],
        'PDI Healthcare' [Manufacturer Name],
        G.HIN AS [Buyer Group HIN],    
       -- CASE WHEN P.CMPNY_ID IS NOT NULL THEN P.CMPNY_ID ELSE P.GPO_MBR_ID END 
        ISNULL(P.CMPNY_ID,P.GPO_MBR_ID) [Eligible Buyer Account Number] ,
        P.GPO_MBR_ID AS [Eligible Buyer GPO Account Number],
        CASE WHEN LEN(P.GPO_MBR_ADDR1)>60 THEN LEFT(LTRIM(RTRIM(P.GPO_MBR_ADDR1)),60) ELSE P.GPO_MBR_ADDR1 END AS [Eligible Buyer Address 1],
        P.GPO_MBR_CITY AS [Eligible Buyer City],
        P.GPO_MBR_ST as [Eligible Buyer State], 
        P.GPO_MBR_ZIP AS [Eligible Buyer Zip],
        'A' AS [Update Reason Code], 
        C.CNT_EFF_DT_NR AS [Eligible Buyer Effective Date], 
        C.CNT_EXP_DT_NR AS [Eligible Buyer Expiration Date], 
        C.SRC_REC_LST_MOD_DT , 5 AS [PDI Action Code], -- CODE for Add EB
        CURRENT_TIMESTAMP     
      FROM [CNT].[PRC_AUTH_EB] P
      JOIN [CNT].[CONTRACT] C on C.CNT_NR = P.MFG_CNT_NR AND C.REC_STAT_CD = 'A'
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE P.EDI_TRANSFER_STAT = 'P';
     
    INSERT INTO [EDI].[EDI_TRNSFR_CNTRL_TABLE]
      (TRNSFR_ID, TRNSFR_DTE, 
      EDI_NR, NOTFN_PRPS_CD, 
      SENDER_ID, SENDER_NM, 
      RCVR_ID, RCVR_NM, 
      EDI_TYPE,   EDI_FILE_NM, 
      TRNSFR_TYP_CD, --TOT_REC_NR, 
      TRNSFR_STAT, [Current Timestamp])
    SELECT DISTINCT 
     @TransferID,
	   CONVERT(int,CONVERT(char(8),getdate(),112)) AS TRNSFR_DTE, 
      '845' AS EDI_NR, CD.EDI_HDR_CD, 
      '80-651-3813', 'PDI HC',
       TP.TP_EDI_ID, TP.TP_NM , 
      'CNT', 'EDI_845_'+TP.TP_NM+'_'+CD.EDI_HDR_CD+'_'+CONVERT(char(8),getdate(),112) +'_'+RTRIM(LTRIM(STR(@TransferID))),
      'SND','P', CURRENT_TIMESTAMP
    FROM [CNT].[PRC_AUTH_EB] P
      JOIN [CNT].[CONTRACT] C on C.CNT_NR = P.MFG_CNT_NR AND C.REC_STAT_CD = 'A'
      JOIN EDI.EDI_TRGR TR ON TR.EDI_TRGR_DES = 'ADD EB' 
      JOIN EDI.EDI_CD CD ON CD.PDI_ACTION_CD = TR.EDI_TRGR_CD
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON TP.TP_PDI_ID = CD.TP_PDI_ID 
    END


    ---------------------------------------
    --- RESET PRICE AUTHORIZATION TABLE ----
    ----------------------------------------

    UPDATE [CNT].[PRC_AUTH_EB] SET
      EDI_TRANSFER_STAT  = 'C'
    WHERE EDI_TRANSFER_STAT  = 'P'; 
  
  --- C O N T R O L   T A B L E ---
  -- Populate EDI Control table - the actual transfer of data will be based on this table
  INSERT INTO [EDI].[EDI_TRNSFR_CNTRL_TABLE]
      (TRNSFR_ID, TRNSFR_DTE, 
      EDI_NR, NOTFN_PRPS_CD, 
      SENDER_ID, SENDER_NM, 
      RCVR_ID, RCVR_NM, 
      EDI_TYPE,   EDI_FILE_NM, 
      TRNSFR_TYP_CD, --TOT_REC_NR,
      TRNSFR_STAT, [Current Timestamp])
    SELECT DISTINCT 
      @TransferID,
	   CONVERT(int,CONVERT(char(8),getdate(),112)) AS TRNSFR_DTE, 
      '845' AS EDI_NR, CD.EDI_HDR_CD, 
      '80-651-3813', 'PDI HC',
       TP.TP_EDI_ID, TP.TP_NM , 
      'CNT', 'EDI_845_'+TP.TP_NM+'_'+CD.EDI_HDR_CD+'_'+CONVERT(char(8),getdate(),112) +'_'+RTRIM(LTRIM(STR(@TransferID))),
      'SND','P', CURRENT_TIMESTAMP
    FROM [CNT].[CONTRACT] C
      JOIN (
            SELECT DISTINCT CNT_NR, SRC_REC_LST_MOD_DT AS MOD_DT FROM [STAGE].[TEMP_UPDT_CONT_DT]
            UNION
            SELECT DISTINCT CNT_NR, SRCE_REC_MOD_DT_NR AS MOD_DT FROM [STAGE].[TEMP_NEW_ITEM_EXIST_CONT]
            UNION
            SELECT DISTINCT CNT_NR, SRCE_REC_MOD_DT_NR  AS MOD_DT FROM [STAGE].[TEMP_UPD_ITEM] 
            ) AS SQ
      ON SQ.CNT_NR = C.CNT_NR AND SQ.MOD_DT = C.SRC_REC_LST_MOD_DT
      JOIN EDI.EDI_TRGR TR ON  C.CNT_UPD_TYP = TR.EDI_TRGR_DES
      JOIN EDI.EDI_CD CD ON CD.PDI_ACTION_CD = TR.EDI_TRGR_CD
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON TP.TP_PDI_ID = CD.TP_PDI_ID 
      
  
END