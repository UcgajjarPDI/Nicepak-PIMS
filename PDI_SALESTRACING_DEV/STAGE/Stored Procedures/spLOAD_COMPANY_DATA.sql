﻿CREATE PROCEDURE [STAGE].[spLOAD_COMPANY_DATA] 
WITH EXEC AS CALLER
AS
BEGIN    
    -- INITIAL LOAD
    
    TRUNCATE TABLE CMPNY.COMPANY;
  
    -- FIRST LOAD THE UNQIUE ADDRESS DATA WHICH DOES NOT HAVE DUPLICATES
    INSERT INTO CMPNY.COMPANY
      ( SRC_CMPNY_ID, CMPNY_NM, CMPNY_ALT_NM, ALT_NM_TYP, CMPNY_ADDR_1, CMPNY_ADDR_2, CMPNY_CITY, 
      CMPNY_ST, CMPNY_ZIP, CMPNY_CNTRY, 
      CMPNY_TYP_ID, CMPNY_CTGRY_ID, CMPNY_SGMNT_ID, CMPNY_SUB_SGMNT_ID, 
      COMPANY_URL, NPI_NR, GLN_NR, HIN_NR, DEA_NR, 
      REC_EFF_DT, REC_EXP_DT, REC_STAT_IN, SRC_ID, CMPNY_PRNT_SRC_ID, IDN_SRC_ID, IDN_PRNT_SRC_ID   )
    SELECT 
      DHC_CO_ID, DHC_CO_NM_1, DHC_CO_NM_2, DHC_CO_NM_2_TYP, DHC_CO_ADDR_1, DHC_CO_ADDR_2, DHC_CO_CITY, 
      DHC_CO_ST, DHC_CO_ZIP, DHC_CO_CNTRY, 
      T.CMPNY_TYP_ID,
      1 AS CMPNY_CTGRY_ID, -- Primary Account
      S.CMPNY_SGMNT_ID , 
      SS.CMPNY_SUB_SGMNT_ID , 
      DHC_CO_WEBSITE, NPI_NR, GLN_NR, HIN_NR, DEA_NR, 
      CONVERT(DATE,GETDATE()) AS REC_EFF_DT, CONVERT(DATE,'9999-12-31') AS REC_EXP_DT, 'A', 
      DS.CMPNY_SRCE_ID, C.HSPTL_PARENT_ID, C.DHC_NTWRK_ID, C.DHC_NTWRK_PARENT_ID
    FROM STAGE.DHC_COMPANY C
      LEFT JOIN CMPNY.COMPANY_TYPE T ON T.CMPNY_TYP_NM = 'EU'
      LEFT JOIN CMPNY.COMPANY_SEGMENT S ON C.DHC_CO_CAT_CD = S.CMPNY_SGMNT_NM
      LEFT JOIN CMPNY.COMPANY_SUB_SEGMENT SS ON S.CMPNY_SGMNT_ID = SS.CMPNY_SGMNT_ID AND C.DHC_CO_SUB_CAT = SS.CMPNY_SUB_SGMNT_NM
      LEFT JOIN CMPNY.COMPANY_DATA_SOURCE DS ON DS.CMPNY_SRCE_NM = 'DHC';
      
    -- Company segment if not found --   
    DECLARE @sgmnt int;
    SELECT @sgmnt = CMPNY_SGMNT_ID FROM CMPNY.COMPANY_SEGMENT WHERE CMPNY_SGMNT_NM = 'OTHER';
  
    UPDATE cmpny.COMPANY 
      SET CMPNY_SGMNT_ID =@sgmnt 
    WHERE CMPNY_SGMNT_ID IS NULL;
      
      -- LOAD unique address 
      TRUNCATE TABLE MDM_STAGE.CMPNY_ADDR_PARTS;
      
      INSERT INTO MDM_STAGE.CMPNY_ADDR_PARTS
      (ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2)
      SELECT DISTINCT ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2
      FROM MDM_STAGE.DHC_ADDR_PARTS;
    
      
    -- INSERT AND UPDATE THE CROSS REFERENCE TABLE
    TRUNCATE TABLE CMPNY.CMPNY_TO_ADDR_XREF;
    
    INSERT INTO CMPNY.CMPNY_TO_ADDR_XREF
    ( CMPNY_ID, SRC_DATA_ID, ADDR_ID, REC_EFF_DT, REC_EXP_DT, REC_STAT_CD)
    SELECT C.CMPNY_ID, C.SRC_CMPNY_ID, A.CMPNY_ADDR_ID, C.REC_EFF_DT, C.REC_EXP_DT, C.REC_STAT_IN
    FROM CMPNY.COMPANY C
    JOIN MDM_STAGE.CMPNY_ADDR_PARTS A ON C.CMPNY_ADDR_1 = A.ADDR_1 AND C.CMPNY_ADDR_2 = A.ADDR_2;


    -----------------------------------------------
    --- SET PRIMARY COMPANY INDICATOR -------------
    ------------------------------------------------
    
    ---   COMPANY WITH SINGLE EADDRESS 
    UPDATE X SET PRIMARY_CMPNY_IN = 'Y'
    FROM CMPNY.CMPNY_TO_ADDR_XREF X,
    (SELECT X.ADDR_ID, count(*) CNT
    FROM CMPNY.CMPNY_TO_ADDR_XREF X
    GROUP BY X.ADDR_ID
    HAVING COUNT(*) = 1 ) I
    WHERE X.ADDR_ID = I.ADDR_ID ;

    -------------------------------------------------
    -- MULTIPLE COMPANY WITH ONE AS PARENT
    -------------------------------------------------
    
    UPDATE X SET PRIMARY_CMPNY_IN = 'Y'
    FROM  CMPNY.CMPNY_TO_ADDR_XREF X
    JOIN  CMPNY.COMPANY C on X.CMPNY_ID = C.CMPNY_PRNT_ID
    WHERE PRIMARY_CMPNY_IN IS NULL    --- That means multiple facility on same page
    AND C.CMPNY_PRNT_ID IS NOT NULL ;

    -- Now make the other comoanies on that address as not primary
    UPDATE XN SET XN.PRIMARY_CMPNY_IN = 'N'
    FROM  CMPNY.CMPNY_TO_ADDR_XREF XP
    JOIN  CMPNY.CMPNY_TO_ADDR_XREF XN on XP.ADDR_ID = XN.ADDR_ID
    WHERE XP.PRIMARY_CMPNY_IN = 'Y'
    AND XN.PRIMARY_CMPNY_IN IS NULL;

    -----------------------------------------------------------------
    -- BY SEGMENT / ORG TYPE - in order of IDN, HSP, ASC, LTC, OTH, PHYS
    -------------------------------------------------------------------
    
    UPDATE X3 SET PRIMARY_CMPNY_IN = 'X' -- TO SEPARATE THEM FOR NOW, WILL CHANGE TO 'Y'
    FROM CMPNY.CMPNY_TO_ADDR_XREF X3,
    (
      SELECT X2.ADDR_ID , MAX(C2.SRC_CMPNY_ID) SRC_ID
      FROM 
        CMPNY.CMPNY_TO_ADDR_XREF X2,
        (SELECT ADDR_ID, MAX(S.FACILITY_PRIORITY) PRIORITY 
          FROM CMPNY.CMPNY_TO_ADDR_XREF X
          JOIN CMPNY.COMPANY C ON X.CMPNY_ID = C.CMPNY_ID
          JOIN CMPNY.COMPANY_SEGMENT S ON C.CMPNY_SGMNT_ID = S.CMPNY_SGMNT_ID
          WHERE X.PRIMARY_CMPNY_IN IS NULL 
          --AND X.ADDR_ID = 19
          GROUP BY ADDR_ID) I2
      ,CMPNY.COMPANY_SEGMENT S2 
      ,CMPNY.COMPANY C2
      WHERE
          X2.ADDR_ID = I2.ADDR_ID
      AND I2.PRIORITY = S2.FACILITY_PRIORITY
      AND C2.CMPNY_ID = X2.CMPNY_ID 
      AND C2.CMPNY_SGMNT_ID =S2.CMPNY_SGMNT_ID
      GROUP BY X2.ADDR_ID
    ) I3 
    WHERE  
        X3.ADDR_ID = I3.ADDR_ID 
    AND X3.SRC_DATA_ID = I3.SRC_ID 
    AND X3.PRIMARY_CMPNY_IN IS NULL;

    UPDATE XN SET XN.PRIMARY_CMPNY_IN = 'N'
    FROM  CMPNY.CMPNY_TO_ADDR_XREF XP
    JOIN  CMPNY.CMPNY_TO_ADDR_XREF XN on XP.ADDR_ID = XN.ADDR_ID
    WHERE XP.PRIMARY_CMPNY_IN = 'X'
    AND XN.PRIMARY_CMPNY_IN IS NULL;

    UPDATE CMPNY.CMPNY_TO_ADDR_XREF
    SET PRIMARY_CMPNY_IN = 'Y' WHERE PRIMARY_CMPNY_IN = 'X';
    
    ----------------------------------
    -- HIGHEST HOSPITAL ID
    ---------------------------------
    /*
    UPDATE X SET PRIMARY_CMPNY_IN = 'X' -- TO SEPARATE THEM FOR NOW, WILL CHANGE TO 'Y'
    FROM CMPNY.CMPNY_TO_ADDR_XREF X,
    (SELECT ADDR_ID, MAX(SRC_DATA_ID) SRC_ID  
    FROM CMPNY.CMPNY_TO_ADDR_XREF
    GROUP BY ADDR_ID) I
    WHERE X.ADDR_ID = I.ADDR_ID AND X.SRC_DATA_ID = I.SRC_ID 
    AND X.PRIMARY_CMPNY_IN IS NULL;

    UPDATE XN SET XN.PRIMARY_CMPNY_IN = 'N'
    FROM  CMPNY.CMPNY_TO_ADDR_XREF XP
    JOIN  CMPNY.CMPNY_TO_ADDR_XREF XN on XP.ADDR_ID = XN.ADDR_ID
    WHERE XP.PRIMARY_CMPNY_IN = 'X'
    AND XN.PRIMARY_CMPNY_IN IS NULL;

    UPDATE CMPNY.CMPNY_TO_ADDR_XREF
    SET PRIMARY_CMPNY_IN = 'Y' WHERE PRIMARY_CMPNY_IN = 'X';

    */
 
  END