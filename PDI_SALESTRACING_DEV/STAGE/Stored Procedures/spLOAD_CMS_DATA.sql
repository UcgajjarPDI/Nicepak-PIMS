CREATE PROCEDURE [STAGE].[spLOAD_CMS_DATA]
WITH EXEC AS CALLER
AS
BEGIN  

--  EMPTY THE TABLE
  TRUNCATE TABLE MDM_STAGE.CMS_COMPANY

  DELETE FROM STAGE.CMS_DATALOAD
  WHERE [Entity Type Code] IS NULL;


  INSERT INTO MDM_STAGE.CMS_COMPANY
  ( SRC_CMPNY_ID, CMPNY_NM, CMPNY_ALT_NM, ALT_NM_TYP, CMPNY_ADDR_1, CMPNY_ADDR_2, CMPNY_CITY, CMPNY_ST, CMPNY_ZIP, CMPNY_CNTRY, CMPNY_TYP_ID, REC_EFF_DT, NPI_NR)
  SELECT 
  NPI, 
   [Provider Organization Name (Legal Business Name)] AS CMPNY_NM,
   [Provider Other Organization Name] AS CMPNY_ALT_NM,
  [Provider Other Organization Name Type Code],
  [Provider First Line Business Practice Location Address], 
  [Provider Second Line Business Practice Location Address],
  [Provider Business Practice Location Address City Name], 
  [Provider Business Practice Location Address State Name], 
  LEFT([Provider Business Practice Location Address Postal Code],5) CMPNY_ZIP, 
  [Provider Business Practice Location Address Country Code (If outside U.S.)] ,
  [Entity Type Code], [Last Update Date],
  NPI
  FROM STAGE.CMS_DATALOAD
  WHERE [Entity Type Code] = '2'
  AND LEN([Provider Business Practice Location Address State Name]) = 2
  AND [Provider Business Practice Location Address Postal Code] is not null;


  INSERT INTO MDM_STAGE.CMS_COMPANY
  ( SRC_CMPNY_ID, CMPNY_NM, CMPNY_ADDR_1, CMPNY_ADDR_2, CMPNY_CITY, CMPNY_ST, CMPNY_ZIP, CMPNY_CNTRY, CMPNY_TYP_ID, LAST_NAME, FIRST_NAME, 
  MIDDLE_NAME, MI, 
  SUFFIX, REC_EFF_DT, NPI_NR)
  SELECT --TOP 100
  NPI, 
  [Provider First Name] +' '+[Provider Last Name (Legal Name)] AS CMPNY_NM,
  [Provider First Line Business Practice Location Address] as CMPNY_ADDR_1, 
  [Provider Second Line Business Practice Location Address] as CMPNY_ADDR_2,
  [Provider Business Practice Location Address City Name] CMPNY_CITY, 
  [Provider Business Practice Location Address State Name] CMPNY_ST, 
  LEFT([Provider Business Practice Location Address Postal Code],5) CMPNY_ZIP, 
  [Provider Business Practice Location Address Country Code (If outside U.S.)] CMPNY_CNTRY,
  [Entity Type Code] CMPNY_TYP_ID,  [Provider Last Name (Legal Name)], [Provider First Name], 
  [Provider Middle Name], LEFT([Provider Middle Name], 1) MI,
  [Provider Credential Text] SUFFIX,
  [Last Update Date], NPI
  FROM STAGE.CMS_DATALOAD
  WHERE [Entity Type Code] = '1'
  AND LEN([Provider Business Practice Location Address State Name]) = 2
  AND [Provider Business Practice Location Address Postal Code] is not null
  AND [Provider Last Name (Legal Name)] NOT LIKE '%,%';

  -- LATER TO CREATE ALTERNATE NAME
  --[Provider First Name] +' '+ (CASE WHEN [Provider Middle Name] IS NOT NULL THEN [Provider Middle Name]+' ' ELSE '' END)+ [Provider Last Name (Legal Name)] AS CMPNY_ALT_NM,
  --'M.I.',
  

  
  --- ADDRESS CLEAN --
  
  INSERT INTO MDM_STAGE.TEMP_ADDR ( SRC_ID, ADDR_1, ADDR_2)
  SELECT SRC_CMPNY_ID, CMPNY_ADDR_1, CMPNY_ADDR_2
  FROM MDM_STAGE.CMS_COMPANY;
  
  select max(len(CMPNY_ADDR_1)) from MDM_STAGE.CMS_COMPANY
  
  EXEC [STAGE].[spADDR_LAUNDRY];
  
  TRUNCATE TABLE MDM_STAGE.CMS_ADDR_PARTS;
  
  INSERT INTO MDM_STAGE.CMS_ADDR_PARTS ( 
    SRC_ID, ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2  )
  SELECT 
    SRC_ID, ST_NR, ST_NM, ST_TYP, ST_DIR, ST_NR_2, BLDG_NR, FL_NR, STE_NR, DIR_1, ADDR_1, ADDR_2  
  FROM MDM_STAGE.TEMP_ADDR_PARTS
  ;  
  
  UPDATE C
    SET CMPNY_ADDR_1 = A.ADDR_1, CMPNY_ADDR_2 =  A.ADDR_2
  FROM MDM_STAGE.CMS_COMPANY C
  JOIN MDM_STAGE.TEMP_ADDR_PARTS A ON C.SRC_CMPNY_ID = A.SRC_ID;
  
  TRUNCATE TABLE  MDM_STAGE.TEMP_ADDR_PARTS;
  TRUNCATE TABLE  MDM_STAGE.TEMP_ADDR;
  
  UPDATE C SET
    C.CMPNY_CITY = Z.City
  from MDM_STAGE.CMS_COMPANY C
  JOIN REF.ZIP_CODE Z ON C.CMPNY_ZIP = Z.Zipcode
  WHERE  Z.LocationType = 'PRIMARY'
  AND Z.City <> C.CMPNY_CITY;
  
  
  END;