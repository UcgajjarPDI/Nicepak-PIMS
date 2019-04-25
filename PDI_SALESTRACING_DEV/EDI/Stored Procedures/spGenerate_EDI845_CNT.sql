/*
    -- *** STEPS in this proc
    -- Insert data in the template at contract level, Control table will have the header level data
    -- UPDATE SECTION
    -- Extend / Expire Contract
    -- ITEM ADD
    -- ITEM DATE CHANGE

    -- INSERT PRICE AUTHORIZATIONS  (from GPO) (for TIER 2 and up)
    (from PRC_AUTH table)

    & Finally and IMPORTANT STEP(s)
    -- C O N T R O L   T A B L E ---
    -- Populate EDI Control table - the actual transfer of data will be based on this table
    &

    -- Empty the table, otherwise it EDI-845 wil be created again

*/
CREATE PROCEDURE [EDI].[spGenerate_EDI845_CNT]
WITH EXEC AS CALLER
AS
BEGIN
  
  DECLARE @REC_CNT INT, @EDI_REC_CNT INT, @TransferID INT, @EDI_TRGR_CD SMALLINT; 

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

    --  Insert data in the template at contract level, Control table will have the header level data
   
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT (
        [Transfer ID], 
        [MF Contract Number],[Contract Status Code],
        [Buyer Group Contract Number], [MF Contract Name], [Previous Contract Number], 
        [Contract Effective Date], [Contract Expiration Date], [Replaced Contract Expiration Date], 
        [Contract Tier Number], 
        [Buyer Group Name], 
        [Eligible Buyer Name], 
        [Manufacturer Name], 
        [Buyer Group HIN], --[Manufacturer HIN], 
        [Eligible Buyer Account Number], --[Eligible Buyer GPO Account Number], 
        [Eligible Buyer Address 1], --[Eligible Buyer Address 2], 
        [Eligible Buyer City], [Eligible Buyer State], [Eligible Buyer Zip], --[Eligible Buyer Country Code], 
        [Update Reason Code], [Eligible Buyer Effective Date], [Eligible Buyer Expiration Date], 
        [Item Update Type Code], [Item Description], [Manufacturers Item ID], 
        [Contract Unit Price], [Quantity Information], [Unit of Measure], 
        [Product Effective Date], [Product Expiration Date], 
        SRC_REC_LST_MOD_DTTM_NR, [PDI Action Code], [Current Timestamp])
      SELECT DISTINCT 
        @TransferID ,
        C.CNT_NR, 'VA',
        CASE  WHEN C.CNT_TYP_CD = 'GPO' 
              THEN C.BUYER_GRP_CNT_NR   
              ELSE C.CNT_NR END AS [Buyer Group Contract Number],               
        CASE  WHEN C.CNT_TYP_CD = 'GPO'
              THEN CASE WHEN C.CNT_TIER_LVL_NR = 1 
                        THEN 'ALL CUSTOMERS ELIGIBLE'
                        ELSE C.CNT_NR+' Tier '+cast(C.CNT_TIER_LVL_NR as varchar(2)) END
              ELSE 'LOCAL CONTRACT '+C.CNT_NR
        END AS [MF Contract Name],  
        C.RPLCD_CNT_NR AS [Previous Contract Number],
        C.CNT_EFF_DT_NR, C.CNT_EXP_DT_NR, 
        STAGE.fnGET_CNT_EXP(C.RPLCD_CNT_NR) AS [Replaced Contract Expiration Date],
        CNT_TIER_LVL_NR,
        CASE WHEN C.CNT_TYP_CD = 'GPO' THEN  G.GRP_NM  
            ELSE NULL END AS [Buyer Group Name],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE CM.CMPNY_NM END AS [Eligible Buyer Name],
        'PDI Healthcare' [Manufacturer Name],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN ELSE NULL END AS [Buyer Group HIN],    
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE ISNULL(G.CMPNY_ID, G.PDI_GRP_ID) END AS [Eligible Buyer Account Number],  
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE CM.CMPNY_ADDR_1 END AS [Eligible Buyer Address 1], 
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE CM.CMPNY_CITY END AS [Eligible Buyer City],  
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE CM.CMPNY_ST END AS [Eligible Buyer State],      
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE CM.CMPNY_ZIP END AS [Eligible Buyer Zip],     
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE 'A' END AS [Update Reason Code], 
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE C.CNT_EFF_DT_NR END AS [Eligible Buyer Effective Date], 
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE C.CNT_EXP_DT_NR END AS [Eligible Buyer Expiration Date], 
        EL.EDI_TRGR_CD AS [Item Update Type Code],
        CASE WHEN CI.ITEM_DESCRIPTION IS NOT NULL THEN CI.ITEM_DESCRIPTION ELSE 'UNKNOWN' END as [Item Description], 
        I.PROD_ID AS  [Manufacturers Item ID], 
        I.PROD_PRC as [Contract Unit Price], '1' as [Quantity Information],
        CASE WHEN I.PROD_UOM = 'CS' THEN 'CA' ELSE I.PROD_UOM END AS [Unit of Measure],
        I.PROD_EFF_DT_NR, I.PROD_EXP_DT_NR,
        SRCE_REC_MOD_DT_NR, ET.EDI_TRGR_CD AS [PDI Action Code],   
        CURRENT_TIMESTAMP     
      FROM [CNT].[CONTRACT] C
      JOIN [CNT].[CNT_PROD] I ON C.CNT_NR = I.CNT_NR  AND I.REC_STAT_CD = 'A'
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR ET ON C.CNT_UPD_TYP = ET.EDI_TRGR_DES
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      JOIN CMPNY.COMPANY CM ON G.CMPNY_ID = CM.CMPNY_ID
      WHERE 
        C.REC_STAT_CD = 'A' 
        AND C.DATA_XFER_IN = 'P'
        AND C.CNT_UPD_TYP IN ('New Contract', 'Replace Contract') ;

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
--    JOIN [STAGE].[TEMP_NEW_CONT] AS T ON T.CNT_NR = C.CNT_NR AND C.REC_STAT_CD = 'A'
      JOIN EDI.EDI_TRGR TR ON  C.CNT_UPD_TYP = TR.EDI_TRGR_DES
      JOIN EDI.EDI_CD CD ON CD.PDI_ACTION_CD = TR.EDI_TRGR_CD
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON TP.TP_PDI_ID = CD.TP_PDI_ID 
    WHERE
      C.REC_STAT_CD = 'A' 
      AND C.DATA_XFER_IN = 'P'
      AND C.CNT_UPD_TYP IN ('New Contract', 'Replace Contract') ;
    
  SET @TransferID = @TransferID + 1;
  
  ------------------------------
  -- UPDATE CONTRACT -----------
  -- Extend / Expire Contract --
 -------------------------------
           
    -- Load EDI template Table
    INSERT INTO EDI.EDI845_TRANSFER_TMPLT (
      [Transfer ID], 
      [MF Contract Number],[Contract Status Code],
      [Buyer Group Contract Number], [MF Contract Name], --[Previous Contract Number], 
      [Contract Effective Date], [Contract Expiration Date], -- [Replaced Contract Expiration Date], 
      [Contract Tier Number], 
      [Buyer Group Name], 
      --[Eligible Buyer Name], -- NOT needed by cardinal
      [Manufacturer Name], 
      [Buyer Group HIN], 
      SRC_REC_LST_MOD_DTTM_NR, [PDI Action Code], [Current Timestamp]
      )
    SELECT DISTINCT @TransferID ,
      C.CNT_NR, 'VA',
      CASE  WHEN C.CNT_TYP_CD = 'GPO' 
              THEN C.BUYER_GRP_CNT_NR   
              ELSE C.CNT_NR END AS [Buyer Group Contract Number],              
      CASE  WHEN C.CNT_TYP_CD = 'GPO'
            THEN CASE WHEN CNT_TIER_LVL_NR > 1 
                      THEN C.CNT_NR+' Tier '+cast(C.CNT_TIER_LVL_NR as varchar(2))
                      ELSE 'ALL CUSTOMERS ELIGIBLE'  END
            ELSE 'LOCAL CONTRACT '+C.CNT_NR
      END AS [MF Contract Name],             
      C.CNT_EFF_DT_NR, C.CNT_EXP_DT_NR, C.CNT_TIER_LVL_NR, 
      CASE WHEN C.CNT_TYP_CD = 'GPO' THEN  G.GRP_NM ELSE NULL END AS [Buyer Group Name],
      'PDI Healthcare' [Manufacturer Name],
      CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN  ELSE NULL END AS [Buyer Group HIN],  
      C.SRC_REC_LST_MOD_DT , ET.EDI_TRGR_CD ,  
      CURRENT_TIMESTAMP     
    FROM [CNT].[CONTRACT] C
    JOIN [EDI].[EDI_TRGR] ET ON C.CNT_UPD_TYP = ET.EDI_TRGR_DES
    JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
    WHERE
        C.REC_STAT_CD = 'A' 
        AND C.DATA_XFER_IN = 'P'
        AND C.CNT_UPD_TYP IN ('Extend Contract', 'Expire Contract');

   ---------------
   --- ITEM ADD --
   ---------------
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT (
        [Transfer ID], 
        [MF Contract Number],[Contract Status Code],
        [Buyer Group Contract Number], [MF Contract Name], --[Previous Contract Number], 
        [Contract Effective Date], [Contract Expiration Date],-- [Replaced Contract Expiration Date], 
        [Contract Tier Number], [Buyer Group Name], [Buyer Group HIN], [Eligible Buyer Name], 
        [Manufacturer Name], 
        [Item Update Type Code], 
        [Item Description], [Manufacturers Item ID], 
        [Contract Unit Price], [Quantity Information], [Unit of Measure], 
        [Product Effective Date], [Product Expiration Date], 
        SRC_REC_LST_MOD_DTTM_NR, [PDI Action Code], [Current Timestamp])
      SELECT DISTINCT 
      @TransferID,
        C.CNT_NR, 'VA',
        CASE  WHEN C.CNT_TYP_CD = 'GPO' 
              THEN C.BUYER_GRP_CNT_NR   
              ELSE C.CNT_NR END AS [Buyer Group Contract Number],              
        CASE  WHEN C.CNT_TYP_CD = 'GPO'
              THEN CASE WHEN C.CNT_TIER_LVL_NR > 1 AND C.CNT_TIER_LVL_NR IS NOT NULL
                        THEN C.CNT_NR+' Tier '+CONVERT(varchar(2),C.CNT_TIER_LVL_NR )
                        ELSE 'ALL CUSTOMERS ELIGIBLE' END
              ELSE 'LOCAL CONTRACT '+C.CNT_NR END AS [MF Contract Name],              
        C.CNT_EFF_DT_NR, C.CNT_EXP_DT_NR, C.CNT_TIER_LVL_NR,
        CASE WHEN C.CNT_TYP_CD = 'GPO' THEN G.GRP_NM -- X.GRP_SHRT_NM 
            ELSE NULL END AS [Buyer Group Name],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN  ELSE NULL END AS [Buyer Group HIN],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.GRP_NM END AS [Eligible Buyer Name],
        'PDI Healthcare' [Manufacturer Name],
        EL.EDI_TRGR_CD AS [Item Update Type Code],
        CI.ITEM_DESCRIPTION as [Item Description], 
        I.PROD_ID AS  [Manufacturers Item ID], 
        I.PROD_PRC as [Contract Unit Price], '1' as [Quantity Information],
        CASE WHEN I.PROD_UOM = 'CS' THEN 'CA' ELSE I.PROD_UOM END AS [Unit of Measure],
        I.PROD_EFF_DT_NR, I.PROD_EXP_DT_NR, 
        C.SRC_REC_LST_MOD_DT , ET.EDI_TRGR_CD, CURRENT_TIMESTAMP   
      FROM [CNT].[CONTRACT] C
      JOIN [CNT].[CNT_PROD] I ON C.CNT_NR = I.CNT_NR
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR ET ON I.PROD_STAT_CD = ET.EDI_TRGR_DES 
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE 
        C.REC_STAT_CD = 'A' 
        AND I.REC_STAT_CD = 'A'
        AND I.DATA_XFER_IN = 'P'
        AND I.PROD_STAT_CD = 'Item Add'        ;
   
  ------------------------
  --- ITEM DATE CHANGE
  ------------------------
        
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT (
        [Transfer ID], 
        [MF Contract Number],[Contract Status Code],
        [Buyer Group Contract Number], [MF Contract Name], --[Previous Contract Number], 
        [Contract Effective Date], [Contract Expiration Date],-- [Replaced Contract Expiration Date], 
        [Contract Tier Number], [Buyer Group Name],[Buyer Group HIN], [Eligible Buyer Name], 
        [Manufacturer Name], 
        [Item Update Type Code], 
        [Item Description], [Manufacturers Item ID], 
        [Contract Unit Price], [Quantity Information], [Unit of Measure], 
        [Product Effective Date], [Product Expiration Date], 
        SRC_REC_LST_MOD_DTTM_NR, [PDI Action Code],
        [Current Timestamp])
      SELECT DISTINCT 
      @TransferID,
        C.CNT_NR, 'VA',
        CASE  WHEN C.CNT_TYP_CD = 'GPO' 
              THEN C.BUYER_GRP_CNT_NR   
              ELSE C.CNT_NR END AS [Buyer Group Contract Number],                
        CASE  WHEN C.CNT_TYP_CD = 'GPO'
              THEN CASE WHEN C.CNT_TIER_LVL_NR = 1 
                        THEN 'ALL CUSTOMERS ELIGIBLE'
                        ELSE C.CNT_NR+' Tier '+cast(C.CNT_TIER_LVL_NR as varchar(2)) END
              ELSE 'LOCAL CONTRACT '+C.CNT_NR
        END AS [MF Contract Name],              
        C.CNT_EFF_DT_NR, C.CNT_EXP_DT_NR, C.CNT_TIER_LVL_NR,
        CASE WHEN C.CNT_TYP_CD = 'GPO' THEN G.GRP_NM 
            ELSE NULL END AS [Buyer Group Name],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN  ELSE NULL END AS [Buyer Group HIN],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.GRP_NM END AS [Eligible Buyer Name],
        'PDI Healthcare' [Manufacturer Name],
        EL.EDI_TRGR_CD AS [Item Update Type Code],
        CI.ITEM_DESCRIPTION as [Item Description], 
        I.PROD_ID AS  [Manufacturers Item ID], 
        I.PROD_PRC as [Contract Unit Price], '1' as [Quantity Information],
        CASE WHEN I.PROD_UOM = 'CS' THEN 'CA' ELSE I.PROD_UOM END AS [Unit of Measure],
        I.PROD_EFF_DT_NR, I.PROD_EXP_DT_NR,
        I.SRCE_REC_MOD_DT_NR , EL.EDI_TRGR_CD [PDI Action Code],   
        CURRENT_TIMESTAMP 
      FROM [CNT].[CONTRACT] C
      --JOIN [STAGE].[TEMP_UPD_ITEM] U ON U.CNT_NR = C.CNT_NR 
      JOIN [CNT].[CNT_PROD] I ON C.CNT_NR = I.CNT_NR --AND I.PROD_ID = U.ITM_NR  
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE 
        C.REC_STAT_CD = 'A' 
        AND I.REC_STAT_CD = 'A'
        AND I.DATA_XFER_IN = 'P'
        AND I.PROD_STAT_CD IN ('Item Extend','Item Expire','Item Delete' );

 ----------------------------------
  --- C O N T R O L   T A B L E ---
  ---------------------------------
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
    @TransferID, CONVERT(int,CONVERT(char(8),getdate(),112)) AS TRNSFR_DTE, 
    '845' AS EDI_NR, SQ.EDI_HDR_CD,
    '80-651-3813', 'PDI HC',
    SQ.TP_EDI_ID, SQ.TP_NM,
    'CNT', 'EDI_845_'+SQ.TP_NM+'_'+SQ.EDI_HDR_CD+'_'+CONVERT(char(8),getdate(),112) +'_'+RTRIM(LTRIM(STR(@TransferID))),
    'SND','P', CURRENT_TIMESTAMP
  FROM (
    SELECT DISTINCT CD.EDI_HDR_CD, TP.TP_EDI_ID, TP.TP_NM  
    FROM [CNT].[CONTRACT] C
      JOIN EDI.EDI_TRGR TR ON  C.CNT_UPD_TYP = TR.EDI_TRGR_DES
      JOIN EDI.EDI_CD CD ON CD.PDI_ACTION_CD = TR.EDI_TRGR_CD
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON TP.TP_PDI_ID = CD.TP_PDI_ID 
    WHERE C.REC_STAT_CD = 'A' AND C.DATA_XFER_IN = 'P' 
    UNION ALL
    SELECT DISTINCT CD.EDI_HDR_CD, TP.TP_EDI_ID, TP.TP_NM
    FROM [CNT].[CNT_PROD] I
      JOIN EDI.EDI_TRGR TR ON I.PROD_STAT_CD = TR.EDI_TRGR_DES
      JOIN EDI.EDI_CD CD ON TR.EDI_TRGR_CD = CD.PDI_ACTION_CD 
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON CD.TP_PDI_ID = TP.TP_PDI_ID 
    WHERE I.REC_STAT_CD = 'A' AND I.DATA_XFER_IN = 'P'
       ) SQ ;

    ---------------------------------------
    --- RESET PRICE CONTRACT TABLE ----
    ----------------------------------------
   
  UPDATE  [CNT].[CONTRACT] SET DATA_XFER_IN = 'C' WHERE DATA_XFER_IN = 'P';
  UPDATE  [CNT].[CNT_PROD] SET DATA_XFER_IN = 'C' WHERE DATA_XFER_IN = 'P';
  
      
END