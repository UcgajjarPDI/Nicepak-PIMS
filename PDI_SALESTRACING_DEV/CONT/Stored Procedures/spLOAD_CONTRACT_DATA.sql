﻿CREATE PROCEDURE [CONT].[spLOAD_CONTRACT_DATA] 
WITH EXEC AS CALLER
AS
/*

exec [STAGE].[spCONTRACT_MASTER]

*STEPS
-- new Contract into [CONT].[TEMP_NEW_CONT]
-- For new contracts  insert ITEMS into CONT.ITEM_DEV
-- UPDATE CONTRACT (Contract Date Change - Extend / Expire ) insert into [CONT].[TEMP_UPDT_CONT_DT]
-- 

*/
BEGIN



  DECLARE @REC_CNT INT, @vINT Int;

  BEGIN
    MERGE CONT.CONTRACT_DEV T
    USING (
      SELECT DISTINCT
          CONVERT(DATE,LEFT(C.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(C.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(C.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT, 
          CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,
          'A' AS REC_STAT_CD, C.CNT_NR,
          CONVERT(DATE,LEFT(CNT_EFF_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EFF_DT_NR,4),2)+'-'+RIGHT(CNT_EFF_DT_NR,2)) AS CNT_EFF_DT, 
          CONVERT(DATE,LEFT(CNT_EXP_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EXP_DT_NR,4),2)+'-'+RIGHT(CNT_EXP_DT_NR,2)) AS CNT_EXP_DT,
          CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_TYP_CD,
          CONVERT(DATE,LEFT(CNT_APPRV_DT,4)+'-'+LEFT(RIGHT(CNT_APPRV_DT,4),2)+'-'+RIGHT(CNT_APPRV_DT,2)) AS CNT_APPRV_DT,
          'A' AS CNT_STAT_CD, --ISNULL(S.CNT_STATUS,'TBD') AS CNT_STAT_CD, 
          C.GRP_NM AS BUYE_GRP_NM,
          ISNULL(BUYER_GRP_CNT_NR, C.CNT_NR) AS BUYER_GRP_CNT_NR,
          ISNULL(CNT_TIER_LVL,'SPR') AS CNT_TIER_LVL,
          C.CNT_DESC, 'New Contract' AS CNT_UPD_TYP,
          C.LAST_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
      FROM [STAGE].[CONTRAXX_CNT] C
      JOIN [STAGE].[CONTRAXX_ITM] I ON C.CNT_NR = I.CNT_NR -- JUST TO MAKE SURE IT HAS ITEMS
      ) S ON T.CNT_NR = S.CNT_NR
      
    WHEN NOT MATCHED BY TARGET THEN   -- That means it is a new Contract

      INSERT 
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, BUYE_GRP_ID_FK,BUYE_GRP_NM,
      BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC, CNT_UPD_TYP, SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP] )
      VALUES
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, -1,BUYE_GRP_NM,
      BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
      
    OUTPUT
      INSERTED.[CNT_NR], INSERTED.[SRC_REC_LST_MOD_DT]
      INTO [CONT].[TEMP_NEW_CONT];
  
  END ;
  
 /****************************
  
  If there was any new contracts then that needs to be inserted into CNT_ITM
  
  ****************************/
    
  SELECT @REC_CNT = COUNT(*) 
  FROM [CONT].[TEMP_NEW_CONT];
  
  IF @REC_CNT > 0
    BEGIN
        INSERT INTO CONT.ITEM_DEV (  
          REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
          Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
          ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, 
          ITM_EXP_DT_NR, ITM_UOM, ITM_PRC, ITM_STAT_CD, SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP])
        SELECT DISTINCT
          CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,   
          CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,'A' AS REC_STAT_CD, 
          C.Contract_ID_PK AS Contract_ID_FK, C.CNT_NR,
          -1 AS ITM_ID_FK, I.ITM_NR,
          CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+LEFT(RIGHT(I.ITM_EFF_DT_NR,4),2)+'-'+RIGHT(I.ITM_EFF_DT_NR,2)) AS ITM_EFF_DT, 
          CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+LEFT(RIGHT(I.ITM_EXP_DT_NR,4),2)+'-'+RIGHT(I.ITM_EXP_DT_NR,2)) AS ITM_EXP_DT,
          ITM_EFF_DT_NR, ITM_EXP_DT_NR,
          I.UOM AS ITM_UOM, I.CNT_PRC AS ITM_PRC, 'Item Add' AS ITM_STAT_CD ,
          I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
        FROM [STAGE].[CONTRAXX_ITM] I
        JOIN [CONT].[TEMP_NEW_CONT] N ON N.CNT_NR = I.CNT_NR
        JOIN CONT.CONTRACT_DEV C ON C.CNT_NR = N.CNT_NR      
        WHERE C.REC_STAT_CD = 'A';
        
    END;
    

     --------------------------------------------------
     ----  UPDATE CONTRACT
     ----  Contract Date Change - Extend / Expire 
     --------------------------------------------------

  BEGIN
    MERGE CONT.CONTRACT_DEV T
    USING (
      SELECT DISTINCT
          CONVERT(DATE,LEFT(C.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(C.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(C.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT, 
          CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,
          'P' AS REC_STAT_CD, -- will be turned to 'A" after inactivating last active record
          C.CNT_NR,
          CONVERT(DATE,LEFT(CNT_EFF_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EFF_DT_NR,4),2)+'-'+RIGHT(CNT_EFF_DT_NR,2)) AS CNT_EFF_DT, 
          CONVERT(DATE,LEFT(CNT_EXP_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EXP_DT_NR,4),2)+'-'+RIGHT(CNT_EXP_DT_NR,2)) AS CNT_EXP_DT,
          CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_TYP_CD,
          CONVERT(DATE,LEFT(CNT_APPRV_DT,4)+'-'+LEFT(RIGHT(CNT_APPRV_DT,4),2)+'-'+RIGHT(CNT_APPRV_DT,2)) AS CNT_APPRV_DT,
          'A' AS CNT_STAT_CD, 
          C.GRP_NM AS BUYE_GRP_NM,
          ISNULL(BUYER_GRP_CNT_NR, C.CNT_NR) AS BUYER_GRP_CNT_NR,
          ISNULL(CNT_TIER_LVL,'SPR') AS CNT_TIER_LVL,
          C.CNT_DESC, 'Contract Date Update' AS CNT_UPD_TYP, 
          C.LAST_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
      FROM [STAGE].[CONTRAXX_CNT] C
      JOIN [STAGE].[CONTRAXX_ITM] I ON C.CNT_NR = I.CNT_NR  
      WHERE C.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [CONT].[TEMP_NEW_CONT]) -- JUST TO MAKE SURE it's not new contract
      ) S ON T.CNT_NR = S.CNT_NR AND T.CNT_EXP_DT_NR = S.CNT_EXP_DT_NR
      
    WHEN NOT MATCHED BY TARGET THEN
      INSERT 
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, BUYE_GRP_ID_FK,BUYE_GRP_NM,
      BUYER_GRP_CNT_NR,CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
      VALUES
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, -1,BUYE_GRP_NM,
      BUYER_GRP_CNT_NR,CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
     
    OUTPUT
      INSERTED.[CNT_NR],INSERTED.CNT_EXP_DT_NR, INSERTED.CNT_EXP_DT_NR, INSERTED.[SRC_REC_LST_MOD_DT]
      INTO [CONT].[TEMP_UPDT_CONT_DT];

  END ;
  
     ------------------------------------------------------------------------------------------
     ----   Now expire the older version of the contract and keep only the latest one active
     ----   Insert rows into the EDI 845 
     ------------------------------------------------------------------------------------------

  SELECT @REC_CNT = COUNT(*) 
  FROM [CONT].[TEMP_UPDT_CONT_DT];
  
  IF @REC_CNT > 0
    BEGIN    
      -- Find the latest record of the contract and expire it
      UPDATE C1
        SET REC_STAT_CD = 'I',
        REC_EXP_DT = CONVERT(DATE,LEFT(U.SRC_REC_LST_MOD_DT,4)+'-'+SUBSTRING(LEFT(U.SRC_REC_LST_MOD_DT,8),5,2)+'-'+SUBSTRING(LEFT(U.SRC_REC_LST_MOD_DT,8),7,2))
      FROM 
        CONT.CONTRACT_DEV C1,
        [CONT].[TEMP_UPDT_CONT_DT] U,
        (SELECT CNT_NR, MAX(SRC_REC_LST_MOD_DT) AS [LATEST_DT]
            FROM CONT.CONTRACT_DEV
            WHERE REC_STAT_CD = 'A'
            GROUP BY CNT_NR) C2
      WHERE C1.CNT_NR = U.CNT_NR
        AND C1.CNT_NR = C2.CNT_NR AND C1.SRC_REC_LST_MOD_DT = C2.[LATEST_DT]
     
      -- Find the original expiration date from latest record
      -- CNT_EXP_DT_NR,
      UPDATE U
          SET U.CNT_ORIG_DT_NR = C1.CNT_EXP_DT_NR
      FROM 
      CONT.CONTRACT_DEV C1,
      [CONT].[TEMP_UPDT_CONT_DT] U,
      (SELECT CNT_NR, MAX(SRC_REC_LST_MOD_DT) AS [LATEST_DT]
          FROM CONT.CONTRACT_DEV
          WHERE REC_STAT_CD = 'I'
          GROUP BY CNT_NR) C2
      WHERE C1.CNT_NR = U.CNT_NR
        AND C1.CNT_NR = C2.CNT_NR ;
      
     UPDATE C
      SET REC_STAT_CD = 'A',
         C.ORIG_EXP_DTE = U.CNT_ORIG_DT_NR,
         C.CNT_UPD_TYP = 
            CASE WHEN U.CNT_UPDT_DT_NR > U.CNT_ORIG_DT_NR THEN 'Extend Contract'
                 WHEN U.CNT_UPDT_DT_NR < U.CNT_ORIG_DT_NR THEN 'Expire Contract'
            END
      FROM 
       CONT.CONTRACT_DEV C,
       [CONT].[TEMP_UPDT_CONT_DT] U
      WHERE C.CNT_NR = U.CNT_NR AND C.SRC_REC_LST_MOD_DT = U.SRC_REC_LST_MOD_DT ;
      
    END;

     --------------------------------------------------
     ----    A D D  I T E M
     --------------------------------------------------

    BEGIN
      MERGE CONT.ITEM_DEV T
        USING (
            SELECT DISTINCT
              CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,
              CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,'A' AS REC_STAT_CD, 
              C.Contract_ID_PK AS Contract_ID_FK, I.CNT_NR,
              -1 AS ITM_ID_FK, I.ITM_NR,  
              CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),7,2)) AS ITM_EFF_DT, 
              CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),7,2)) AS ITM_EXP_DT,
              I.ITM_EFF_DT_NR, I.ITM_EXP_DT_NR,
              I.UOM AS ITM_UOM, I.CNT_PRC AS ITM_PRC, 'Item Add' as ITM_STAT_CD,
              I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR , CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
            FROM [STAGE].[CONTRAXX_ITM] I
            JOIN CONT.CONTRACT_DEV C ON C.CNT_NR = I.CNT_NR
            WHERE C.REC_STAT_CD = 'A'
            AND I.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [CONT].[TEMP_NEW_CONT]) -- TO EXCLUDE NEW ITEMS TO NEW CONTRACT
            ) S 
        ON T.CNT_NR = S.CNT_NR AND T.ITM_NR = S.ITM_NR   --AND T.ITM_EXP_DT_NR = S.ITM_EXP_DT_NR  -- IF THE EXP DOES NOT MATCH THEN IT IS A NEW ITEM
          
      WHEN NOT MATCHED BY TARGET THEN -- Insert new item into the item table
          INSERT (  
              REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
              ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, 
              ITM_EXP_DT_NR, ITM_UOM, ITM_PRC,ITM_STAT_CD, SRCE_REC_MOD_DT_NR , [CURRENT TIMESTAMP] )   
          VALUES
          (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
              ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, ITM_EXP_DT_NR, 
              ITM_UOM, ITM_PRC, ITM_STAT_CD, SRCE_REC_MOD_DT_NR , [CURRENT TIMESTAMP])

        OUTPUT
          INSERTED.[CNT_NR], INSERTED.ITM_NR, 
          INSERTED.ITM_EFF_DT_NR, INSERTED.ITM_EXP_DT_NR,
          INSERTED.ITM_UOM,   INSERTED.ITM_PRC, INSERTED.SRCE_REC_MOD_DT_NR
          INTO [CONT].[TEMP_NEW_ITEM_EXIST_CONT];
    END;  
    
       -- UPDATE CONTRACT FOR ITEM ADD    
    
    SET @REC_CNT = 0;      
    SELECT @REC_CNT = COUNT(*) 
    FROM [CONT].[TEMP_NEW_ITEM_EXIST_CONT];
      
    IF @REC_CNT > 0
      BEGIN    
      
      -- In ContraXX there has not been any change to contract, so that rec efp date would be the items modification date
      
      UPDATE C1
        SET REC_STAT_CD = 'I',
        REC_EXP_DT = CONVERT(DATE,LEFT(I.SRCE_REC_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.SRCE_REC_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.SRCE_REC_MOD_DT_NR,8),7,2))
      FROM 
        CONT.CONTRACT_DEV C1,
        [CONT].[TEMP_NEW_ITEM_EXIST_CONT] I,
        (SELECT CNT_NR, MAX(SRC_REC_LST_MOD_DT) AS [LATEST_DT]
            FROM CONT.CONTRACT_DEV
            WHERE REC_STAT_CD = 'A'
            GROUP BY CNT_NR) C2
      WHERE C1.CNT_NR = I.CNT_NR
        AND C1.CNT_NR = C2.CNT_NR AND C1.SRC_REC_LST_MOD_DT = C2.[LATEST_DT]
      
      --- Insert a new row in the Contract Master to record this change
        INSERT INTO CONT.CONTRACT_DEV
          (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
          CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, 
          CNT_TYP_CD, CNT_APPRV_DT, 
          CNT_STAT_CD, BUYE_GRP_ID_FK,BUYE_GRP_NM,
          BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC, CNT_UPD_TYP, SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
        SELECT DISTINCT
          CONVERT(DATE,LEFT(I.SRCE_REC_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.SRCE_REC_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.SRCE_REC_MOD_DT_NR,8),7,2)) AS REC_EFF_DT, 
          CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,
          'A' AS REC_STAT_CD, C.CNT_NR,
          CONVERT(DATE,LEFT(CNT_EFF_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EFF_DT_NR,4),2)+'-'+RIGHT(CNT_EFF_DT_NR,2)) AS CNT_EFF_DT, 
          CONVERT(DATE,LEFT(CNT_EXP_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EXP_DT_NR,4),2)+'-'+RIGHT(CNT_EXP_DT_NR,2)) AS CNT_EXP_DT,
          CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_TYP_CD,
          CONVERT(DATE,LEFT(CNT_APPRV_DT,4)+'-'+LEFT(RIGHT(CNT_APPRV_DT,4),2)+'-'+RIGHT(CNT_APPRV_DT,2)) AS CNT_APPRV_DT,
          'A' AS CNT_STAT_CD, --ISNULL(S.CNT_STATUS,'TBD') AS CNT_STAT_CD, 
          -1 AS BUYE_GRP_ID_FK,
          C.GRP_NM AS BUYE_GRP_NM,
          ISNULL(BUYER_GRP_CNT_NR, C.CNT_NR) AS BUYER_GRP_CNT_NR,
          ISNULL(CNT_TIER_LVL,'SPR') AS CNT_TIER_LVL,
          C.CNT_DESC, 'Item Add' AS CNT_UPD_TYP, 
          I.SRCE_REC_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP
        FROM [STAGE].[CONTRAXX_CNT] C
        JOIN [CONT].[TEMP_NEW_ITEM_EXIST_CONT] I ON C.CNT_NR = I.CNT_NR;

      END  ;
    
    
    --------------------------------------------------
    ----    Item Date change
    --------------------------------------------------

    BEGIN
      MERGE CONT.ITEM_DEV T
        USING (
            SELECT DISTINCT
              CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,
              CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,'A' AS REC_STAT_CD, 
              C.Contract_ID_PK AS Contract_ID_FK, I.CNT_NR,
              -1 AS ITM_ID_FK, I.ITM_NR,  
              CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),7,2)) AS ITM_EFF_DT, 
              CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),7,2)) AS ITM_EXP_DT,
              I.ITM_EFF_DT_NR, I.ITM_EXP_DT_NR,
              I.UOM AS ITM_UOM, I.CNT_PRC AS ITM_PRC,
              I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
            FROM [STAGE].[CONTRAXX_ITM] I
            JOIN CONT.CONTRACT_DEV C ON C.CNT_NR = I.CNT_NR
            WHERE C.REC_STAT_CD = 'A'
            AND I.ITM_NR NOT IN (SELECT DISTINCT ITM_NR FROM [CONT].[TEMP_NEW_ITEM_EXIST_CONT])
            AND I.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [CONT].[TEMP_NEW_CONT]) -- TO EXCLUDE NEW ITEMS TO NEW CONTRACT
            ) S 
        ON T.CNT_NR = S.CNT_NR AND T.ITM_NR = S.ITM_NR AND T.ITM_EXP_DT_NR = S.ITM_EXP_DT_NR  -- IF THE EXP DOES NOT MATCH THEN IT IS A NEW ITEM
          
      WHEN NOT MATCHED BY TARGET THEN -- Insert Updated item into the Item table
          INSERT (  
              REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
              ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, 
              ITM_EXP_DT_NR, ITM_UOM, ITM_PRC, SRCE_REC_MOD_DT_NR,[CURRENT TIMESTAMP]  
              )   
          VALUES
          (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
              ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, ITM_EXP_DT_NR, 
              ITM_UOM, ITM_PRC, SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP] 
              )

        OUTPUT
          INSERTED.[CNT_NR], INSERTED.ITM_NR, 
          INSERTED.ITM_EFF_DT_NR, INSERTED.ITM_EXP_DT_NR,
          INSERTED.ITM_UOM, INSERTED.ITM_PRC, INSERTED.SRCE_REC_MOD_DT_NR, INSERTED.ITM_EXP_DT_NR, 'TBD'
          INTO [CONT].[TEMP_UPD_ITEM];
    END;  
    
    --- Expire older version of the item, contract and insert new contract record
    
    SET @REC_CNT = 0;      
    SELECT @REC_CNT = COUNT(*) 
    FROM [CONT].[TEMP_UPD_ITEM];
      
    IF @REC_CNT > 0
      BEGIN   
        UPDATE I1
          SET REC_STAT_CD = 'I', 
          REC_EXP_DT = CONVERT(DATE,LEFT(U.LATEST_DT,4)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),5,2)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),7,2))
        FROM 
          CONT.ITEM_DEV I1,
          (SELECT CNT_NR, ITM_NR, MAX(SRCE_REC_MOD_DT_NR) AS LATEST_DT
          FROM [CONT].[TEMP_UPD_ITEM]
          GROUP BY CNT_NR, ITM_NR) U
        WHERE I1.CNT_NR = U.CNT_NR AND I1.ITM_NR = U.ITM_NR AND I1.SRCE_REC_MOD_DT_NR < U.LATEST_DT
      
      --Get the latest expiray date for all items with date change  
      -- and save it in the temp table
      UPDATE U SET U.LAST_ITM_EXP_DT_NR = I1.ITM_EXP_DT_NR
      FROM 
      CONT.ITEM_DEV I1,
      [CONT].[TEMP_UPD_ITEM] U,
      (SELECT CNT_NR, ITM_NR, MAX(SRCE_REC_MOD_DT_NR) AS [LATEST_DT]
          FROM CONT.ITEM_DEV
          WHERE REC_STAT_CD = 'I'
          GROUP BY CNT_NR, ITM_NR) I2
      WHERE (I1.CNT_NR = U.CNT_NR AND I1.ITM_NR = U.ITM_NR)
        AND (I1.CNT_NR = I2.CNT_NR AND I1.ITM_NR = I2.ITM_NR)
        AND I1.REC_STAT_CD = 'I' ;
      
      -- now determine if the item is extending or expiring soon
      UPDATE I
      SET I.REC_STAT_CD = 'A',
          I.ITM_STAT_CD =
            CASE 
                 WHEN U.ITM_EXP_DT_NR > U.LAST_ITM_EXP_DT_NR THEN 'Item Extend'
                 WHEN U.ITM_EXP_DT_NR < U.LAST_ITM_EXP_DT_NR THEN 'Item Expire'
            END
      FROM 
       CONT.ITEM_DEV I,
       [CONT].[TEMP_UPD_ITEM] U
      WHERE I.CNT_NR = U.CNT_NR 
        AND I.ITM_NR = U.ITM_NR
        AND I.SRCE_REC_MOD_DT_NR = U.SRCE_REC_MOD_DT_NR ;
      
    -- However if the new date is less than today's date - then it is a delete
    UPDATE I
      SET ITM_STAT_CD = 'Item Delete'
    FROM CONT.ITEM_DEV I
    JOIN [CONT].[TEMP_UPD_ITEM] U ON I.CNT_NR = U.CNT_NR AND I.ITM_NR = U.ITM_NR
    WHERE ITM_EXP_DT <= CONVERT(varchar, getdate(), 1);
    
    UPDATE U
      SET U.ITM_STAT_CD = I.ITM_STAT_CD
    FROM CONT.ITEM_DEV I,
         [CONT].[TEMP_UPD_ITEM] U
      WHERE I.CNT_NR = U.CNT_NR 
        AND I.ITM_NR = U.ITM_NR
        AND I.SRCE_REC_MOD_DT_NR = U.SRCE_REC_MOD_DT_NR ;
        
      --- Insert a new row in the Contract Master to record this change
        INSERT INTO CONT.CONTRACT_DEV
            (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
            CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, 
            CNT_TYP_CD, CNT_APPRV_DT, 
            CNT_STAT_CD, BUYE_GRP_ID_FK,BUYE_GRP_NM,
            BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC, CNT_UPD_TYP, SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP] )
        SELECT DISTINCT
            CONVERT(DATE,LEFT(U.SRCE_REC_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(U.SRCE_REC_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(U.SRCE_REC_MOD_DT_NR,8),7,2)) AS REC_EFF_DT, 
            CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,
            'A' AS REC_STAT_CD, C.CNT_NR,
            CONVERT(DATE,LEFT(CNT_EFF_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EFF_DT_NR,4),2)+'-'+RIGHT(CNT_EFF_DT_NR,2)) AS CNT_EFF_DT, 
            CONVERT(DATE,LEFT(CNT_EXP_DT_NR,4)+'-'+LEFT(RIGHT(CNT_EXP_DT_NR,4),2)+'-'+RIGHT(CNT_EXP_DT_NR,2)) AS CNT_EXP_DT,
            CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_TYP_CD,
            CONVERT(DATE,LEFT(CNT_APPRV_DT,4)+'-'+LEFT(RIGHT(CNT_APPRV_DT,4),2)+'-'+RIGHT(CNT_APPRV_DT,2)) AS CNT_APPRV_DT,
            'A' AS CNT_STAT_CD, --ISNULL(S.CNT_STATUS,'TBD') AS CNT_STAT_CD, 
            -1 AS BUYE_GRP_ID_FK,
            C.GRP_NM AS BUYE_GRP_NM,
            ISNULL(BUYER_GRP_CNT_NR, C.CNT_NR) AS BUYER_GRP_CNT_NR,
            ISNULL(CNT_TIER_LVL,'SPR') AS CNT_TIER_LVL,
            C.CNT_DESC, U.ITM_STAT_CD AS CNT_UPD_TYP, 
            U.SRCE_REC_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP
        FROM [STAGE].[CONTRAXX_CNT] C
        JOIN (SELECT DISTINCT CNT_NR, SRCE_REC_MOD_DT_NR, ITM_STAT_CD FROM [CONT].[TEMP_UPD_ITEM]) U ON C.CNT_NR = U.CNT_NR
        

        -- Expire all but the last contract 
        UPDATE C1
          SET REC_STAT_CD = 'I',
          REC_EXP_DT = CONVERT(DATE,LEFT(U.LATEST_DT,4)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),5,2)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),7,2))
        FROM 
          CONT.CONTRACT_DEV C1,
          (SELECT [CNT_NR], MAX([SRCE_REC_MOD_DT_NR]) AS LATEST_DT 
          FROM [CONT].[TEMP_UPD_ITEM]
          GROUP BY [CNT_NR]) U
        WHERE C1.CNT_NR = U.CNT_NR AND C1.SRC_REC_LST_MOD_DT < U.LATEST_DT 
        
      END 
    
    -- UPDATE STATUS CODES OF CONTRACT AND ITEM
    UPDATE CONT.CONTRACT_DEV
    SET CNT_STAT_CD = 'E'
    WHERE CNT_EXP_DT < CONVERT(varchar, getdate(), 1)
    
    TRUNCATE TABLE CONT.TEMP_NEW_CONT;
    TRUNCATE TABLE CONT.TEMP_NEW_ITEM_EXIST_CONT;
    TRUNCATE TABLE CONT.TEMP_UPD_ITEM;
    TRUNCATE TABLE CONT.TEMP_UPDT_CONT_DT;
    
END