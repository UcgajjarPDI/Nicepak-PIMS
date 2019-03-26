CREATE PROCEDURE [STAGE].[spDHC_NAME_LAUNDRY]
WITH EXEC AS CALLER
AS
BEGIN  
 
 TRUNCATE TABLE MDM_STAGE.TEMP_NM_LAUNDRY;
 
 INSERT INTO MDM_STAGE.TEMP_NM_LAUNDRY ( SRC_ID, ORIG_NM  )
 SELECT DHC_CO_ID, DHC_CO_NM_1 FROM STAGE.DHC_COMPANY;
  
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      UPD_NM = CASE
        WHEN CHARINDEX('(aka', ORIG_NM ) > 0 THEN
          LEFT(ORIG_NM ,CHARINDEX('(aka', ORIG_NM )-2)  
        WHEN CHARINDEX('(fka', ORIG_NM ) > 0 THEN
          LEFT(ORIG_NM ,CHARINDEX('(fka', ORIG_NM )-2)   
        ELSE ORIG_NM  END,
      ALT_NM = CASE 
        WHEN CHARINDEX('(aka', ORIG_NM ) > 0 THEN  
          SUBSTRING(ORIG_NM ,CHARINDEX('(aka', ORIG_NM )+5,LEN(ORIG_NM )-CHARINDEX('(aka', ORIG_NM )-5) 
        WHEN CHARINDEX('(fka', ORIG_NM ) > 0 THEN
          SUBSTRING(ORIG_NM ,CHARINDEX('(fka', ORIG_NM )+5,LEN(ORIG_NM )-CHARINDEX('(fka', ORIG_NM )-5)
        ELSE NULL END,
      ALT_NM_TYP = CASE 
        WHEN CHARINDEX('(aka', ORIG_NM ) > 0 THEN 'AKA'  
        WHEN CHARINDEX('(fka', ORIG_NM ) > 0 THEN 'FKA'
        ELSE NULL END
    WHERE (ORIG_NM  LIKE '%(aka%' OR ORIG_NM  LIKE '%(fka%' );

    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      --DHC_STAT = CASE WHEN CHARINDEX('(Closed', ORIG_NM ) > 0 THEN 'Closed' ELSE NULL END,
      UPD_NM = LEFT(ORIG_NM ,CHARINDEX('(', ORIG_NM )-2)
    WHERE 
      (ORIG_NM  LIKE '%(closed%' OR 
      ORIG_NM  LIKE '%(Opening%' OR 
      ORIG_NM  LIKE '%(Closing%');


-- This will fix Acquired by, to retain both names
 --   UPD_NM
 --   ALT_NM
  --  ALT_NM_TYP 

    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      UPD_NM = LEFT(ORIG_NM,CHARINDEX('(', ORIG_NM)-2),
      ALT_NM= SUBSTRING(ORIG_NM,CHARINDEX('Acquired by', ORIG_NM)+11,LEN(ORIG_NM)-CHARINDEX('Acquired by', ORIG_NM)-11) , 
      ALT_NM_TYP = 'Acquired'    
    WHERE 
    ORIG_NM LIKE '%Acquired by%'
    AND UPD_NM IS NULL;
    
    
    -- This will fix Merged with, to retain both names
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      UPD_NM = dbo.fnInit(LEFT(ORIG_NM,CHARINDEX('(', ORIG_NM)-2)),
      ALT_NM = dbo.fnInit(SUBSTRING(ORIG_NM,CHARINDEX('Merged with', ORIG_NM)+11,LEN(ORIG_NM)-CHARINDEX('Merged with', ORIG_NM)-11) ), 
      ALT_NM_TYP = 'Merged'    
    WHERE 
    ORIG_NM LIKE '%Merged with%'
    AND UPD_NM IS NULL;
    
    -- This will get rid of the (Closed - no longer  . . 
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      UPD_NM = dbo.fnInit(LEFT(ORIG_NM,CHARINDEX('(', ORIG_NM)-2)),
      ALT_NM = 'Closed'    
    WHERE 
    CHARINDEX('(Closed', ORIG_NM) > 0
    AND UPD_NM IS NULL;

    
-- cleanse issue ith VA
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET 
      ALT_NM_TYP = CASE WHEN CHARINDEX('VA ', ORIG_NM) > 0 THEN 'VA Affiliate' ELSE NULL END,
      UPD_NM = LEFT(ORIG_NM,CHARINDEX('(', ORIG_NM)-2),
      ALT_NM = SUBSTRING(ORIG_NM,CHARINDEX('(', ORIG_NM)+1,LEN(ORIG_NM)-CHARINDEX('(', ORIG_NM)-1)
    WHERE ORIG_NM LIKE '%(%'
    AND UPD_NM IS NULL;

    -- Correct the rest
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET UPD_NM = ORIG_NM
    WHERE UPD_NM IS NULL;
    
    -- Take out the LLC, INC from end 
    UPDATE T
    SET UPD_NM = RTRIM(LEFT(UPD_NM , LEN(UPD_NM)-LEN(A.ADDR_VAR)-1))
    FROM MDM_STAGE.TEMP_NM_LAUNDRY T
    JOIN REF.ADDR_STD A ON A.ADDR_VAR = STAGE.fnLastWord(UPD_NM) AND ADDR_TYP = 'NAME' AND CAT = 'REMOVE' AND REC_ACT_IN = 'Y' ;
    

    
    
    -- IF ETL dropped any zero --
    -- MOVE IT TO ADDR CLEANSING
    /*
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY
    SET DHC_CO_ZIP = CASE WHEN LEN(DHC_CO_ZIP)=4 THEN '0'+DHC_CO_ZIP 
                          WHEN LEN(DHC_CO_ZIP)=3 THEN '00'+DHC_CO_ZIP 
                          WHEN LEN(LTRIM(RTRIM(DHC_CO_ZIP)))>5 THEN LEFT(LTRIM(RTRIM(DHC_CO_ZIP)),5)
                          ELSE DHC_CO_ZIP
                          END;
    
   
 ---------------------------
 --- duplicate companies
 ---------------------------
    
      -- REMOVE (ST) from names, susch 'Mercy (FL)' to 'Mercy'
  UPDATE MDM_STAGE.TEMP_NM_LAUNDRY 
  SET DHC_CO_NM_1 = dbo.fnRemoveSpace(REPLACE(DHC_CO_NM_1, '('+DHC_CO_ST+')' ,''))
  WHERE DHC_CO_NM_1 like '%('+DHC_CO_ST+')%' ;
    
        -- If there is any invalid zip code in the DHC file, raise an issue
    
    UPDATE MDM_STAGE.TEMP_NM_LAUNDRY 
    SET ISSUE_FLG = NULL;
    
    UPDATE C
    SET C.ISSUE_FLG = 'Invalid ZIP'
    FROM MDM_STAGE.TEMP_NM_LAUNDRY C
    LEFT JOIN REF.ZIP_CODE Z ON C.DHC_CO_ZIP = Z.Zipcode
    WHERE Z.Zipcode IS NULL;
     */
  END;