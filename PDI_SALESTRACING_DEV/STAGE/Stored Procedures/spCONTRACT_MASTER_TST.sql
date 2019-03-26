CREATE PROCEDURE [STAGE].[spCONTRACT_MASTER_TST]
WITH EXEC AS CALLER
AS
/*

exec [STAGE].[spCONTRACT_MASTER]

*STEPS
-- new Contract into [STAGE].[TEMP_NEW_CONT]
-- For new contracts  insert ITEMS into [CNT].[CNT_PROD_TST]
-- UPDATE CONTRACT (Contract Date Change - Extend / Expire ) insert into [STAGE].[TEMP_UPDT_CONT_DT]
-- 

*/
BEGIN

  DECLARE @REC_CNT INT, @vINT Int;

  TRUNCATE TABLE [STAGE].[TEMP_NEW_CONT];
  TRUNCATE TABLE [STAGE].[TEMP_UPDT_CONT_DT];
  TRUNCATE TABLE [STAGE].[TEMP_NEW_ITEM_EXIST_CONT];
  TRUNCATE TABLE [STAGE].[TEMP_UPD_ITEM];

  BEGIN
    MERGE [CNT].[CONTRACT_TST] T
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
          C.CNT_DESC, 
          CASE WHEN C.RENEW_CNT_NR IS NOT NULL THEN 'Replace Contract' ELSE 'New Contract' END AS CNT_UPD_TYP,
          C.RENEW_CNT_NR AS RPLCD_CNT_NR,
          C.LAST_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
      FROM [STAGE].[CONTRAXX_CNT] C
      JOIN [STAGE].[CONTRAXX_ITM] I ON C.CNT_NR = I.CNT_NR -- JUST TO MAKE SURE IT HAS ITEMS
      WHERE C.CNT_NR LIKE 'TST%' AND I.CNT_NR LIKE 'TST%'
      ) S ON T.CNT_NR = S.CNT_NR
      
    WHEN NOT MATCHED BY TARGET THEN   -- That means it is a new Contract

      INSERT 
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, BUYER_GRP_ID,BUYER_GRP_NM,
      BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC, CNT_UPD_TYP,RPLCD_CNT_NR, SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP] )
      VALUES
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, -1,BUYE_GRP_NM,
      BUYER_GRP_CNT_NR,  CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,RPLCD_CNT_NR, SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
      
    OUTPUT
      INSERTED.[CNT_NR], INSERTED.[SRC_REC_LST_MOD_DT]
      INTO [STAGE].[TEMP_NEW_CONT];
  
  END ;
  
  
--- update grp-id to be connectd to prch groupUPDATE


UPDATE C SET C.BUYER_GRP_ID = G.PDI_GRP_ID
from [STAGE].[PRCHS_GRP] G
JOIN CNT.[CONTRACT_TST] C ON LTRIM(RTRIM(G.CMS_NM)) = LTRIM(RTRIM(C.BUYER_GRP_NM))
--JOIN STAGE.TEMP_NEW_CONT T ON T.CNT_NR = C.CNT_NR
WHERE C.BUYER_GRP_ID = -1;
  
  
 /******************************************************************
  
  If there was any new contracts then that needs to be inserted into CNT_PROD
  
  ****************************/
    
  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_NEW_CONT];
  
  IF @REC_CNT > 0
    BEGIN
        INSERT INTO [CNT].[CNT_PROD_TST] (  
          REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, Contract_ID_FK, CNT_NR, 
          PROD_ID_FK, PROD_ID, PROD_EFF_DT, PROD_EXP_DT, PROD_EFF_DT_NR, PROD_EXP_DT_NR, 
          PROD_UOM, PROD_PRC, PROD_STAT_CD, 
          SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP] 
          )
        SELECT DISTINCT
          CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,   
          CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,'A' AS REC_STAT_CD, 
          C.Contract_ID_PK AS Contract_ID_FK, C.CNT_NR,
          -1 AS PROD_ID_FK, I.ITM_NR PROD_ID,
          CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+LEFT(RIGHT(I.ITM_EFF_DT_NR,4),2)+'-'+RIGHT(I.ITM_EFF_DT_NR,2)) AS PROD_EFF_DT, 
          CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+LEFT(RIGHT(I.ITM_EXP_DT_NR,4),2)+'-'+RIGHT(I.ITM_EXP_DT_NR,2)) AS PROD_EXP_DT,
          ITM_EFF_DT_NR, ITM_EXP_DT_NR,
          I.UOM AS ITM_UOM, I.CNT_PRC AS PROD_PRC, 'Item Add' AS PROD_STAT_CD ,
          I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
        FROM [STAGE].[CONTRAXX_ITM] I
        JOIN [STAGE].[TEMP_NEW_CONT] N ON N.CNT_NR = I.CNT_NR
        JOIN [CNT].[CONTRACT_TST] C ON C.CNT_NR = N.CNT_NR      
        WHERE C.REC_STAT_CD = 'A'
        AND I.CNT_NR LIKE 'TST%';
        
    END;
    

     --------------------------------------------------
     ----  UPDATE CONTRACT
     ----  Contract Date Change - Extend / Expire 
     --------------------------------------------------

  BEGIN
    MERGE [CNT].[CONTRACT_TST] T
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
          C.GRP_NM AS BUYER_GRP_NM,
          ISNULL(BUYER_GRP_CNT_NR, C.CNT_NR) AS BUYER_GRP_CNT_NR,
          ISNULL(CNT_TIER_LVL,'SPR') AS CNT_TIER_LVL,
          C.CNT_DESC, 'Contract Date Update' AS CNT_UPD_TYP, 
          C.LAST_MOD_DT_NR AS SRC_REC_LST_MOD_DT, CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
      FROM [STAGE].[CONTRAXX_CNT] C
      JOIN [STAGE].[CONTRAXX_ITM] I ON C.CNT_NR = I.CNT_NR  
      WHERE C.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [STAGE].[TEMP_NEW_CONT]) -- JUST TO MAKE SURE it's not new contract
      AND C.CNT_NR LIKE 'TST%' AND I.CNT_NR LIKE 'TST%'
      ) S ON T.CNT_NR = S.CNT_NR AND T.CNT_EXP_DT_NR = S.CNT_EXP_DT_NR
      
    WHEN NOT MATCHED BY TARGET THEN
      INSERT 
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, BUYER_GRP_ID,BUYER_GRP_NM,
      BUYER_GRP_CNT_NR,CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
      VALUES
      (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, CNT_NR, 
      CNT_EFF_DT, CNT_EXP_DT, CNT_EFF_DT_NR, CNT_EXP_DT_NR, CNT_APPRV_DT, 
      CNT_TYP_CD, CNT_STAT_CD, -1,BUYER_GRP_NM,
      BUYER_GRP_CNT_NR,CNT_TIER_LVL, CNT_DESC,CNT_UPD_TYP,SRC_REC_LST_MOD_DT, [CURRENT TIMESTAMP])
     
    OUTPUT
      INSERTED.[CNT_NR],INSERTED.CNT_EXP_DT_NR, INSERTED.CNT_EXP_DT_NR, INSERTED.[SRC_REC_LST_MOD_DT]
      INTO [STAGE].[TEMP_UPDT_CONT_DT];

  END ;
  
     ------------------------------------------------------------------------------------------
     ----   Now expire the older version of the contract and keep only the latest one active
     ----   Insert rows into the EDI 845 
     ------------------------------------------------------------------------------------------

  SELECT @REC_CNT = COUNT(*) 
  FROM [STAGE].[TEMP_UPDT_CONT_DT];
  
  IF @REC_CNT > 0
    BEGIN    
      -- Find the latest record of the contract and expire it
      UPDATE C1
        SET REC_STAT_CD = 'I',
        REC_EXP_DT = CONVERT(DATE,LEFT(U.SRC_REC_LST_MOD_DT,4)+'-'+SUBSTRING(LEFT(U.SRC_REC_LST_MOD_DT,8),5,2)+'-'+SUBSTRING(LEFT(U.SRC_REC_LST_MOD_DT,8),7,2))
      FROM 
        [CNT].[CONTRACT_TST] C1,
        [STAGE].[TEMP_UPDT_CONT_DT] U,
        (SELECT CNT_NR, MAX(SRC_REC_LST_MOD_DT) AS [LATEST_DT]
            FROM [CNT].[CONTRACT_TST]
            WHERE REC_STAT_CD = 'A'
            GROUP BY CNT_NR) C2
      WHERE C1.CNT_NR = U.CNT_NR
        AND C1.CNT_NR = C2.CNT_NR AND C1.SRC_REC_LST_MOD_DT = C2.[LATEST_DT];
     
      -- Find the original expiration date from latest record
      -- CNT_EXP_DT_NR,
      UPDATE U
          SET U.CNT_ORIG_DT_NR = C1.CNT_EXP_DT_NR
      FROM 
      [CNT].[CONTRACT_TST] C1,
      [STAGE].[TEMP_UPDT_CONT_DT] U,
      (SELECT CNT_NR, MAX(SRC_REC_LST_MOD_DT) AS [LATEST_DT]
          FROM [CNT].[CONTRACT_TST]
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
       [CNT].[CONTRACT_TST] C,
       [STAGE].[TEMP_UPDT_CONT_DT] U
      WHERE C.CNT_NR = U.CNT_NR AND C.SRC_REC_LST_MOD_DT = U.SRC_REC_LST_MOD_DT ;
      
    END;

     --------------------------------------------------
     ----    A D D  I T E M
     --------------------------------------------------

    BEGIN
      MERGE [CNT].[CNT_PROD_TST] T
        USING (
            SELECT DISTINCT
              CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,
              CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,'A' AS REC_STAT_CD, 
              C.Contract_ID_PK AS Contract_ID_FK, I.CNT_NR,
              -1 AS ITM_ID_FK, I.ITM_NR PROD_ID,  
              CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),7,2)) AS PROD_EFF_DT, 
              CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),7,2)) AS PROD_EXP_DT,
              I.ITM_EFF_DT_NR PROD_EFF_DT_NR, 
              I.ITM_EXP_DT_NR PROD_EXP_DT_NR,
              I.UOM AS PROD_UOM, I.CNT_PRC AS PROD_PRC, 'Item Add' as PROD_STAT_CD,
              I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR , CURRENT_TIMESTAMP AS [CURRENT TIMESTAMP]
            FROM [STAGE].[CONTRAXX_ITM] I
            JOIN [CNT].[CONTRACT_TST] C ON C.CNT_NR = I.CNT_NR
            WHERE C.REC_STAT_CD = 'A'
            AND I.CNT_NR LIKE 'TST%'
            AND I.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [STAGE].[TEMP_NEW_CONT]) -- TO EXCLUDE NEW ITEMS TO NEW CONTRACT
            ) S 
        ON T.CNT_NR = S.CNT_NR AND T.PROD_ID = S.PROD_ID   --AND T.ITM_EXP_DT_NR = S.ITM_EXP_DT_NR  -- IF THE EXP DOES NOT MATCH THEN IT IS A NEW ITEM
          
      WHEN NOT MATCHED BY TARGET THEN -- Insert new item into the item table
          INSERT (  
            REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, Contract_ID_FK, CNT_NR, 
            PROD_ID_FK, PROD_ID, PROD_EFF_DT, PROD_EXP_DT, PROD_EFF_DT_NR, PROD_EXP_DT_NR, 
            PROD_UOM, PROD_PRC, PROD_STAT_CD, 
            SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP] 
          )   
          VALUES
          (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, PROD_ID, 
              PROD_EFF_DT, PROD_EXP_DT, PROD_EFF_DT_NR, PROD_EXP_DT_NR, 
              PROD_UOM, PROD_PRC, PROD_STAT_CD, SRCE_REC_MOD_DT_NR , [CURRENT TIMESTAMP])

        OUTPUT
          INSERTED.[CNT_NR], INSERTED.PROD_ID, 
          INSERTED.PROD_EFF_DT_NR, INSERTED.PROD_EXP_DT_NR,
          INSERTED.PROD_UOM,   INSERTED.PROD_PRC, INSERTED.SRCE_REC_MOD_DT_NR
          INTO [STAGE].[TEMP_NEW_ITEM_EXIST_CONT];
    END;  
    
   
    --------------------------------------------------
    ----    Item Date change
    --------------------------------------------------

    BEGIN
      MERGE [CNT].[CNT_PROD_TST] T
        USING (
            SELECT DISTINCT
              CONVERT(DATE,LEFT(I.LAST_MOD_DT_NR,4)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.LAST_MOD_DT_NR,8),7,2)) AS REC_EFF_DT,
              CONVERT(DATE, '12-31-9999') AS REC_EXP_DT,
              'P' AS REC_STAT_CD, 
              C.Contract_ID_PK AS Contract_ID_FK, 
              I.CNT_NR,
              -1 AS ITM_ID_FK, I.ITM_NR,  
              CONVERT(DATE,LEFT(I.ITM_EFF_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EFF_DT_NR,8),7,2)) AS ITM_EFF_DT, 
              CONVERT(DATE,LEFT(I.ITM_EXP_DT_NR,4)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),5,2)+'-'+SUBSTRING(LEFT(I.ITM_EXP_DT_NR,8),7,2)) AS ITM_EXP_DT,
              I.ITM_EFF_DT_NR, I.ITM_EXP_DT_NR,
              I.UOM AS ITM_UOM, I.CNT_PRC AS ITM_PRC,
              'PENDING' AS PROD_STAT_CD,
              I.LAST_MOD_DT_NR AS SRCE_REC_MOD_DT_NR, I.[CURRENT TIMESTAMP] AS [CURRENT TIMESTAMP]
            FROM [STAGE].[CONTRAXX_ITM] I
            JOIN [CNT].[CONTRACT_TST] C ON C.CNT_NR = I.CNT_NR
            WHERE C.REC_STAT_CD = 'A'
            AND I.ITM_NR NOT IN (SELECT DISTINCT ITM_NR FROM [STAGE].[TEMP_NEW_ITEM_EXIST_CONT])
            AND I.CNT_NR NOT IN (SELECT DISTINCT CNT_NR FROM [STAGE].[TEMP_NEW_CONT]) -- TO EXCLUDE NEW ITEMS TO NEW CONTRACT
            AND I.CNT_NR LIKE 'TST%'
            ) S 
        ON T.CNT_NR = S.CNT_NR AND T.PROD_ID = S.ITM_NR AND T.PROD_EXP_DT_NR = S.ITM_EXP_DT_NR  -- IF THE EXP DOES NOT MATCH THEN IT IS A NEW ITEM
          
      WHEN NOT MATCHED BY TARGET THEN -- Insert Updated item into the Item table
         INSERT (  
            REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, Contract_ID_FK, CNT_NR, 
            PROD_ID_FK, PROD_ID, PROD_EFF_DT, PROD_EXP_DT, PROD_EFF_DT_NR, PROD_EXP_DT_NR, 
            PROD_UOM, PROD_PRC, PROD_STAT_CD,  
            SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP] 
              )   
          VALUES
          (REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, 
              Contract_ID_FK, CNT_NR, ITM_ID_FK, ITM_NR, 
              ITM_EFF_DT, ITM_EXP_DT, ITM_EFF_DT_NR, ITM_EXP_DT_NR, 
              ITM_UOM, ITM_PRC,PROD_STAT_CD, SRCE_REC_MOD_DT_NR, [CURRENT TIMESTAMP] 
              ) 

        OUTPUT
          INSERTED.[CNT_NR], 
          INSERTED.PROD_ID, 
          INSERTED.PROD_EFF_DT_NR, 
          INSERTED.PROD_EXP_DT_NR,
          INSERTED.PROD_UOM, 
          INSERTED.PROD_PRC, 
          INSERTED.SRCE_REC_MOD_DT_NR, 
          0, --INSERTED.PROD_EXP_DT_NR, 
          'TBD'
          INTO [STAGE].[TEMP_UPD_ITEM];
    END;  
    
    --- Expire older version of the item, contract and insert new contract record
    
    SET @REC_CNT = 0;      
    SELECT @REC_CNT = COUNT(*) 
    FROM [STAGE].[TEMP_UPD_ITEM];
      
    IF @REC_CNT > 0
      BEGIN   
      
      --Get the latest expiray date for all items whihc are active records
      -- and save it in the temp table      
      UPDATE U SET U.LAST_ITM_EXP_DT_NR = I1.PROD_EXP_DT_NR
      FROM 
      [CNT].CNT_PROD_TST I1,
      [STAGE].[TEMP_UPD_ITEM] U,
      (SELECT CNT_NR, PROD_ID, MAX(PROD_EXP_DT_NR) AS [LATEST_DT]
          FROM [CNT].[CNT_PROD_TST]
          WHERE REC_STAT_CD = 'A'
          GROUP BY CNT_NR, PROD_ID) I2
      WHERE (I1.CNT_NR = U.CNT_NR AND I1.PROD_ID = U.ITM_NR)
        AND (I1.CNT_NR = I2.CNT_NR AND I1.PROD_ID = I2.PROD_ID)
        AND I1.REC_STAT_CD = 'A'    ;
      
            -- now determine if the item is extending or expiring soon
      UPDATE [STAGE].[TEMP_UPD_ITEM]
      SET ITM_STAT_CD = 
            CASE 
                 WHEN ITM_EXP_DT_NR > LAST_ITM_EXP_DT_NR THEN 'Item Extend'
                 WHEN ITM_EXP_DT_NR < LAST_ITM_EXP_DT_NR THEN 'Item Expire'
            END;
      
    -- However if the new date is less than today's date - then it is a delete
    UPDATE [STAGE].[TEMP_UPD_ITEM]
      SET ITM_STAT_CD = 'Item Delete'
    WHERE ITM_EXP_DT_NR <= (YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE()));
    
    --SELECT YEAR(GETDATE())*10000+MONTH(GETDATE())*100+DAY(GETDATE())
      -- make all reords which are not pending 'P' inactive
      UPDATE I
        SET REC_STAT_CD = 'I', 
        REC_EXP_DT = CONVERT(DATE,I.[CURRENT TIMESTAMP]) -- CONVERT(DATE,LEFT(U.LATEST_DT,4)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),5,2)+'-'+SUBSTRING(LEFT(U.LATEST_DT,8),7,2))
      FROM 
        [CNT].[CNT_PROD_TST] I,
        (SELECT DISTINCT CNT_NR, ITM_NR FROM [STAGE].[TEMP_UPD_ITEM]) U
      WHERE I.CNT_NR = U.CNT_NR AND I.PROD_ID = U.ITM_NR AND I.REC_STAT_CD <>'P';
      

      -- Make all pending records active with correct stat_cd
      UPDATE I
      SET I.REC_STAT_CD = 'A',
          I.PROD_STAT_CD = U.ITM_STAT_CD
      FROM 
       [CNT].[CNT_PROD_TST] I,
       [STAGE].[TEMP_UPD_ITEM] U
      WHERE I.CNT_NR = U.CNT_NR 
        AND I.PROD_ID = U.ITM_NR
        AND I.REC_STAT_CD = 'P' ;
      

      END 
    
    
  ---- UPDATE STATUS CODES OF CONTRACT AND ITEM
    UPDATE [CNT].[CONTRACT_TST]
    SET CNT_STAT_CD = 'E'
    WHERE CNT_EXP_DT < CONVERT(varchar, getdate(), 1);
    
  --- TIER LEVEL ---  
  UPDATE [CNT].[CONTRACT_TST] SET
  CNT_TIER_LVL_NR = CASE WHEN (CNT_TIER_LVL IS NULL OR STAGE.fnGet_Num(CNT_TIER_LVL) IS NULL) THEN NULL ELSE STAGE.fnGet_Num(CNT_TIER_LVL) END;
  
  UPDATE [CNT].[CONTRACT_TST] SET CNT_TIER_LVL_NR = 1
  WHERE CNT_TIER_LVL IS NULL AND CNT_TYP_CD = 'GPO';
  
END