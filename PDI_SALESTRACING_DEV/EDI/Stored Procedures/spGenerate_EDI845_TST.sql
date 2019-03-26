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
CREATE PROCEDURE [EDI].[spGenerate_EDI845_TST]
WITH EXEC AS CALLER
AS
BEGIN
  
  DECLARE @REC_CNT INT, @EDI_REC_CNT INT, @TransferID INT, @EDI_TRGR_CD SMALLINT; 

  SELECT @EDI_REC_CNT = COUNT(*) FROM [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST];
  IF @EDI_REC_CNT = 0
    BEGIN
      SET @TransferID = 1
    END
  ELSE 
    BEGIN
      SELECT @TransferID = MAX([TRNSFR_ID])
      FROM [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST];      
      SET @TransferID = @TransferID + 1
    END; 

  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_NEW_CONT]; 
  
  IF @REC_CNT>0    --- Then a new contract has been added, so take it 
  
    BEGIN
    --  Insert data in the template at contract level, Control table will have the header level data
   
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT_TST (
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
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.GRP_NM END AS [Eligible Buyer Name],
        'PDI Healthcare' [Manufacturer Name],
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN ELSE NULL END AS [Buyer Group HIN],    
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE ISNULL(G.CMPNY_ID, G.PDI_GRP_ID) END AS [Eligible Buyer Account Number],  
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.Address1 END AS [Eligible Buyer Address 1], 
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.City END AS [Eligible Buyer City],  
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.State END AS [Eligible Buyer State],      
        CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE G.Zip END AS [Eligible Buyer Zip],     
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
      FROM [CNT].[CONTRACT_TST] C
      JOIN [STAGE].[TEMP_NEW_CONT] N ON N.CNT_NR = C.CNT_NR 
      JOIN [CNT].[CNT_PROD_TST] I ON C.CNT_NR = I.CNT_NR  AND I.REC_STAT_CD = 'A'
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR ET ON C.CNT_UPD_TYP = ET.EDI_TRGR_DES
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      LEFT JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE C.REC_STAT_CD = 'A' ;
      
 
    END

  --- C O N T R O L   T A B L E ---
  -- Populate EDI Control table - the actual transfer of data will be based on this table
  INSERT INTO [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST]
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
    FROM [CNT].[CONTRACT_TST] C
    JOIN [STAGE].[TEMP_NEW_CONT] AS T
      ON T.CNT_NR = C.CNT_NR AND C.REC_STAT_CD = 'A'
      JOIN EDI.EDI_TRGR TR ON  C.CNT_UPD_TYP = TR.EDI_TRGR_DES
      JOIN EDI.EDI_CD CD ON CD.PDI_ACTION_CD = TR.EDI_TRGR_CD
      JOIN EDI.EDI_TRDNG_PRTNRS TP ON TP.TP_PDI_ID = CD.TP_PDI_ID ;

  SET @TransferID = @TransferID + 1;
  
  -- UPDATE SECTION
  -- Extend / Expire Contract
  -- CASE WHEN (C.CNT_TIER_LVL IS NULL OR STAGE.fnGet_Num(C.CNT_TIER_LVL)) IS NULL THEN NULL ELSE STAGE.fnGet_Num(C.CNT_TIER_LVL) END CNT_TIER_LVL,

  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_UPDT_CONT_DT]; 
    
  IF @REC_CNT>0    --- Then a updated contract for extend or expire has been added, 
    BEGIN              
    -- Load EDI template Table
    INSERT INTO EDI.EDI845_TRANSFER_TMPLT_TST (
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
      CASE WHEN C.CNT_TYP_CD = 'GPO' THEN  G.GRP_NM 
            ELSE NULL END AS [Buyer Group Name],
      --CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN NULL ELSE C.BUYER_GRP_NM END AS [Eligible Buyer Name],
      'PDI Healthcare' [Manufacturer Name],
      CASE  WHEN C.CNT_TYP_CD = 'GPO' THEN G.HIN  ELSE NULL END AS [Buyer Group HIN],  
      C.SRC_REC_LST_MOD_DT , ET.EDI_TRGR_CD ,  
      CURRENT_TIMESTAMP     
    FROM [CNT].[CONTRACT_TST] C
    JOIN [STAGE].[TEMP_UPDT_CONT_DT] N ON N.CNT_NR = C.CNT_NR AND C.SRC_REC_LST_MOD_DT = N.SRC_REC_LST_MOD_DT -- to pick only the new ones
    JOIN [EDI].[EDI_TRGR] ET ON C.CNT_UPD_TYP = ET.EDI_TRGR_DES
    --JOIN [STAGE].[CMS_PDI_GROUP_XREF] X ON C.BUYER_GRP_NM = X.PDI_CMS_GRP
    LEFT JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID;
    
    END
   
   --- ITEM ADD
  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_NEW_ITEM_EXIST_CONT]; 
    
  IF @REC_CNT>0    --- Then a updated contract for extend or expire has been added, 
    BEGIN   
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT_TST (
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
        --'AI' AS [Item Update Type Code],    -- HARCODED  -- LINE CODE
        EL.EDI_TRGR_CD AS [Item Update Type Code],
        CI.ITEM_DESCRIPTION as [Item Description], 
        I.PROD_ID AS  [Manufacturers Item ID], 
        I.PROD_PRC as [Contract Unit Price], '1' as [Quantity Information],
        CASE WHEN I.PROD_UOM = 'CS' THEN 'CA' ELSE I.PROD_UOM END AS [Unit of Measure],
        I.PROD_EFF_DT_NR, I.PROD_EXP_DT_NR, 
        N.SRCE_REC_MOD_DT_NR , ET.EDI_TRGR_CD,   
        CURRENT_TIMESTAMP   
      FROM [CNT].[CONTRACT_TST] C
      JOIN [STAGE].[TEMP_NEW_ITEM_EXIST_CONT] N ON N.CNT_NR = C.CNT_NR -- to pick only the new ones
      JOIN [CNT].[CNT_PROD_TST] I ON C.CNT_NR = I.CNT_NR AND I.PROD_ID = N.ITM_NR  AND I.REC_STAT_CD = 'A'
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR ET ON I.PROD_STAT_CD = ET.EDI_TRGR_DES 
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE C.REC_STAT_CD = 'A' ;
   
    END
    
  
  ------------------------
  --- ITEM DATE CHANGE
  ------------------------

  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_UPD_ITEM]; 
    
  IF @REC_CNT>0    --- Then a updated contract for extend or expire has been added, 
    BEGIN         
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT_TST (
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
        U.SRCE_REC_MOD_DT_NR , EL.EDI_TRGR_CD [PDI Action Code],   
        CURRENT_TIMESTAMP 
      FROM [CNT].[CONTRACT_TST] C
      JOIN [STAGE].[TEMP_UPD_ITEM] U ON U.CNT_NR = C.CNT_NR 
      JOIN [CNT].[CNT_PROD_TST] I ON C.CNT_NR = I.CNT_NR AND I.PROD_ID = U.ITM_NR  
      LEFT JOIN FTPOUT.CompanyItemsImport CI ON CI.ITEM_NO = I.PROD_ID
      JOIN EDI.EDI_TRGR EL ON EL.EDI_TRGR_DES =  I.PROD_STAT_CD 
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE C.REC_STAT_CD = 'A' AND I.REC_STAT_CD = 'A';
   
    END
   
    ---------------------------------------
    --- PRICE AUTHORIZATION  ----
    ----------------------------------------
    SELECT @REC_CNT = COUNT(*) 
    FROM [CNT].[PRC_AUTH_EB] P
    WHERE P.EDI_TRANSFER_STAT  = 'P'; 
  
  IF @REC_CNT>0    --- Then a updated contract for extend or expire has been added, 
    BEGIN  
  -- INSERT PRC_AUTH  from PRICE AUTHORIZATIONS  (from GPO) (for TIER 2 and up)
      INSERT INTO EDI.EDI845_TRANSFER_TMPLT_TST (
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
      JOIN [CNT].[CONTRACT_TST] C on C.CNT_NR = P.MFG_CNT_NR AND C.REC_STAT_CD = 'A'
     -- JOIN [NJ-SALESDBDEV].PDI_SALESTRACING.REPORT.DIM_ENDUSER EU ON P.EU_ID = EU.ENDUSER_ID -- GET IT FROM PRICE_AUTH TABLE
      JOIN [STAGE].[PRCHS_GRP] G ON C.BUYER_GRP_ID = G.PDI_GRP_ID
      WHERE P.EDI_TRANSFER_STAT = 'P';
     
     INSERT INTO [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST]
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
      JOIN [CNT].[CONTRACT_TST] C on C.CNT_NR = P.MFG_CNT_NR AND C.REC_STAT_CD = 'A'
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
  INSERT INTO [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST]
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
    FROM [CNT].[CONTRACT_TST] C
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