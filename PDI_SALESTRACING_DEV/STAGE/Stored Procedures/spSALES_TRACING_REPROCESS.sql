CREATE PROCEDURE [STAGE].[spSALES_TRACING_REPROCESS]
@vSales_Period varchar(10), @vDist_Id varchar(48) = null, @vStat char(1) = null, @vErrCD varchar(10) = null
WITH EXEC AS CALLER
AS
BEGIN

-----------------------------------------------------------------
---       This is on is to process records with erro codes    ---
-----------------------------------------------------------------

/*
The approach is to us UPDT columns for all calculatins and keep the original data fields intact.
During loading SLS_CALC_STAT should be turned to 'P' and then the calculation should only be done on 'P'
At the end - all clauclated rows should be turned to 'C' for completion, 'E" for exception
Step 1: correct invalid products and contracts from prior reconciliations saved in corr xref table
Step 2: raise exception, add error codes and SLS_CALC_IN = 'N' for those
Step 3: Determine Price type derived from tracing data
Step 4: Calculate UOM
Step 5: Calculate Case Prices with Contract Sale Validation - 
Step 6: Exception if expired or product not on contract
*/


--BEGIN TRAN
--select  'begin'

-- Add SLS_CALC_STAT = isnull(@vStat,'P') to all calculation segments
-- Add is null to SALES_PERIOD parameter
-- May not need SLS_CALC_IN - will figure that one later

--****************************************************************************
--    INITIALIZE 
--*****************************************************************************
  
  --- EXCLUDE RECORDS WITH ZERO QUANTITY

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [SLS_CALC_STAT] = 'N' 
  WHERE [TRC_QTY_SLD] = 0
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
  -- Special requirement for Florida Hospital
  -- Remove warehouse, because it is interbranch transfer
  UPDATE STAGE.SALES_TRACING_CURR
    SET SLS_CALC_STAT = 'N'
  WHERE DIST_NR ='60652'
    AND SHPTO_NM = 'FLORIDA HOSPITAL WAREHOUSE'
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
  --- Exclude PA's from SAF validation Cardinal & Mckesson, MckessonLTC

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [SLS_CALC_STAT] = 'N'
  WHERE [DIST_NR] IN ('2322211','180225','12580')
  AND [TRC_TRNS_TYP] = 'PA'
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
  -------------
  --- E D I ---
  -------------

  --- update negative price to positive first

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET CTPRC = -1*[CTPRC]
  WHERE [CTPRC] < 0 AND [TRC_QTY_SLD] < 0
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET DIPRC = -1*[DIPRC]
  WHERE [DIPRC] < 0 AND [TRC_QTY_SLD] < 0
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

--- For Owens the qty should be turned into -ve for transaction type PA
--- iF it is not already negative

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_QTY_SLD]  = -1*[TRC_QTY_SLD] 
  WHERE [DIST_NR] = '900068'
  AND [TRC_TRNS_TYP] = 'PA'
  AND [TRC_QTY_SLD] > 0
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);


--- CALCULATE CONT AND LIST PRICE ---- 
-- CARDINAL, CLAFLIN, FIRST CHOICE, HENRYSCHEIN, MCESSONLTC, MOHAWK

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
    [TRC_CNT_PRC] = [CTPRC],
    [TRC_LIST_PRC] = [DIPRC]
  WHERE [DIST_NR] IN ('12580','161072','60522','190633','180225','235165','140690')
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);


/*

-- Calculate / select contract and list price when there is a contract

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] 
  SET [TRC Price Type] = NULL
  WHERE [SALES_PERIOD] = @vSales_Period;

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC Price Type] = 'CONT'
  WHERE LEN([TRC Contract ID]) > 0
  AND [SALES_PERIOD] = @vSales_Period;

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC Price Type] = 'LIST'
  WHERE [TRC Price Type] IS NULL
  AND [SALES_PERIOD] = @vSales_Period;
*/


--- MCKESSON, MOOREMED

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
    [TRC_CNT_PRC] = [CTPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
    [TRC_LIST_PRC] = [CTPRC]
  WHERE [DIST_NR] IN ('232211','133340')
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

--- MIDLAND

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
  [TRC_CNT_PRC] = [CTPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
  [TRC_LIST_PRC] = [CTPRC] 
  WHERE [DIST_NR] = '141431' AND ABS([TRC_RBT_AMT]) > 0 
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] = [DIPRC]
  WHERE [DIST_NR] = '141431' AND ABS([TRC_RBT_AMT]) = 0 
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

  -- SENECA has different calc for list price

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_CNT_PRC] = [CTPRC],
  [TRC_LIST_PRC] = [CTPRC]+[DIPRC]
  WHERE [DIST_NR] = '192022'
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);


  -- OWENS & MINOR
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
  [TRC_CNT_PRC] = [DIPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
  [TRC_LIST_PRC] = [DIPRC] 
  WHERE [DIST_NR] IN ('900068') 
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);;
    
    
  -- GHX HCA

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] = [CTPRC]
  WHERE [DIST_NR] = '900200'
    AND [SLS_CALC_STAT] = isnull(@vStat,'P') 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
      
-- When Invoice date is not provided  

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [INV_DT_IN] = 'T'  --Initialy T = provided in tracing,will be turned to 'D' when not in tracin and derived
  WHERE SLS_CALC_STAT = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [TRC_PRC_TYP] = NULL, [UPD_PRC_TYP] = NULL
  WHERE
    [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
  --- Initialize updated product and contract id
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET UPD_PROD_ID = TRC_PROD_ID 
  WHERE SLS_CALC_STAT = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
  -- Trinity send neithee price nor unit - so by defaukt it is each
  
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [TRC_UNIT] = 'EA', TRC_UPD_UNIT = 'EA'
  WHERE [DIST_ID] = 'TRINITY'
    AND [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
   

--****************************************************************************
--    CORRECT PRODUCT w/ XREF Table
--*****************************************************************************

  UPDATE S
  SET S.UPD_PROD_ID = X.UPD_PROD_ID
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN STAGE.TRC_PROD_CORR_XREF X ON S.TRC_PROD_ID = X.TRC_PROD_ID -- AND S.DIST_NR = X.DIST_NR 
  WHERE SLS_CALC_STAT = isnull(@vStat,'P') 
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
      -----------------------------------------------------------------------------
      --- PRODUCT DOES NOT EXIST
      -----------------------------------------------------------------------------
      
      UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
      SET 
        SLS_CALC_STAT = 'E',                    
        ERR_CD = 'UPI'    -- Unknown Product ID
      WHERE 
        [UPD_PROD_ID] NOT IN
          (SELECT DISTINCT [ITEM NO]
          FROM [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] ) 
        AND [SLS_CALC_STAT] = isnull(@vStat,'P')
        AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
        AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
        
  -----------------------------------------------------------------------------
      --- CONTRACT ID 
  -----------------------------------------------------------------------------

    --  Initialze Contract ID           
    --  If there is a Contract ID, Price Type - CONT
    --  TRC_CNT_ID DOES NOT EXIST - EXCEPTION ---
  
      UPDATE S
      SET 
        UPD_CNT_ID = CASE WHEN C.[CONTRACT_NO] IS NOT NULL THEN TRC_CNT_ID END,
        SLS_CALC_STAT = CASE WHEN C.[CONTRACT_NO] IS NULL THEN 'E' ELSE SLS_CALC_STAT END ,                    
        ERR_CD = CASE WHEN C.[CONTRACT_NO] IS NULL THEN 'UCI' ELSE ERR_CD END,
        RBT_CNT_ID = TRC_CNT_ID,        -- need to keep it separate from TRC
        [TRC_PRC_TYP] = CASE WHEN C.[CONTRACT_NO] IS NOT NULL THEN 'CONT' ELSE [TRC_PRC_TYP] END
      FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
      LEFT JOIN STAGE.DIM_CONTRACT C ON S.[TRC_CNT_ID] = C.CONTRACT_NO
      WHERE LEN([TRC_CNT_ID]) > 0
        AND [SLS_CALC_STAT] = isnull(@vStat,'P')
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
        AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
        

--****************************************************************************
--    CORRECT CONTRACT w/ XREF Table
--*****************************************************************************
  
  UPDATE S
    SET S.UPD_CNT_ID = X.UPD_CNT_ID
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].[STAGE].[TRC_CNT_CORR_XREF] X 
       ON S.TRC_CNT_ID = X.TRC_CNT_ID AND S.UPD_PROD_ID = X.PROD_ID
  --AND S.DIST_NR = X.DIST_NR 
  WHERE 
    SLS_CALC_STAT = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
        
      ------------------------------------------------------------------
      --- CONTRACT EXPIRED - EXCEPTION
      ------------------------------------------------------------------
      UPDATE S
      SET 
        S.[CNT_Exp_DT] = C.[Exp_Date],
        S.[CNT_EXP_DAYS] = DATEDIFF(Day,  C.[Exp_Date],S.INV_DT),
        S.[SLS_CALC_STAT] = 'E',                                   -- TO include exception report
        S.[ERR_CD] = 'EXC'
      FROM 
        [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
        JOIN (SELECT [Contract ID], ITEMID, MAX([Exp Date]) AS [Exp_Date]
              FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE]
              GROUP BY [Contract ID], ITEMID ) C
          ON (S.[UPD_CNT_ID] = C.[Contract ID]
          AND S.[UPD_PROD_ID] = C.[ITEMID]
          AND S.[INV_DT] > DATEADD(m,1,C.[Exp_Date]) ) 
      WHERE 
        S.[TRC_PRC_TYP] = 'CONT'
        AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
        AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
        
      
          
      -----------------------------------------------------------------------------
      ---                 PRODUCT NOT ON CONTRACT - EXCEPTION                   ---
      -----------------------------------------------------------------------------
       /*   
      UPDATE S
      SET  
        S.SLS_CALC_STAT = 'E',                                          
        S.ERR_CD = 'PNC'
      FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
      JOIN [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C ON LTRIM(RTRIM(S.[UPD_PROD_ID])) = LTRIM(RTRIM(C.[Contract ID]))
      WHERE ltrim(rtrim([UPD_PROD_ID]))+'-'+ltrim(rtrim([UPD_PROD_ID])) NOT IN 
          (SELECT DISTINCT ltrim(rtrim([Contract ID]))+'-'+ltrim(rtrim([ITEMID])) FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE])
        AND S.[TRC_PRC_TYP] = 'CONT'
        AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND S.[DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
        AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
        
*/
      UPDATE S
      SET S.ERR_CD = 'PNC',
          S.SLS_CALC_STAT = 'E'
      FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
      LEFT JOIN (
      SELECT DISTINCT ci.[Contract ID], ci.ITEMID
      FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] ci
      JOIN
        (SELECT DISTINCT [UPD_CNT_ID] 
         FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
         WHERE [SLS_CALC_STAT] = isnull(@vStat,'P')
         AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
         AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
         ) ii
        ON ci.[Contract ID] = ii.[UPD_CNT_ID] ) C
    ON S.[UPD_CNT_ID] = C.[Contract ID] AND S.[UPD_PROD_ID] = C.ITEMID
    WHERE S.[TRC_PRC_TYP] = 'CONT'
      AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
      AND C.ITEMID IS NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND S.[DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);  
        
-----------------------------------------------------------------------------
 ---                          SET SOME INITIAL VLAUES                     ---
-----------------------------------------------------------------------------
 
  -- We need to capture List price for every record to calculate rebate
-- Shouldn't we load it with dist price when there is one - because that is the out the door price
  UPDATE S
    SET S.[RBT_LIST_PRC] = L.CS_PRICE
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
--****************************************************************************
--    ASSIGN INV_DT, POPULATE INV_DT_NR
--*****************************************************************************

  -- If INV_DT is null use salesperiod
    UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [INV_DT] =  CONVERT(DATE,LEFT([sales_period],4)+'-'+LEFT(RIGHT([sales_period],4),2)+'-'+RIGHT([sales_period],2))
    ,INV_DT_IN = 'D'  -- Derived
    WHERE [INV_DT] IS NULL
    AND SLS_CALC_STAT = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
    UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET INV_DT_NR = datepart(yyyy,[INV_DT])*10000+datepart(mm,[INV_DT])*100+datepart(dd,[INV_DT])
    WHERE SLS_CALC_STAT = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])  
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

--****************************************************************************
--    STEP 1: OTHER PRICE TYPE
--*****************************************************************************

--  DIST PRICE TYPE
--  if there is not contract, but there is distributor price available - then price type = dist 

  UPDATE S
  SET S.[TRC_PRC_TYP] = 'DIST'
   FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
   JOIN [PDI_SALESTRACING_dev].[STAGE].[DIST_PRICE] D 
      ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
      AND INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE+600)  -- 6 months grace period for shelf life
   WHERE 
   [TRC_PRC_TYP] IS NULL
   AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
   AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
   and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
   AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
   
  -- Everything else is list price
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_PRC_TYP] = 'LIST'
  WHERE [TRC_PRC_TYP] IS NULL
  AND [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

--select  'TRC_PRC_TP is LIST...' , @@ROWCOUNT

---------------------------------------------------------------------
---  STEP 2: CALCULATE ALL TYPES OF PRICES ----
---------------------------------------------------------------------

-- Update TRC_CNT_PRC when [TRC_PRC_TYP] = 'CONT' but TRC_CNT_PRC  is null 
-- Calculate from (1) contract extnded cost, (2) Take the lesser of List and Dist Price (3) LIST OR DIST whatever is available

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_CNT_PRC] =   CASE 
    WHEN [TRC_EXT_CNT_COST] IS NOT NULL THEN [TRC_EXT_CNT_COST] / [TRC_QTY_SLD] 
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_LIST_PRC] IS NOT NULL THEN IIF ([TRC_DIST_PRC]<[TRC_LIST_PRC], [TRC_DIST_PRC], [TRC_LIST_PRC])
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_LIST_PRC] IS NULL THEN [TRC_DIST_PRC] 
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_DIST_PRC] IS NULL THEN [TRC_LIST_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'CONT' 
  AND [TRC_CNT_PRC] is NULL
  AND [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

-- Update when [TRC_PRC_TYP] = 'DIST' but TRC_DIST_PRC  is null 
-- Take the extended cost/qty or lesser of List and Cont Price

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_DIST_PRC] =   CASE 
    WHEN [TRC_EXT_LIST_COST] IS NOT NULL THEN [TRC_EXT_LIST_COST] / [TRC_QTY_SLD]
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NOT NULL THEN IIF ([TRC_CNT_PRC]<[TRC_LIST_PRC], [TRC_CNT_PRC], [TRC_LIST_PRC])
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NULL THEN [TRC_LIST_PRC] 
    WHEN [TRC_LIST_PRC] IS NULL AND [TRC_CNT_PRC] IS NOT NULL THEN [TRC_CNT_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'DIST' 
  AND [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [TRC_DIST_PRC] is NULL
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

-- Update when [TRC_PRC_TYP] = 'LIST' but TRC_LIST_PRC  is null 
-- extended Cost / Qry - Take the lesser of List and Cont Price

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] =   CASE 
    WHEN [TRC_EXT_LIST_COST] IS NOT NULL THEN [TRC_EXT_LIST_COST] / [TRC_QTY_SLD]
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NOT NULL THEN IIF ([TRC_CNT_PRC]>[TRC_DIST_PRC], [TRC_CNT_PRC], [TRC_DIST_PRC])
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NULL THEN [TRC_DIST_PRC] 
    WHEN [TRC_DIST_PRC] IS NULL AND [TRC_CNT_PRC] IS NOT NULL THEN [TRC_CNT_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'LIST' 
  AND [TRC_LIST_PRC] is NULL
  AND [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

--select  'TRC_CNT_PRC is updated with TRC_DIST_PRC ...' , @@ROWCOUNT 

-- Calculate prices when there is no price but there is extended cost provided

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [TRC_CNT_PRC] = [TRC_EXT_LIST_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'CONT' 
    AND [TRC_EXT_LIST_COST] IS NOT NULL
    AND [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_DIST_PRC] = [TRC_EXT_CNT_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'DIST'
    AND [TRC_EXT_CNT_COST] IS NOT NULL
    AND [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);    

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [TRC_LIST_PRC] = [TRC_EXT_CNT_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'LIST'
    AND [TRC_EXT_CNT_COST] IS NOT NULL 
    AND [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
------------------------------------------------------------------------------
--  STEP 3: :  Calculate UOM
------------------------------------------------------------------------------

-- INITIALIZE --

UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_UPD_UNIT] = NULL
  WHERE 
  [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
  --------------------------------------------------------------------------------------------------
  --- 3.1 For 'CONT' Price Type -- Will try out all 3 type of prices - in the order of CNT, DIST, LIST
  ---------------------------------------------------------------------------------------------------
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.CS_PRICE) AND (1.4*CNT.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.BX_PRICE) AND (1.4*CNT.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.EA_PRICE) AND (1.4*CNT.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
      JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
      --AND S.[INV_DT] BETWEEN CNT.[Eff Date] AND DATEADD(m,1,CNT.[Exp Date])  -- Date validation will be later
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
  -- TRY DIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.CS_PRICE) AND (1.4*D.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.BX_PRICE) AND (1.4*D.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.EA_PRICE) AND (1.4*D.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_dev].[STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND D.EXPDATE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[TRC_DIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
    
  -- TRY LIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[TRC_LIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
    
--------------------------------------------------------------------------------------------------
  --- 3.2 For 'DIST' Price Type -- Will try out all 3 type of prices - in the order of DIST, CNT, LIST
  ---------------------------------------------------------------------------------------------------
  
  -- TRY DIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.CS_PRICE) AND (1.4*D.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.BX_PRICE) AND (1.4*D.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.EA_PRICE) AND (1.4*D.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_dev].[STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE + 600)  -- OUT THE DOOR PRICE, SO GIVING 6 MONTHS SHELF LIFE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'DIST'
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
  
  -- Try CONT Price
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.CS_PRICE) AND (1.4*CNT.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.BX_PRICE) AND (1.4*CNT.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.EA_PRICE) AND (1.4*CNT.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
      JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
  WHERE 
    [TRC_UPD_UNIT] IS NULL
    AND [TRC_PRC_TYP] = 'DIST'
    AND S.[TRC_CNT_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
 
  -- TRY LIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'DIST'
    AND S.[TRC_LIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 

--------------------------------------------------------------------------------------------------
  --- 3.3 For 'LIST' Price Type -- Will try out all 3 type of prices - in the order of LIST, DIST, CNT
  ---------------------------------------------------------------------------------------------------
  -- TRY LIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 

  -- TRY DIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.CS_PRICE) AND (1.4*D.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.BX_PRICE) AND (1.4*D.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.EA_PRICE) AND (1.4*D.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_dev].[STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND D.EXPDATE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[TRC_DIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 


  -- Try CONT Price
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.CS_PRICE) AND (1.4*CNT.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.BX_PRICE) AND (1.4*CNT.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.EA_PRICE) AND (1.4*CNT.EA_PRICE) THEN 'EA'
    END
  FROM
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
      JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[TRC_CNT_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
    
--------------------------------------------------------------------------------------------------
  --- 3.4 Remaining from the correction file
  ---------------------------------------------------------------------------------------------------
  
  UPDATE S
  SET S.TRC_UPD_UNIT = X.UPD_UOM
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN PDI_SALESTRACING_DEV.STAGE.TRC_UOM_CORR_XREF X ON S.DIST_NR = X.DIST_NR AND S.TRC_UNIT = X.TRC_UOM
  WHERE 
  [TRC_UPD_UNIT] IS NULL
  AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
  AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);  
  
  --- FOR THE REST RAISE A FLAG
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] 
  SET ERR_CD = 'UOM Could not be calculated',
  [SLS_CALC_STAT] = 'E'
  WHERE
  [TRC_UPD_UNIT] IS NULL
  AND [SLS_CALC_STAT] = isnull(@vStat,'P')
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  
-----------------------------------------------------------------------------------------------------
---Remove or comment out later
/*
 if @debug = 1
			select trc_prod_id,trc_cnt_id,trc_prc_typ,inv_id,inv_dt,trc_unit,trc_qty_sld
			,trc_cnt_prc,trc_list_prc,trc_dist_prc,trc_cs_prc,trc_UPD_unit,trc_sales_amt,list_cs_prc
			from [STAGE].[SALES_TRACING_CURR] S
			where S.SALES_Period = @vSales_Period  
			and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]) 
*/

-- if TRC_UPD_UNIT is not updated still use what came in
--------------------------------------------------------------------
--- SHOULD WE REMOVE This One
-------------------------------------------------------------------
 --- The last few remaining
 /*
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET [TRC_UPD_UNIT] =
    CASE
    WHEN [TRC_UNIT] IN ('BX','EA','CS') THEN [TRC_UNIT]
    WHEN [TRC_UNIT] IN ('TU','TB','BG','PK','PH') THEN 'BX'
    WHEN [TRC_UNIT] = 'CA' THEN 'CS'
    END
  WHERE [TRC_UPD_UNIT] IS NULL
  AND [SLS_CALC_STAT] = 'E'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND ERR_CD = 'UOM Could not be calculated'
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); */

  ------------------------------------------------------------------
  --- Calculate the case quantity
  ------------------------------------------------------------------
    
  UPDATE S
   SET  [UPD_CS_QTY]  = CASE
        WHEN S.[TRC_UPD_UNIT] = 'CS' THEN S.[TRC_QTY_SLD]
        WHEN S.[TRC_UPD_UNIT] = 'BX' THEN S.[TRC_QTY_SLD]/L.[BX]
        WHEN S.[TRC_UPD_UNIT] = 'EA' THEN S.[TRC_QTY_SLD]/L.[EA]
        END
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].[STAGE].[LIST_PRICE] L ON [UPD_PROD_ID] = L.[ITEM NO] 
  WHERE S.[TRC_UPD_UNIT] IS NOT NULL
  AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
  AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
  AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

  ------------------------------------------------------------------
  --- Get CNT Price first. But before initialize
  ------------------------------------------------------------------
    
    UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
    SET [UPD_CS_PRC] =  NULL, [UPD_PRC_TYP] = NULL
    WHERE [SLS_CALC_STAT] = isnull(@vStat,'P')
    ;
    
    UPDATE S
    SET 
      S.[CNT_EXP_DT] = C.[Exp Date],
      S.[UPD_CS_PRC] =  C.[Contract Price],
      S.[UPD_PRC_TYP] = 'CONT',
      S.[CNT_EXP_DAYS] = DATEDIFF(Day,  C.[Exp Date],S.INV_DT)
    FROM 
      [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
      JOIN [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
          ON (S.[UPD_CNT_ID] = C.[Contract ID]             -- CNT_ID Ccorrected by corr xref table
          AND S.[UPD_PROD_ID] = C.[ITEMID]
          AND S.[INV_DT] BETWEEN C.[Eff Date] AND DATEADD(m,1,C.[Exp Date]) ) 
    WHERE 
      S.[TRC_PRC_TYP] = 'CONT'
      AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
      
  ------------------------------------------------------------------
  --- Then Get Dist Case Price
  ------------------------------------------------------------------

    UPDATE S
    SET 
      S.[UPD_CS_PRC] =  D.[CS_PRICE],
      S.[UPD_PRC_TYP] = 'DIST'
    FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
         JOIN [PDI_SALESTRACING_dev].[STAGE].[DIST_PRICE] D 
          ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
          AND INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE+600)  -- 6 months grace period for shelf life
    WHERE 
      S.[UPD_PRC_TYP] IS NULL
      AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
      
  ------------------------------------------------------------------
  --- Remaining is List Price
  ------------------------------------------------------------------
      
  UPDATE S
    SET 
      S.[UPD_CS_PRC] =  L.[CS_PRICE],
      S.[UPD_PRC_TYP] = 'LIST'
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].STAGE.List_Price L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE
    S.[UPD_PRC_TYP] IS NULL
    AND S.[SLS_CALC_STAT] = isnull(@vStat,'P')
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
	  AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

---------------------------------------------------------------------
-----   SALES AMOUNT CALCULATION --- 
---------------------------------------------------------------------

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
    [UPD_SALES_AMT] = [UPD_CS_QTY] * [UPD_CS_PRC],
    [SLS_CALC_STAT] = 'C'
  WHERE
    [SLS_CALC_STAT] = isnull(@vStat,'P')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);


---------------------------------------------------------------------
---         R E B A T E   C A L C U L A T I O N                    ---
---------------------------------------------------------------------

  --- R E S E T ------
  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
    [RBT_STAT_CD] = NULL, 
    [UPD_RBT_AMT] = 0
  WHERE [RBT_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  

--- FILE CAME 45 DAYS AFTER INV_DT --

  UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
  SET 
    [RBT_STAT_CD] = 'LS',
    [UPD_RBT_AMT] = 0,
    [RBT_CALC_STAT] = 'E'
  WHERE 
    CONVERT(DATE,[YEAR]+'-'+[MNTH]+'-'+[DAY]) > DATEADD(DAY,47,[INV_DT])  
    AND [RBT_CALC_STAT]  = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
  -- assuming we loaded it right away -- This is manual - so needs to allow extra time?

  ------------------------------
  -- CORRECTION TO CNT NUMBER --
  ------------------------------
  
  -- Will only fix GPO Contract number to PDI contract number
  
  UPDATE S
    SET S.[RBT_CNT_ID] = X.UPD_CNT_ID
  FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
  JOIN [PDI_SALESTRACING_DEV].[STAGE].[TRC_CNT_CORR_XREF] X 
       ON S.TRC_CNT_ID = X.TRC_CNT_ID 
       AND S.UPD_PROD_ID = CASE WHEN X.PROD_ID = 'ALL' THEN S.UPD_PROD_ID ELSE X.PROD_ID END
       AND X.TRC_CNT_TYP = 'GPO'       
  WHERE 
    S.[RBT_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
  
  ------------------------------
  ---     VALID CONTRACT      -- 
  ------------------------------
  UPDATE S
  SET 
    [RBT_STAT_CD] = 'VC',
    [CNT_EXP_DT] = C.[Exp Date],
    [UPD_RBT_AMT] = ([RBT_LIST_PRC] - C.[Contract Price])*[TRC_QTY_SLD],
    RBT_CALC_STAT = 'C'
  FROM 
    [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    JOIN [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
 
        ON (S.[RBT_CNT_ID] = C.[Contract ID]
        AND S.[UPD_PROD_ID] = C.[ITEMID]
        AND S.[INV_DT] BETWEEN C.[Eff Date] AND DATEADD(m,1,C.[Exp Date]) ) 
  WHERE 
    RBT_CALC_STAT = 'P'
    AND LEN(S.RBT_CNT_ID) > 0
--    AND s.[RBT_STAT_CD] IS NULL
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);
        
  ------------------------------------------------------------------
  --- CONTRACT EXPIRED - EXCEPTION
  ------------------------------------------------------------------
  
    UPDATE S
    SET 
      [RBT_STAT_CD] = 'EC',    -- Expired Contract
      [CNT_EXP_DT] = C.[Exp Date],
      [UPD_RBT_AMT] = 0,
      [RBT_CALC_STAT] = 'E'
    FROM [PDI_SALESTRACING_DEV].STAGE.SALES_TRACING_CURR S
    JOIN (SELECT [Contract ID], ITEMID, MAX([Exp Date]) AS [Exp Date]
          FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE]
          GROUP BY [Contract ID], ITEMID ) C
        ON (S.[RBT_CNT_ID] = C.[Contract ID]
        AND S.[UPD_PROD_ID] = C.ITEMID
        AND S.[INV_DT] > DATEADD(m,1,C.[Exp Date]))
    WHERE  
      S.[RBT_CALC_STAT] = 'P'
      AND S.[RBT_STAT_CD] = NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 

  --------------------------------------------------
  --- CONTRACT DOES NOT EXIST - EXCEPTION ---
  --------------------------------------------------
      /*
      UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
      SET 
        [RBT_STAT_CD] = 'IC',  -- Invalid Contract
        [UPD_RBT_AMT] = 0,
        [RBT_CALC_STAT] = 'E'
      WHERE 
        [RBT_CNT_ID] NOT IN
        (SELECT DISTINCT C.CONTRACT_NO FROM STAGE.DIM_CONTRACT C WHERE S.[INV_DT] <= DATEADD(m,1,C.[Exp Date])) 
        AND S.[RBT_CALC_STAT] = 'P'
        AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
        AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); */
        
     --- INVALID CONTRACT ID

    UPDATE S
    SET 
        [RBT_STAT_CD] = 'IC',  -- Invalid Contract ID
        [UPD_RBT_AMT] = 0,
        [RBT_CALC_STAT] = 'E'
    FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    LEFT JOIN [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] C
        ON S.[RBT_CNT_ID] = C.[Contract ID]
    WHERE S.[RBT_CALC_STAT] = 'P'
      AND C.[Contract ID] IS NULL
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
        
        
  -----------------------------------------------------------------------------
  ---                 PRODUCT NOT ON CONTRACT - EXCEPTION                   ---
  -----------------------------------------------------------------------------
  -- First find a data set of contract and item from contract PRICE tabl
  
    UPDATE S
      SET RBT_STAT_CD = 'IP',  -- Invalid Product
      [UPD_RBT_AMT] = 0,
      [RBT_CALC_STAT] = 'E'
    FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR] S
    LEFT JOIN (
      SELECT DISTINCT ci.[Contract ID], ci.ITEMID
      FROM [PDI_SALESTRACING_DEV].[STAGE].[CONT_PRICE] ci
      JOIN
        (SELECT DISTINCT [RBT_CNT_ID] 
         FROM [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
         WHERE [RBT_CALC_STAT] = 'P') ii
        ON ci.[Contract ID] = ii.[RBT_CNT_ID] ) C
    ON S.[RBT_CNT_ID] = C.[Contract ID] AND S.[UPD_PROD_ID] = C.ITEMID
    WHERE S.[RBT_CALC_STAT] = 'P'
      AND C.ITEMID IS NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 

    --- WRONG CALCULATION

    UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
      SET RBT_STAT_CD = 'WC'                                        -- WRONG CALCULATION
    WHERE ([TRC_RBT_AMT] - [UPD_RBT_AMT]) > 0.14
      AND [RBT_STAT_CD] = 'VC'
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]); 
    
    
    UPDATE [PDI_SALESTRACING_DEV].[STAGE].[SALES_TRACING_CURR]
      SET RBT_STAT_CD = 'IV'                                        -- Insignificant Variance
    WHERE ([TRC_RBT_AMT] - [UPD_RBT_AMT]) < 0.15
      AND [RBT_STAT_CD] = 'VC'
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) 
      AND [ERR_CD] = ISNULL(@vErrCD,[ERR_CD]);

END