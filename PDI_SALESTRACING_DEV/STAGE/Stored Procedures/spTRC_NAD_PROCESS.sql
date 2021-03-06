﻿CREATE PROCEDURE [STAGE].[spTRC_NAD_PROCESS] 
@ID INT = NULL
WITH EXEC AS CALLER
AS
BEGIN  

-- First load the ID, Name and addresses to temp laundry table for cleaning 
-- Take comment out once we are done with developing the stored proc



  TRUNCATE TABLE MDM_STAGE.TEMP_ADDR;
  TRUNCATE TABLE  MDM_STAGE.TEMP_ADDR_PARTS;
  
  INSERT INTO MDM_STAGE.TEMP_ADDR ( SRC_ID, ORIG_NM, ADDR_1, ADDR_2)
  SELECT TRC_ENDUSER_1_ID, DISTACCTSHIPNAME, DISTACCTSHIPADDR1, DISTACCTSHIPADDR2 
  FROM STAGE.TRC_ENDUSER_1 WHERE DISTACCTSHIPADDR1 IS NOT NULL
  ;

 -- IF Address Line 1 is NULL but Address Line 2 has a value - switch
  UPDATE MDM_STAGE.TEMP_ADDR
  SET 
    ADDR_1 = ADDR_2,  
    ADDR_2 = NULL
  WHERE  ADDR_1 IS NULL AND ADDR_2 IS NOT NULL
  --AND SRC_ID = ISNULL(@ID ,SRC_ID )
  ;


-- If both Addr1 and Addr2 is same then delete Addr2 
  UPDATE MDM_STAGE.TEMP_ADDR
    SET ADDR_2 = NULL
  WHERE ADDR_1 = ADDR_2
  --AND SRCE_DATA_ID = ISNULL(@ID ,SRCE_DATA_ID)
  ;

-- Remove all extra spaces from the fields
UPDATE MDM_STAGE.TEMP_ADDR
  SET 
    ORIG_NM = STAGE.fnRemoveSpace_SpChar( ORIG_NM), 
    ADDR_1 = STAGE.fnRemoveSpace_SpChar(ADDR_1), 
    ADDR_2 = STAGE.fnRemoveSpace_SpChar(ADDR_2)    ;
  

-- Detect and assign proper value for Null or ZIP address line
  UPDATE MDM_STAGE.TEMP_ADDR
  SET ADDR_1 = 'NO ADDRESS'
  WHERE  ADDR_1 IS NULL AND ADDR_2 IS NULL;
  
  UPDATE MDM_STAGE.TEMP_ADDR
  SET ADDR_1 = 'NO ADDRESS'
  WHERE  ADDR_1 LIKE 'ZIP%';
  
  ----  UPDATE THE SOURCE TABLE
  
  UPDATE E
    SET E.UPD_ADDR1 = ADDR_1
  FROM STAGE.TRC_ENDUSER_1 E
  JOIN MDM_STAGE.TEMP_ADDR A ON A.SRC_ID = E.TRC_ENDUSER_1_ID
  AND A.ADDR_1 = 'NO ADDRESS';
  
  -- THEN REMOVE FROM TEMP TABLE
  DELETE FROM MDM_STAGE.TEMP_ADDR WHERE ADDR_1 = 'NO ADDRESS';
  
  ---- ----------------------------------------
  ----  SWITCH ADDR1 AND ADDR2 WHEN APPLICABLE
  ----------------------------------------------
  
  UPDATE T
    SET T.STAT_2_CD = 1         
  FROM MDM_STAGE.TEMP_ADDR T
  JOIN REF.ADDR_STD A ON ADDR_2 LIKE '% '+A.ADDR_VAR
          AND CAT IN ('Roadway','Location')
  WHERE ISNUMERIC(LEFT(ADDR_2,1)) = 1;
  
  UPDATE T
    SET T.STAT_2_CD = 1         
  FROM MDM_STAGE.TEMP_ADDR T
  JOIN REF.ADDR_STD A ON ADDR_2 LIKE '% '+A.ADDR_VAR+' %'
          AND CAT IN ('Roadway','Location')
  WHERE ISNUMERIC(LEFT(ADDR_2,1)) = 1
  AND T.STAT_2_CD IS NULL;  -- TO AVOID OVRLAPPING TAGGING
  

  
  UPDATE T
    SET T.STAT_1_CD = 1         
  FROM MDM_STAGE.TEMP_ADDR T
  JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ADDR_1) LIKE '% '+A.ADDR_VAR
          AND CAT IN ('Roadway','Location')
  WHERE ISNUMERIC(LEFT(ADDR_1,1)) = 1
  AND T.STAT_2_CD = 1;
  
  UPDATE T
    SET T.STAT_1_CD = 1         
  FROM MDM_STAGE.TEMP_ADDR T
  JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ADDR_1) LIKE '% '+A.ADDR_VAR+' %'
          AND CAT IN ('Roadway','Location')
  WHERE ISNUMERIC(LEFT(ADDR_1,1)) = 1
  AND T.STAT_2_CD = 1
  AND T.STAT_1_CD is NULL;

  ---- NOW SWTICH --- 
  UPDATE MDM_STAGE.TEMP_ADDR SET
    ADDR_1 = ADDR_2,  
    ADDR_2 = ADDR_1
  WHERE STAT_2_CD = 1 AND STAT_1_CD IS NULL;
  
  --- RESET ---
  UPDATE MDM_STAGE.TEMP_ADDR SET STAT_1_CD = NULL WHERE STAT_1_CD IS NOT NULL;
  UPDATE MDM_STAGE.TEMP_ADDR SET STAT_2_CD = NULL WHERE STAT_2_CD IS NOT NULL;
  
  ------------------------------------
 /* 
  SELECT COUNT(*)
  FROM MDM_STAGE.TEMP_ADDR T
  LEFT JOIN REF.ADDR_STD A ON STAGE.fnLastWord(ADDR_1) = A.ADDR_VAR 
          AND CAT IN ('Roadway','Location')
  WHERE A.ADDR_VAR IS NULL 
  AND T.STAT_2_CD = 1 ;
*/
  ------------------------------------
  -- EXECUTE THE STROED PROC to clean 
  ------------------------------------
  
  EXEC [STAGE].[spADDR_LAUNDRY];
  
  -----------------------------------
  
  TRUNCATE TABLE MDM_STAGE.TRC_ADDR_PARTS;
  
  INSERT INTO MDM_STAGE.TRC_ADDR_PARTS ( 
    SRC_ID, ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2  )
  SELECT 
    SRC_ID, ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2  
  FROM MDM_STAGE.TEMP_ADDR_PARTS  ;  
  
  UPDATE E
    SET E.UPD_ADDR1 = A.ADDR_1, E.UPD_ADDR2 =  A.ADDR_2
  FROM STAGE.TRC_ENDUSER_1 E 
  JOIN MDM_STAGE.TEMP_ADDR_PARTS A ON E.TRC_ENDUSER_1_ID = A.SRC_ID;
  
  UPDATE STAGE.TRC_ENDUSER_1 SET
    UPD_ADDR1 = 'NO ADDRESS' WHERE UPD_ADDR1 IS NULL;
  
  --TRUNCATE TABLE  MDM_STAGE.TEMP_ADDR_PARTS;
  --TRUNCATE TABLE  MDM_STAGE.TEMP_ADDR;
  
  -- reassign primary location city to the address for better compability
  
  UPDATE STAGE.TRC_ENDUSER_1 SET DISTACCTSHIPZIP = LEFT(LTRIM(DISTACCTSHIPZIP),5);
  UPDATE STAGE.TRC_ENDUSER_1 SET DISTACCTSHIPZIP = '0'+DISTACCTSHIPZIP WHERE LEN(DISTACCTSHIPZIP) = 4;
  UPDATE STAGE.TRC_ENDUSER_1 SET DISTACCTSHIPZIP = '00'+DISTACCTSHIPZIP WHERE LEN(DISTACCTSHIPZIP) = 3;
  
  UPDATE T SET
    T.UPD_CITY = Z.City
  from STAGE.TRC_ENDUSER_1 T
  JOIN REF.ZIP_CODE Z ON T.DISTACCTSHIPZIP = Z.Zipcode
  WHERE  Z.LocationType = 'PRIMARY';
  
  ---------------------------------------
  -----    MATCH MASTER DATA   ----------
  ---------------------------------------
  
  --- Iteration 1
  UPDATE E SET
    E.COMPANY_ID = C.CMPNY_ID
  FROM STAGE.TRC_ENDUSER_1 E
  JOIN MDM_STAGE.TRC_ADDR_PARTS T ON E.TRC_ENDUSER_1_ID = T.SRC_ID
  JOIN MDM_STAGE.CMPNY_ADDR_PARTS CA 
    ON T.ST_NR = CA.ST_NR AND T.ST_NM = CA.ST_NM 
    AND ISNULL(T.STE_NR,'NA') = ISNULL(CA.STE_NR,'NA')
  JOIN CMPNY.CMPNY_TO_ADDR_XREF X ON CA.CMPNY_ADDR_ID = X.ADDR_ID AND X.PRIMARY_CMPNY_IN = 'Y'
  JOIN CMPNY.COMPANY C ON X.CMPNY_ID = C.CMPNY_ID AND E.UPD_CITY = C.CMPNY_CITY AND E.DISTACCTSHIPSTATE = C.CMPNY_ST ;
  
  ----  ITERATION 2
  --- MAX ID
    UPDATE E SET
    E.COMPANY_ID = X.HOSPITAL_ID
      FROM STAGE.TRC_ENDUSER_1 E 
      JOIN STAGE.PDI_MAX_TO_DEFHC_CROSSWALK X ON E.COACCTMAX = X.CompanyId
      WHERE E.COACCTMAX IS NOT NULL
      --AND E.COMPANY_ID IS NULL      -- Trusting DDS mapping more, when my new process gets refined, I will take the comment off
      ;
  -- Same Distributor assigned ID + zip
  UPDATE E1 SET
    E1.COMPANY_ID = E2.COMPANY_ID
  FROM STAGE.TRC_ENDUSER_1 E1 ,
    (SELECT DISTINCT  COMPANY_ID, DISTID, DISTACCTID, DISTACCTSHIPZIP 
    FROM STAGE.TRC_ENDUSER_1 
    WHERE COMPANY_ID IS NOT NULL) E2
    WHERE E1.DISTID  = E2.DISTID 
    AND E1.DISTACCTID = E2.DISTACCTID
    AND E1.DISTACCTSHIPZIP  = E2.DISTACCTSHIPZIP 
    AND E1.COMPANY_ID IS NULL;
    
    -- after further analysis of distributor data, zip code condtion can be taken of for the distrbutors whihc do not reuse ID
  
  -------- iteration 3
  -- same street and closest name - minimum score 50%
  
  -------- iteration 4
  -- same zip - maxmim name score -- minimum score 50%
  
  -------- iteration 5
  -- same city state - maxmim name score -- minimum score 50%
  
  -------- iteration 6
  -- highest name score within 20 miles -- 
  
  -------- iteration 7
  -- get from DQS --
  --- Google API
  
  --- Keep createing more iteration  ------------
  
  UPDATE C SET
    BUYER_INDICATOR = 'Y'
  FROM CMPNY.COMPANY C
  JOIN STAGE.TRC_ENDUSER_1 E ON E.COMPANY_ID = C.CMPNY_ID 
  WHERE E.COMPANY_ID IS NOT NULL;
  
  --- SALES DETAIL --
  TRUNCATE TABLE CMPNY.CMPNY_SALES;
  
  INSERT INTO CMPNY.CMPNY_SALES (  
    [CMPNY_ID], [Sani Surface], [Prevantics], [Specialty], [Sani Hands], [Iodine], [Baby Wipes], [Hygea], [Adult Wipes], [Compliance Accessories], [Profend], [All Other], [TOTAL SALES PRIOR YEAR])
  SELECT 
    C.CMPNY_ID, 
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Sani Surface' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Sani Surface],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Prevantics' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Prevantics],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Specialty' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Specialty],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Sani Hands' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Sani Hands],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Iodine' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Iodine],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Baby Wipes' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Baby Wipes],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Hygea' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Hygea],

    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Adult Wipes' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Adult Wipes],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Compliance Accessories' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Compliance Accessories],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'Profend' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [Profend],
    SUM(CASE WHEN P.PROD_CATEGORY_ERP = 'All Other' THEN S.COTOTALSALESAMNT ELSE 0 END) AS [All Other],
    SUM(S.COTOTALSALESAMNT) [SALES PRIOR YEAR]
  FROM CMPNY.COMPANY C
  JOIN STAGE.TRC_ENDUSER_1 E ON E.COMPANY_ID = C.CMPNY_ID
  JOIN STAGE.DDS_PDI_SAF_EXTRACT S ON S.COACCTID = E.COACCTID
  JOIN STAGE.dim_product P ON S.COITEMID = P.PRODUCT_ID
  WHERE LEFT(S.SALESPERIOD,4) = 2018
  GROUP BY C.CMPNY_ID ;
  
  -- UPDATE FOR IDN OR PARENT
  
  
  END;