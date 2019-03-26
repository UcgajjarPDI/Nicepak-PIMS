CREATE PROCEDURE [STAGE].[spSALES_TRACING_PROCESS]
@vSales_Period varchar(10), @vDist_Id varchar(48) = null
WITH EXEC AS CALLER
AS
BEGIN

-----------------------------------------------------------------
---       This one is to combine both EDI AND NONEDI data     ---
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

----    SLS_CALC_STAT    ---
  'P' = Pending - all new records, whihc requries calculation
  'N' = Not Applicable -- transactions for which no calculations are to be done, such as IB or zero quantity etc
  'E' = Exclude - for unknown product or undetermined UOM
  'C' = Complete - calculations are complete
  
  However, all records with an error code will always be pending calculations and should remain in 'P' status 
*/


--BEGIN TRAN
--select  'begin'

-- Add SLS_CALC_STAT = 'P' to all calculation segments
-- Add is null to SALES_PERIOD parameter
-- May not need SLS_CALC_IN - will figure that one later

--****************************************************************************
--    INITIALIZE 
--*****************************************************************************
  
  --- EXCLUDE RECORDS WITH ZERO QUANTITY

  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [SLS_CALC_STAT] = 'N' 
  WHERE [TRC_QTY_SLD] = 0
    AND [SLS_CALC_STAT] = 'P' 
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  
  -- Special requirement for Florida Hospital
  -- Remove warehouse, because it is interbranch transfer
  UPDATE STAGE.SALES_TRACING_CURR
    SET SLS_CALC_STAT = 'N'
  WHERE DIST_NR ='60652'
    AND SHPTO_NM = 'FLORIDA HOSPITAL WAREHOUSE'
    AND [SLS_CALC_STAT] = 'P' 
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD]);
  
  -- Dental Distributor from NDC should be out
  UPDATE STAGE.SALES_TRACING_CURR SET 
    SLS_CALC_STAT = 'N'
  WHERE DIST_ID = 'NDC' 
    AND (BILLTO_ID = '800144' OR BILLTO_NM LIKE 'DENTAL DISTRIBUTORS%');
    
  ------------------------------
 -- Flag zero or -ve quantity --
 -------------------------------
   
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET TRC_TRNS_TYP = CASE 
          WHEN TRC_QTY_SLD < 0  THEN 'RP' 
          WHEN TRC_QTY_SLD = 0  THEN 'ZQ'
          ELSE 'SS' END
  WHERE TRC_TRNS_TYP IS NULL 
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
        AND SRC_FILE_TYP = 'BLK' ; -- may need to do for both edi and blk
    
 -----------------------------------------------------------------------------------
 -- Other Specific Business Rules - which also should be done through exception table
 ----------------------------------------------------------------------------------
   -- For PALMTREE following are to be excluded --
   
 UPDATE [STAGE].[SALES_TRACING_CURR]
  SET TRC_TRNS_TYP ='DD'
 WHERE DIST_NR = '150258'
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND (SHPTO_NM IN
    ('APN HEALTHCARE INC.','BIO-MEDIC HEALTH SERVICES INC.','GERICARE MEDICAL SUPPLY',
     'MANHEIM MEDICAL SUPPLY INC.','MEDFIRST HEALTHCARE SUPPLY INC.','MIDLAND MEDICAL',
     'RESOURCE SERVICES')
     OR BILLTO_NM IN
     ('APN HEALTHCARE INC.','BIO-MEDIC HEALTH SERVICES INC.','GERICARE MEDICAL SUPPLY',
     'MANHEIM MEDICAL SUPPLY INC.','MEDFIRST HEALTHCARE SUPPLY INC.','MIDLAND MEDICAL',
     'RESOURCE SERVICES') );

  -- NDC, MEDPLUS --
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET TRC_TRNS_TYP ='DD'
  WHERE DIST_NR IN ('132550','C00102')
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND BILLTO_ID IN
    ('100009','100010','100017','100051','110005','110068','500104','710293','720254','720217');

  -- MEDLINE DYNACOR --
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET TRC_TRNS_TYP = 'IB'
  WHERE DIST_NR = '131065'
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND SHPTO_ID = ('0001393208') ;
  
    -- MEDLINE DYNACOR --
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET TRC_TRNS_TYP = 'IB'
  WHERE DIST_NR = '131065' -- IN ('131043','131065','131045','131060','131067')
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND SHPTO_NM LIKE '%STONE MEDICAL%' ;
  
    -- FLORIDA HOSPITAL --
  
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET TRC_TRNS_TYP = 'IB'
  WHERE DIST_NR = '60652'
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND SHPTO_ADDR_1 LIKE '2135 Sprint%' ;
    
  --- CHURCH --
  -- Church does not provide any price information - so eaches will be converted to EA
  
      UPDATE [STAGE].[SALES_TRACING_CURR]
      SET [TRC_UNIT] =
        CASE
          WHEN UPPER([TRC_UNIT])IN ('BX','EA','CS') THEN [TRC_UNIT]
          WHEN UPPER([TRC_UNIT]) IN ('TU','TB','BG','PK','PH', 'BOX', 'BOXES','CN') THEN 'BX'
          WHEN UPPER([TRC_UNIT]) = 'CA' THEN 'CS'
          WHEN UPPER([TRC_UNIT]) LIKE 'EA%' THEN 'EA'
        END
      WHERE DIST_NR = '32040'
      AND [SLS_CALC_STAT] IN ('P','E')
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD]);


      
  -- MEDLINE CRITICAL CARE --
  
  
      -- Place Holder --
  --- Final ---
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [SLS_CALC_STAT] = 'N'
  WHERE TRC_TRNS_TYP IN ('IB','ZQ','DD')
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);


 
  
  
  -------------
  --- E D I ---
  -------------

  --- Exclude PA's from SAF validation Cardinal & Mckesson, MckessonLTC

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [SLS_CALC_STAT] = 'N'
  WHERE [DIST_NR] IN ('2322211','180225','12580')
  AND [TRC_TRNS_TYP] = 'PA'
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
    
  --- update negative price to positive first

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET CTPRC = -1*[CTPRC]
  WHERE [CTPRC] < 0 AND [TRC_QTY_SLD] < 0
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET DIPRC = -1*[DIPRC]
  WHERE [DIPRC] < 0 AND [TRC_QTY_SLD] < 0
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

--- For Owens the qty should be turned into -ve for transaction type PA
--- iF it is not already negative

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_QTY_SLD]  = -1*[TRC_QTY_SLD] 
  WHERE [DIST_NR] = '900068'
  AND [TRC_TRNS_TYP] = 'PA'
  AND [TRC_QTY_SLD] > 0
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);


--- CALCULATE CONT AND LIST PRICE ---- 
-- CARDINAL, CLAFLIN, FIRST CHOICE, HENRYSCHEIN, MCESSONLTC, MOHAWK

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
    [TRC_CNT_PRC] = [CTPRC],
    [TRC_LIST_PRC] = [DIPRC]
  WHERE [DIST_NR] IN ('12580','161072','60522','190633','180225','235165','140690')
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);


/*

-- Calculate / select contract and list price when there is a contract

  UPDATE [STAGE].[SALES_TRACING_CURR] 
  SET [TRC Price Type] = NULL
  WHERE [SALES_PERIOD] = @vSales_Period;

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC Price Type] = 'CONT'
  WHERE LEN([TRC Contract ID]) > 0
  AND [SALES_PERIOD] = @vSales_Period;

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC Price Type] = 'LIST'
  WHERE [TRC Price Type] IS NULL
  AND [SALES_PERIOD] = @vSales_Period;
*/


--- MCKESSON, MOOREMED

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
    [TRC_CNT_PRC] = [CTPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
    [TRC_LIST_PRC] = [CTPRC]
  WHERE [DIST_NR] IN ('232211','133340')
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

--- MIDLAND

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
  [TRC_CNT_PRC] = [CTPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
  [TRC_LIST_PRC] = [CTPRC] 
  WHERE [DIST_NR] = '141431' AND ABS([TRC_RBT_AMT]) > 0 
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] = [DIPRC]
  WHERE [DIST_NR] = '141431' AND ABS([TRC_RBT_AMT]) = 0 
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

  -- SENECA has different calc for list price

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_CNT_PRC] = [CTPRC],
  [TRC_LIST_PRC] = [CTPRC]+[DIPRC]
  WHERE [DIST_NR] = '192022'
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);


  -- OWENS & MINOR
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
  [TRC_CNT_PRC] = [DIPRC] - ([TRC_RBT_AMT]/ ABS([TRC_QTY_SLD])),
  [TRC_LIST_PRC] = [DIPRC] 
  WHERE [DIST_NR] IN ('900068') 
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
    
    
  -- GHX HCA

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] = [CTPRC]
  WHERE [DIST_NR] = '900200'
    AND [SLS_CALC_STAT] = 'P' 
    AND [SRC_FILE_TYP] = 'EDI'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
      
-- When Invoice date is not provided  

  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [INV_DT_IN] = 'T'  --Initialy T = provided in tracing,will be turned to 'D' when not in tracin and derived
  WHERE SLS_CALC_STAT = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
    
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [TRC_PRC_TYP] = NULL, [UPD_PRC_TYP] = NULL
  WHERE
    [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  
  --- Initialize updated product and contract id
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET UPD_PROD_ID = TRC_PROD_ID 
  WHERE SLS_CALC_STAT = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  
  -- Trinity send neithee price nor unit - so by defaukt it is each
  
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [TRC_UNIT] = 'EA', TRC_UPD_UNIT = 'EA'
  WHERE [DIST_ID] = 'TRINITY'
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
 
 


--****************************************************************************
--    CORRECT PRODUCT w/ XREF Table
--*****************************************************************************

  UPDATE S
  SET S.UPD_PROD_ID = X.UPD_PROD_ID
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN STAGE.TRC_PROD_CORR_XREF X ON S.TRC_PROD_ID = X.TRC_PROD_ID -- AND S.DIST_NR = X.DIST_NR 
  WHERE SLS_CALC_STAT = 'P' 
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
    
      -----------------------------------------------------------------------------
      --- PRODUCT DOES NOT EXIST
      -----------------------------------------------------------------------------
      
      UPDATE [STAGE].[SALES_TRACING_CURR]
      SET 
        SLS_CALC_STAT = 'E',                    
        ERR_CD = 'UPI',    -- Unknown Product ID
        UPD_PROD_ID = NULL  -- Turn the updatec product ID back to null if it is not a valid product
      WHERE 
        [UPD_PROD_ID] NOT IN
          (SELECT DISTINCT [ITEM NO]
          FROM [STAGE].[LIST_PRICE] ) 
        AND [SLS_CALC_STAT] = 'P'
        AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ; 
        
  -----------------------------------------------------------------------------
      ---           CONTRACT ID  -----
  -----------------------------------------------------------------------------

    -- REMOVE KNOWN ISSUE WITH CONTRACT IDs
    
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET TRC_CNT_ID = NULL
    WHERE UPPER(TRC_CNT_ID) LIKE '%TRACING%'                 -- Currently an issue with Medline
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);    

    
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [RBT_CNT_ID] = [TRC_CNT_ID]  ,            -- need to keep it separate from sales calculation
        [UPD_CNT_ID] = NULL
    WHERE LEN([TRC_CNT_ID]) > 0
        AND [SLS_CALC_STAT] = 'P'
        AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
        
  --  Initialze Contract ID  
  --  If there is a valid Contract ID, Price Type - CONT
  
      UPDATE S
      SET 
        [UPD_CNT_ID] = [TRC_CNT_ID],
        [TRC_PRC_TYP] = 'CONT'
      FROM [STAGE].[SALES_TRACING_CURR] S
      JOIN CNT.[CONTRACT] C ON S.[TRC_CNT_ID] = C.CNT_NR
      WHERE LEN([TRC_CNT_ID]) > 0
      --  AND C.[CONTRACT_NO] IS NOT NULL
        AND [SLS_CALC_STAT] = 'P'
        AND C.REC_STAT_CD = 'A'
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,S.[SALES_PERIOD])
        and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
         ;
        
   --****************************************************************************
--    CORRECT CONTRACT w/ XREF Table
--*****************************************************************************
  -- Correct remaining ones by matching contract and product
  
  -- if there are extra characters before or after contract number
  UPDATE S
    SET S.UPD_CNT_ID = C.CNT_NR 
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN CNT.[CONTRACT] C ON S.TRC_CNT_ID LIKE '%'+C.CNT_NR+'%' --C.CNT_NR LIKE LEFT(LTRIM(RTRIM(S.TRC_CNT_ID)),7)  -- SOMEDAY WEMAY HAVE MORE THAN 7 DIGIT
  WHERE 
    LEN(S.[TRC_CNT_ID]) > 0
    AND S.[UPD_CNT_ID] IS NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND C.[REC_STAT_CD] = 'A'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
  
  /*-- When there is additional charachters in front of contract number like PDI-CNT2468
  UPDATE S
    SET S.UPD_CNT_ID = C.CNT_NR 
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN CNT.[CONTRACT] C ON C.CNT_NR = RIGHT(LTRIM(RTRIM(S.TRC_CNT_ID)),7)
  WHERE 
    LEN(S.[TRC_CNT_ID]) > 0
    AND S.[UPD_CNT_ID] IS NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND C.[REC_STAT_CD] = 'A'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]); */
  
  -- Now use the cross reference fil
  UPDATE S
    SET S.UPD_CNT_ID = X.UPD_CNT_ID
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN [STAGE].[TRC_CNT_CORR_XREF] X 
       ON S.TRC_CNT_ID = X.TRC_CNT_ID --AND S.UPD_PROD_ID = X.PROD_ID
  WHERE
    LEN(S.[TRC_CNT_ID]) > 0
    AND S.[UPD_CNT_ID] IS NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
        
  --  TRC_CNT_ID DOES NOT EXIST - EXCEPTION ---
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [ERR_CD] = 'UCI'
    WHERE
      LEN([TRC_CNT_ID]) > 0
      AND [UPD_CNT_ID] IS NULL
      AND [SLS_CALC_STAT] = 'P'
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
            
      ------------------------------------------------------------------
      --- CONTRACT EXPIRED - EXCEPTION
      ------------------------------------------------------------------
      UPDATE S
      SET 
        S.[CNT_Exp_DT] = C.[Exp_Date],
        S.[CNT_EXP_DAYS] = DATEDIFF(Day,  C.[Exp_Date],S.INV_DT),
        S.[ERR_CD] = 'EXC'
      FROM 
        [STAGE].[SALES_TRACING_CURR] S
        JOIN (SELECT [Contract ID], ITEMID, MAX([Exp Date]) AS [Exp_Date]
              FROM [STAGE].[CONT_PRICE]
              GROUP BY [Contract ID], ITEMID ) C
          ON (S.[UPD_CNT_ID] = C.[Contract ID]
          AND S.[UPD_PROD_ID] = C.[ITEMID]
          AND S.[INV_DT] > DATEADD(m,1,C.[Exp_Date]) ) 
      WHERE 
        S.[UPD_CNT_ID] IS NOT NULL --OR LEN(S.[UPD_CNT_ID])>0)
        AND S.[SLS_CALC_STAT] = 'P'
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
        
      
          
      -----------------------------------------------------------------------------
      ---                 PRODUCT NOT ON CONTRACT - EXCEPTION                   ---
      -----------------------------------------------------------------------------
       /*   
      UPDATE S
      SET  
        S.SLS_CALC_STAT = 'E',                                          
        S.ERR_CD = 'PNC'
      FROM [STAGE].[SALES_TRACING_CURR] S
      JOIN [STAGE].[CONT_PRICE] C ON LTRIM(RTRIM(S.[UPD_PROD_ID])) = LTRIM(RTRIM(C.[Contract ID]))
      WHERE ltrim(rtrim([UPD_PROD_ID]))+'-'+ltrim(rtrim([UPD_PROD_ID])) NOT IN 
          (SELECT DISTINCT ltrim(rtrim([Contract ID]))+'-'+ltrim(rtrim([ITEMID])) FROM [STAGE].[CONT_PRICE])
        AND S.[TRC_PRC_TYP] = 'CONT'
        AND S.[SLS_CALC_STAT] = 'P'
        AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND S.[DIST_ID] = isnull(@vDIst_Id,[DIST_ID]); 
        
*/
      UPDATE S
      SET S.ERR_CD = 'PNC'
      FROM [STAGE].[SALES_TRACING_CURR] S
      LEFT JOIN (
      SELECT DISTINCT ci.[Contract ID], ci.ITEMID
      FROM [STAGE].[CONT_PRICE] ci
      JOIN
        (SELECT DISTINCT [UPD_CNT_ID] 
         FROM [STAGE].[SALES_TRACING_CURR]
         WHERE [SLS_CALC_STAT] = 'P'
         AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
         AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
         ) ii
        ON ci.[Contract ID] = ii.[UPD_CNT_ID] ) C
    ON S.[UPD_CNT_ID] = C.[Contract ID] AND S.[UPD_PROD_ID] = C.ITEMID
    WHERE S.[UPD_CNT_ID] IS NOT NULL
      AND S.[SLS_CALC_STAT] = 'P'
      AND C.ITEMID IS NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND S.[DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ;  
        
-----------------------------------------------------------------------------
 ---                          SET SOME INITIAL VLAUES                     ---
-----------------------------------------------------------------------------
 
  -- We need to capture List price for every record to calculate rebate
-- Shouldn't we load it with dist price when there is one - because that is the out the door price
  UPDATE S
    SET S.[RBT_LIST_PRC] = L.CS_PRICE
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN [STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ;
  
  --- 10% DISCOUNT FOR AMD, MEDPLUS, MSD, NDC -- Need to manage this through interface ant table
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [RBT_LIST_PRC] = [RBT_LIST_PRC]*0.9
  WHERE [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND DIST_NR IN (  'C00104','C00102','C00103','132550') ;
  
--****************************************************************************
--    ASSIGN INV_DT, POPULATE INV_DT_NR
--*****************************************************************************

  -- If INV_DT is null use salesperiod
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [INV_DT] =  CONVERT(DATE,LEFT([sales_period],4)+'-'+LEFT(RIGHT([sales_period],4),2)+'-'+RIGHT([sales_period],2))
    ,INV_DT_IN = 'D'  -- Derived
    WHERE [INV_DT] IS NULL
    AND SLS_CALC_STAT = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET INV_DT_NR = datepart(yyyy,[INV_DT])*10000+datepart(mm,[INV_DT])*100+datepart(dd,[INV_DT])
    WHERE SLS_CALC_STAT = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])  
    and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])

--****************************************************************************
--    STEP 1: OTHER PRICE TYPE
--*****************************************************************************

--  DIST PRICE TYPE
--  if there is not contract, but there is distributor price available - then price type = dist 

  UPDATE S
  SET S.[TRC_PRC_TYP] = 'DIST'
   FROM [STAGE].[SALES_TRACING_CURR] S
   JOIN [STAGE].[DIST_PRICE] D 
      ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
      AND INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE+600)  -- 6 months grace period for shelf life
   WHERE 
   [TRC_PRC_TYP] IS NULL
   AND S.[SLS_CALC_STAT] = 'P'
   AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
   and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
   ;
   
  -- Everything else is list price
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_PRC_TYP] = 'LIST'
  WHERE [TRC_PRC_TYP] IS NULL
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);

--select  'TRC_PRC_TP is LIST...' , @@ROWCOUNT

---------------------------------------------------------------------
---  STEP 2: CALCULATE ALL TYPES OF PRICES ----
---------------------------------------------------------------------

-- Update TRC_CNT_PRC when [TRC_PRC_TYP] = 'CONT' but TRC_CNT_PRC  is null 
-- Calculate from (1) contract extnded cost, (2) Take the lesser of List and Dist Price (3) LIST OR DIST whatever is available

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_CNT_PRC] =   CASE 
    WHEN [TRC_EXT_CNT_COST] IS NOT NULL THEN [TRC_EXT_CNT_COST] / [TRC_QTY_SLD] 
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_LIST_PRC] IS NOT NULL THEN IIF ([TRC_DIST_PRC]<[TRC_LIST_PRC], [TRC_DIST_PRC], [TRC_LIST_PRC])
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_LIST_PRC] IS NULL THEN [TRC_DIST_PRC] 
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_DIST_PRC] IS NULL THEN [TRC_LIST_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'CONT' 
  AND [TRC_CNT_PRC] is NULL
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;

-- Update when [TRC_PRC_TYP] = 'DIST' but TRC_DIST_PRC  is null 
-- Take the extended cost/qty or lesser of List and Cont Price

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_DIST_PRC] =   CASE 
    WHEN [TRC_EXT_LIST_COST] IS NOT NULL THEN [TRC_EXT_LIST_COST] / [TRC_QTY_SLD]
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NOT NULL THEN IIF ([TRC_CNT_PRC]<[TRC_LIST_PRC], [TRC_CNT_PRC], [TRC_LIST_PRC])
    WHEN [TRC_LIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NULL THEN [TRC_LIST_PRC] 
    WHEN [TRC_LIST_PRC] IS NULL AND [TRC_CNT_PRC] IS NOT NULL THEN [TRC_CNT_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'DIST' 
  AND [SLS_CALC_STAT] = 'P'
  AND [TRC_DIST_PRC] is NULL
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;

-- Update when [TRC_PRC_TYP] = 'LIST' but TRC_LIST_PRC  is null 
-- extended Cost / Qry - Take the lesser of List and Cont Price

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_LIST_PRC] =   CASE 
    WHEN [TRC_EXT_LIST_COST] IS NOT NULL THEN [TRC_EXT_LIST_COST] / [TRC_QTY_SLD]
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NOT NULL THEN IIF ([TRC_CNT_PRC]>[TRC_DIST_PRC], [TRC_CNT_PRC], [TRC_DIST_PRC])
    WHEN [TRC_DIST_PRC] IS NOT NULL AND [TRC_CNT_PRC] IS NULL THEN [TRC_DIST_PRC] 
    WHEN [TRC_DIST_PRC] IS NULL AND [TRC_CNT_PRC] IS NOT NULL THEN [TRC_CNT_PRC] END
  WHERE 
  [TRC_PRC_TYP] = 'LIST' 
  AND [TRC_LIST_PRC] is NULL
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;

--select  'TRC_CNT_PRC is updated with TRC_DIST_PRC ...' , @@ROWCOUNT 

-- Calculate prices when there is no price but there is extended cost provided

  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [TRC_CNT_PRC] = [TRC_EXT_LIST_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'CONT' 
    AND [TRC_EXT_LIST_COST] IS NOT NULL
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    ;

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_DIST_PRC] = [TRC_EXT_CNT_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'DIST'
    AND [TRC_EXT_CNT_COST] IS NOT NULL
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    ;    

  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [TRC_LIST_PRC] = [TRC_EXT_CNT_COST]/[TRC_QTY_SLD]
  WHERE 
    [TRC_CNT_PRC] is NULL AND [TRC_DIST_PRC] IS NULL AND [TRC_LIST_PRC] IS NULL
    AND [TRC_PRC_TYP] = 'LIST'
    AND [TRC_EXT_CNT_COST] IS NOT NULL 
    AND [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
    ;
    
------------------------------------------------------------------------------
--  STEP 3: :  Calculate UOM
------------------------------------------------------------------------------

-- INITIALIZE --

UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_UPD_UNIT] = NULL
  WHERE 
  [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  
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
    [STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [STAGE].[CONT_PRICE] C
      JOIN [STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
      --AND S.[INV_DT] BETWEEN CNT.[Eff Date] AND DATEADD(m,1,CNT.[Exp Date])  -- Date validation will be later
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ;
    
  -- TRY DIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.CS_PRICE) AND (1.4*D.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.BX_PRICE) AND (1.4*D.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.EA_PRICE) AND (1.4*D.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND D.EXPDATE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[TRC_DIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 
    
  -- TRY LIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[TRC_LIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 
    
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
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE + 600)  -- OUT THE DOOR PRICE, SO GIVING 6 MONTHS SHELF LIFE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'DIST'
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 
  
  -- Try CONT Price
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.CS_PRICE) AND (1.4*CNT.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.BX_PRICE) AND (1.4*CNT.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.EA_PRICE) AND (1.4*CNT.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [STAGE].[CONT_PRICE] C
      JOIN [STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
  WHERE 
    [TRC_UPD_UNIT] IS NULL
    AND [TRC_PRC_TYP] = 'DIST'
    AND S.[TRC_CNT_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ;
 
  -- TRY LIST PRICE
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'DIST'
    AND S.[TRC_LIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 

--------------------------------------------------------------------------------------------------
  --- 3.3 For 'LIST' Price Type -- Will try out all 3 type of prices - in the order of LIST, DIST, CNT
  ---------------------------------------------------------------------------------------------------
  -- TRY LIST PRICE
/*  
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.CS_PRICE) AND (1.4*L.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.BX_PRICE) AND (1.4*L.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_LIST_PRC] BETWEEN (0.6*L.EA_PRICE) AND (1.4*L.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 
  */
  UPDATE S 
   SET [TRC_UPD_UNIT] =
    CASE
      WHEN  L.BX_PRICE IS NULL AND L.EA_PRICE IS NULL THEN 'CS'
      
      WHEN  L.BX_PRICE IS NOT NULL AND S.[TRC_LIST_PRC] > STAGE.fnGreaterOf ((L.BX_PRICE+0.5*(L.CS_PRICE-L.BX_PRICE)),0.5*L.CS_PRICE ) THEN 'CS'
      WHEN  L.BX_PRICE IS NOT NULL AND L.EA_PRICE IS NOT NULL AND S.[TRC_LIST_PRC] 
            BETWEEN STAGE.fnGreaterOf ((L.EA_PRICE+0.51*(L.BX_PRICE-L.EA_PRICE)),(0.5001*L.BX_PRICE) ) 
            AND STAGE.fnLesserOf((L.BX_PRICE+0.4999*(L.CS_PRICE-L.BX_PRICE)), 2*L.BX_PRICE) THEN 'BX'
      WHEN  L.BX_PRICE IS NOT NULL AND L.EA_PRICE IS NULL AND S.[TRC_LIST_PRC] < STAGE.fnLesserOf((L.BX_PRICE+0.5*(L.CS_PRICE-L.BX_PRICE)), 2*L.BX_PRICE) THEN 'BX'
      WHEN  L.BX_PRICE IS NOT NULL AND L.EA_PRICE IS NOT NULL AND S.[TRC_LIST_PRC] < STAGE.fnLesserOf((L.EA_PRICE+0.5*(L.BX_PRICE-L.EA_PRICE)), 2*L.EA_PRICE) THEN 'EA'
      
      WHEN  L.BX_PRICE IS NULL AND L.EA_PRICE IS NOT NULL AND S.[TRC_LIST_PRC] > STAGE.fnGreaterOf ((L.EA_PRICE+0.5*(L.CS_PRICE-L.EA_PRICE)),0.5*L.CS_PRICE ) THEN 'CS'
      WHEN  L.BX_PRICE IS NULL AND L.EA_PRICE IS NOT NULL AND S.[TRC_LIST_PRC] < STAGE.fnLesserOf((L.EA_PRICE+0.5*(L.CS_PRICE-L.EA_PRICE)), 2*L.EA_PRICE) THEN 'EA'     
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[LIST_PRICE] L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
    
  -- TRY DIST PRICE
  UPDATE S 
   SET [TRC_UPD_UNIT] =
    CASE
      WHEN  D.BX_PRICE IS NULL AND D.EA_PRICE IS NULL THEN 'CS'
      
      WHEN  D.BX_PRICE IS NOT NULL AND S.[TRC_DIST_PRC] > STAGE.fnGreaterOf ((D.BX_PRICE+0.5*(D.CS_PRICE-D.BX_PRICE)),0.5*D.CS_PRICE ) THEN 'CS'
      WHEN  D.BX_PRICE IS NOT NULL AND D.EA_PRICE IS NOT NULL AND S.[TRC_DIST_PRC] 
            BETWEEN STAGE.fnGreaterOf ((D.EA_PRICE+0.51*(D.BX_PRICE-D.EA_PRICE)),(0.5001*D.BX_PRICE) ) 
            AND STAGE.fnLesserOf((D.BX_PRICE+0.4999*(D.CS_PRICE-D.BX_PRICE)), 2*D.BX_PRICE) THEN 'BX'
      WHEN  D.BX_PRICE IS NOT NULL AND D.EA_PRICE IS NULL AND S.[TRC_DIST_PRC] < STAGE.fnLesserOf((D.BX_PRICE+0.5*(D.CS_PRICE-D.BX_PRICE)), 2*D.BX_PRICE) THEN 'BX'
      WHEN  D.BX_PRICE IS NOT NULL AND D.EA_PRICE IS NOT NULL AND S.[TRC_DIST_PRC] < STAGE.fnLesserOf((D.EA_PRICE+0.5*(D.BX_PRICE-D.EA_PRICE)), 2*D.EA_PRICE) THEN 'EA'
      
      WHEN  D.BX_PRICE IS NULL AND D.EA_PRICE IS NOT NULL AND S.[TRC_DIST_PRC] > STAGE.fnGreaterOf ((D.EA_PRICE+0.5*(D.CS_PRICE-D.EA_PRICE)),0.5*D.CS_PRICE ) THEN 'CS'
      WHEN  D.BX_PRICE IS NULL AND D.EA_PRICE IS NOT NULL AND S.[TRC_DIST_PRC] < STAGE.fnLesserOf((D.EA_PRICE+0.5*(D.CS_PRICE-D.EA_PRICE)), 2*D.EA_PRICE) THEN 'EA'     
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND D.EXPDATE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'DIST'
    AND S.[TRC_DIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
  
 
    
  -- TRY CONTRACT PRICE
  
  UPDATE S 
   SET [TRC_UPD_UNIT] =
    CASE
      WHEN  CNT.BX_PRICE IS NULL AND CNT.EA_PRICE IS NULL THEN 'CS'
      
      WHEN  CNT.BX_PRICE IS NOT NULL AND S.[TRC_CNT_PRC] > STAGE.fnGreaterOf ((CNT.BX_PRICE+0.5*(CNT.CS_PRICE-CNT.BX_PRICE)),0.5*CNT.CS_PRICE ) THEN 'CS'
      WHEN  CNT.BX_PRICE IS NOT NULL AND CNT.EA_PRICE IS NOT NULL AND S.[TRC_CNT_PRC] 
            BETWEEN STAGE.fnGreaterOf ((CNT.EA_PRICE+0.51*(CNT.BX_PRICE-CNT.EA_PRICE)),(0.5001*CNT.BX_PRICE) ) 
            AND STAGE.fnLesserOf((CNT.BX_PRICE+0.4999*(CNT.CS_PRICE-CNT.BX_PRICE)), 2*CNT.BX_PRICE) THEN 'BX'
      WHEN  CNT.BX_PRICE IS NOT NULL AND CNT.EA_PRICE IS NULL AND S.[TRC_CNT_PRC] < STAGE.fnLesserOf((CNT.BX_PRICE+0.5*(CNT.CS_PRICE-CNT.BX_PRICE)), 2*CNT.BX_PRICE) THEN 'BX'
      WHEN  CNT.BX_PRICE IS NOT NULL AND CNT.EA_PRICE IS NOT NULL AND S.[TRC_CNT_PRC] < STAGE.fnLesserOf((CNT.EA_PRICE+0.5*(CNT.BX_PRICE-CNT.EA_PRICE)), 2*CNT.EA_PRICE) THEN 'EA'
      
      WHEN  CNT.BX_PRICE IS NULL AND CNT.EA_PRICE IS NOT NULL AND S.[TRC_CNT_PRC] > STAGE.fnGreaterOf ((CNT.EA_PRICE+0.5*(CNT.CS_PRICE-CNT.EA_PRICE)),0.5*CNT.CS_PRICE ) THEN 'CS'
      WHEN  CNT.BX_PRICE IS NULL AND CNT.EA_PRICE IS NOT NULL AND S.[TRC_CNT_PRC] < STAGE.fnLesserOf((CNT.EA_PRICE+0.5*(CNT.CS_PRICE-CNT.EA_PRICE)), 2*CNT.EA_PRICE) THEN 'EA'     
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [STAGE].[CONT_PRICE] C
      JOIN [STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'CONT'
    AND S.[TRC_CNT_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);


    /*
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.CS_PRICE) AND (1.4*D.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.BX_PRICE) AND (1.4*D.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_DIST_PRC] BETWEEN (0.6*D.EA_PRICE) AND (1.4*D.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[DIST_PRICE] D
         ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
         AND S.INV_DT_NR BETWEEN D.EFFDATE AND D.EXPDATE
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[TRC_DIST_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ; 


  -- Try CONT Price
  UPDATE S
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.CS_PRICE) AND (1.4*CNT.CS_PRICE) THEN 'CS'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.BX_PRICE) AND (1.4*CNT.BX_PRICE) THEN 'BX'
      WHEN S.[TRC_CNT_PRC] BETWEEN (0.6*CNT.EA_PRICE) AND (1.4*CNT.EA_PRICE) THEN 'EA'
    END
  FROM
    [STAGE].[SALES_TRACING_CURR] S
    JOIN
      (SELECT [Contract ID], ITEMID, [Contract Price] AS CS_PRICE, C.[Contract Price]/L.BX BX_PRICE,
      C.[Contract Price]/L.EA EA_PRICE, L.BX, L.EA,  C.[Eff Date], C.[Exp Date]
      FROM [STAGE].[CONT_PRICE] C
      JOIN [STAGE].[LIST_PRICE] L ON C.ITEMID = L.[ITEM NO]) AS CNT
      ON S.[UPD_CNT_ID] = CNT.[Contract ID] AND S.[UPD_PROD_ID] = CNT.ITEMID 
  WHERE 
    S.[TRC_UPD_UNIT] IS NULL
    AND S.[TRC_PRC_TYP] = 'LIST'
    AND S.[TRC_CNT_PRC] IS NOT NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
    ;
    */
--------------------------------------------------------------------------------------------------
  --- 3.4 Remaining from the correction file
  ---------------------------------------------------------------------------------------------------
  
  UPDATE S
  SET S.TRC_UPD_UNIT = X.UPD_UOM
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN STAGE.TRC_UOM_CORR_XREF X ON S.DIST_NR = X.DIST_NR AND S.TRC_UNIT = X.TRC_UOM
  WHERE 
  [TRC_UPD_UNIT] IS NULL
  AND S.[SLS_CALC_STAT] = 'P'
  AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
  ;  
  
  --- FOR THE REST RAISE A FLAG
  UPDATE [STAGE].[SALES_TRACING_CURR] 
  SET ERR_CD = 'UOM'
  WHERE
  [TRC_UPD_UNIT] IS NULL
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;
  
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
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET [TRC_UPD_UNIT] =
    CASE
      WHEN [TRC_UNIT] IN ('BX','EA','CS') THEN [TRC_UNIT]
      WHEN [TRC_UNIT] IN ('TU','TB','BG','PK','PH', 'TUB') THEN 'BX'
      WHEN [TRC_UNIT] = 'CA' THEN 'CS'
    END
  WHERE [TRC_UPD_UNIT] IS NULL
  AND [ERR_CD] = 'UOM'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;

  -- INCREASE THE BOUNDARY A LITTLE MORE


  --- FOR THE REST Exclude from calculation
  UPDATE [STAGE].[SALES_TRACING_CURR] 
  SET [SLS_CALC_STAT] = 'E'
  WHERE
  [TRC_UPD_UNIT] IS NULL
  AND [ERR_CD] = 'UOM'
  AND [SLS_CALC_STAT] = 'P'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  ;
  
  ------------------------------------------------------------------
  --- Calculate the case quantity
  ------------------------------------------------------------------
    
  UPDATE S
   SET  [UPD_CS_QTY]  = CASE
        WHEN S.[TRC_UPD_UNIT] = 'CS' THEN S.[TRC_QTY_SLD]
        WHEN S.[TRC_UPD_UNIT] = 'BX' THEN S.[TRC_QTY_SLD]/L.[BX]
        WHEN S.[TRC_UPD_UNIT] = 'EA' THEN S.[TRC_QTY_SLD]/L.[EA]
        END
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN [STAGE].[LIST_PRICE] L ON [UPD_PROD_ID] = L.[ITEM NO] 
  WHERE S.[TRC_UPD_UNIT] IS NOT NULL
  AND S.[SLS_CALC_STAT] = 'P'
  AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
  ;


  ------------------------------------------------------------------
  --- Get CNT Price first. But before initialize
  ------------------------------------------------------------------
    
    UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [UPD_CS_PRC] =  NULL, [UPD_PRC_TYP] = NULL
    WHERE [SLS_CALC_STAT] = 'P';
    
    UPDATE S
    SET 
      S.[CNT_EXP_DT] = C.[Exp Date],
      S.[UPD_CS_PRC] =  C.[Contract Price],
      S.[UPD_PRC_TYP] = 'CONT',
      S.[CNT_EXP_DAYS] = DATEDIFF(Day,  C.[Exp Date],S.INV_DT)
    FROM 
      [STAGE].[SALES_TRACING_CURR] S
      JOIN [STAGE].[CONT_PRICE] C
          ON (S.[UPD_CNT_ID] = C.[Contract ID]             -- CNT_ID Corrected by corr xref table
          AND S.[UPD_PROD_ID] = C.[ITEMID]
          AND S.[INV_DT] BETWEEN C.[Eff Date] AND DATEADD(m,1,C.[Exp Date]) ) 
    WHERE 
      S.[TRC_PRC_TYP] = 'CONT'
      AND S.[SLS_CALC_STAT] = 'P'
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
      ;
      
  ------------------------------------------------------------------
  --- Then Get Dist Case Price
  ------------------------------------------------------------------

    UPDATE S
    SET 
      S.[UPD_CS_PRC] =  D.[CS_PRICE],
      S.[UPD_PRC_TYP] = 'DIST'
    FROM [STAGE].[SALES_TRACING_CURR] S
         JOIN [STAGE].[DIST_PRICE] D 
          ON S.DIST_NR = D.DISTID and S.[UPD_PROD_ID] = D.ITEMID 
          AND INV_DT_NR BETWEEN D.EFFDATE AND (D.EXPDATE+600)  -- 6 months grace period for shelf life
    WHERE 
      S.[UPD_PRC_TYP] IS NULL
      AND S.[SLS_CALC_STAT] = 'P'
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID])
      ;
      
  ------------------------------------------------------------------
  --- Remaining is List Price
  ------------------------------------------------------------------
      
  UPDATE S
    SET 
      S.[UPD_CS_PRC] =  L.[CS_PRICE],
      S.[UPD_PRC_TYP] = 'LIST'
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN STAGE.List_Price L ON S.[UPD_PROD_ID] = L.[ITEM NO]
  WHERE
    S.[UPD_PRC_TYP] IS NULL
    AND S.[SLS_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
	  AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
    
  --- 10% DISCOUNT FOR AMD, MEDPLUS, MSD, NDC -- Need to manage this through interface ant table
  UPDATE [STAGE].[SALES_TRACING_CURR]
    SET [UPD_CS_PRC] = [UPD_CS_PRC]*0.9
  WHERE [SLS_CALC_STAT] = 'P'
  and [UPD_PRC_TYP] = 'LIST'
  AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
  AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])
  AND DIST_NR IN (  'C00104','C00102','C00103','132550') ;

---------------------------------------------------------------------
-----   SALES AMOUNT CALCULATION --- 
---------------------------------------------------------------------

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
    [UPD_SALES_AMT] = [UPD_CS_QTY] * [UPD_CS_PRC],
    [SLS_CALC_STAT] = 'C'
  WHERE
    [SLS_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID])


---------------------------------------------------------------------
---         R E B A T E   C A L C U L A T I O N                    ---
---------------------------------------------------------------------

  --- R E S E T ------
  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
    [RBT_STAT_CD] = NULL, 
    [UPD_RBT_AMT] = 0
  WHERE [RBT_CALC_STAT] = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  

--- FILE CAME 45 DAYS AFTER INV_DT --

  UPDATE [STAGE].[SALES_TRACING_CURR]
  SET 
    [RBT_STAT_CD] = 'LS',
    [UPD_RBT_AMT] = 0,
    [RBT_CALC_STAT] = 'E'
  WHERE 
    CONVERT(DATE,[YEAR]+'-'+[MNTH]+'-'+[DAY]) > DATEADD(DAY,47,[INV_DT])  
    AND [RBT_CALC_STAT]  = 'P'
    AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]);
  -- assuming we loaded it right away -- This is manual - so needs to allow extra time?

  ------------------------------
  -- CORRECTION TO CNT NUMBER --
  ------------------------------
  
  -- Will only fix GPO Contract number to PDI contract number
  
  UPDATE S
    SET S.[RBT_CNT_ID] = X.UPD_CNT_ID
  FROM [STAGE].[SALES_TRACING_CURR] S
  JOIN [STAGE].[TRC_CNT_CORR_XREF] X 
       ON S.TRC_CNT_ID = X.TRC_CNT_ID AND S.UPD_PROD_ID = X.PROD_ID
       AND X.TRC_CNT_TYP = 'GPO'       
  WHERE 
    S.[RBT_CALC_STAT] = 'P'
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]); 
  
  ------------------------------
  ---     VALID CONTRACT      -- 
  ------------------------------
  UPDATE S
  SET 
    [RBT_STAT_CD] = 'VC',
    [CNT_EXP_DT] = C.[Exp Date],
    [UPD_RBT_AMT] = ([RBT_LIST_PRC] - C.[Contract Price])*S.[UPD_CS_QTY],
    RBT_CALC_STAT = 'C'
  FROM 
    [STAGE].[SALES_TRACING_CURR] S
    JOIN [STAGE].[CONT_PRICE] C
 
        ON (S.[RBT_CNT_ID] = C.[Contract ID]
        AND S.[UPD_PROD_ID] = C.[ITEMID]
        AND S.[INV_DT] BETWEEN C.[Eff Date] AND DATEADD(m,1,C.[Exp Date]) ) 
  WHERE 
    RBT_CALC_STAT = 'P'
    AND LEN(S.RBT_CNT_ID) > 0
--    AND s.[RBT_STAT_CD] IS NULL
    AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
    and S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]);
        
  ------------------------------------------------------------------
  --- CONTRACT EXPIRED - EXCEPTION
  ------------------------------------------------------------------
  
    UPDATE S
    SET 
      [RBT_STAT_CD] = 'EC',    -- Expired Contract
      [CNT_EXP_DT] = C.[Exp Date],
      [UPD_RBT_AMT] = 0,
      [RBT_CALC_STAT] = 'E'
    FROM STAGE.SALES_TRACING_CURR S
    JOIN (SELECT [Contract ID], ITEMID, MAX([Exp Date]) AS [Exp Date]
          FROM [STAGE].[CONT_PRICE]
          GROUP BY [Contract ID], ITEMID ) C
        ON (S.[RBT_CNT_ID] = C.[Contract ID]
        AND S.[UPD_PROD_ID] = C.ITEMID
        AND S.[INV_DT] > DATEADD(m,1,C.[Exp Date]))
    WHERE  
      S.[RBT_CALC_STAT] = 'P'
      AND S.[RBT_STAT_CD] = NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND S.[DIST_ID] = isnull(@vDIst_Id,S.[DIST_ID]); 

  --------------------------------------------------
  --- CONTRACT DOES NOT EXIST - EXCEPTION ---
  --------------------------------------------------
      /*
      UPDATE [STAGE].[SALES_TRACING_CURR]
      SET 
        [RBT_STAT_CD] = 'IC',  -- Invalid Contract
        [UPD_RBT_AMT] = 0,
        [RBT_CALC_STAT] = 'E'
      WHERE 
        [RBT_CNT_ID] NOT IN
        (SELECT DISTINCT C.CONTRACT_NO FROM STAGE.DIM_CONTRACT C WHERE S.[INV_DT] <= DATEADD(m,1,C.[Exp Date])) 
        AND S.[RBT_CALC_STAT] = 'P'
        AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
        AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ; */
        
     --- INVALID CONTRACT ID

    UPDATE S
    SET 
        [RBT_STAT_CD] = 'IC',  -- Invalid Contract ID
        [UPD_RBT_AMT] = 0,
        [RBT_CALC_STAT] = 'E'
    FROM [STAGE].[SALES_TRACING_CURR] S
    LEFT JOIN [STAGE].[CONT_PRICE] C
        ON S.[RBT_CNT_ID] = C.[Contract ID]
    WHERE S.[RBT_CALC_STAT] = 'P'
      AND C.[Contract ID] IS NULL
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ; 
        
        
  -----------------------------------------------------------------------------
  ---                 PRODUCT NOT ON CONTRACT - EXCEPTION                   ---
  -----------------------------------------------------------------------------
  -- First find a data set of contract and item from contract PRICE tabl
  
    UPDATE S
      SET RBT_STAT_CD = 'IP',  -- Invalid Product
      [UPD_RBT_AMT] = 0,
      [RBT_CALC_STAT] = 'E'
    FROM [STAGE].[SALES_TRACING_CURR] S
    LEFT JOIN (
      SELECT DISTINCT ci.[Contract ID], ci.ITEMID
      FROM [STAGE].[CONT_PRICE] ci
      JOIN
        (SELECT DISTINCT [RBT_CNT_ID] 
         FROM [STAGE].[SALES_TRACING_CURR]
         WHERE [RBT_CALC_STAT] = 'P') ii
        ON ci.[Contract ID] = ii.[RBT_CNT_ID] ) C
    ON S.[RBT_CNT_ID] = C.[Contract ID] AND S.[UPD_PROD_ID] = C.ITEMID
    WHERE S.[RBT_CALC_STAT] = 'P'
      AND C.ITEMID IS NULL
      AND S.[SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ; 

    --- WRONG CALCULATION

    UPDATE [STAGE].[SALES_TRACING_CURR]
      SET RBT_STAT_CD = 'WC'                                        -- WRONG CALCULATION
    WHERE ([TRC_RBT_AMT] - [UPD_RBT_AMT]) > 0.14
      AND [RBT_STAT_CD] = 'VC'
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ; 
    
    
    UPDATE [STAGE].[SALES_TRACING_CURR]
      SET RBT_STAT_CD = 'IV'                                        -- Insignificant Variance
    WHERE ([TRC_RBT_AMT] - [UPD_RBT_AMT]) < 0.15
      AND [RBT_STAT_CD] = 'VC'
      AND [SALES_PERIOD] = isnull(@vSales_Period,[SALES_PERIOD])
      AND [DIST_ID] = isnull(@vDIst_Id,[DIST_ID]) ;

END