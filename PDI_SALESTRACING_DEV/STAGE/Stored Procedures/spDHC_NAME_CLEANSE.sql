CREATE PROCEDURE [STAGE].[spDHC_NAME_CLEANSE]
WITH EXEC AS CALLER
AS
BEGIN  
 
  UPDATE STAGE.DHC_COMPANY SET DHC_CO_NM_1 = ORIG_NM;
  
  -- REMOVE (ST) from names, susch 'Mercy (FL)' to 'Mercy'
  UPDATE STAGE.DHC_COMPANY 
  SET DHC_CO_NM_1 = dbo.fnRemoveSpace(REPLACE(DHC_CO_NM_1, '('+DHC_CO_ST+')' ,''))
  WHERE DHC_CO_NM_1 like '%('+DHC_CO_ST+')%' ;

    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_CO_NM_1 = CASE
        WHEN CHARINDEX('(aka', DHC_CO_NM_1) > 0 THEN
          LEFT(DHC_CO_NM_1,CHARINDEX('(aka', DHC_CO_NM_1)-2)  
        WHEN CHARINDEX('(fka', DHC_CO_NM_1) > 0 THEN
          LEFT(DHC_CO_NM_1,CHARINDEX('(fka', DHC_CO_NM_1)-2)   
        ELSE DHC_CO_NM_1 END,
      DHC_CO_NM_2 = CASE 
        WHEN CHARINDEX('(aka', DHC_CO_NM_1) > 0 THEN  
          SUBSTRING(DHC_CO_NM_1,CHARINDEX('(aka', DHC_CO_NM_1)+5,LEN(DHC_CO_NM_1)-CHARINDEX('(aka', DHC_CO_NM_1)-5) 
        WHEN CHARINDEX('(fka', DHC_CO_NM_1) > 0 THEN
          SUBSTRING(DHC_CO_NM_1,CHARINDEX('(fka', DHC_CO_NM_1)+5,LEN(DHC_CO_NM_1)-CHARINDEX('(fka', DHC_CO_NM_1)-5)
        ELSE NULL END,
      DHC_CO_NM_2_TYP = CASE 
        WHEN CHARINDEX('(aka', DHC_CO_NM_1) > 0 THEN 'AKA'  
        WHEN CHARINDEX('(fka', DHC_CO_NM_1) > 0 THEN 'FKA'
        ELSE NULL END
    WHERE DHC_CO_NM_1 LIKE '%(aka%' OR DHC_CO_NM_1 LIKE '%(fka%' 
    AND DHC_CO_NM_2 IS NULL;

    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_STAT = CASE WHEN CHARINDEX('(Closed', DHC_CO_NM_1) > 0 THEN 'Closed' ELSE NULL END,
      DHC_CO_NM_1 = LEFT(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)-2)
    WHERE 
      (DHC_CO_NM_1 LIKE '%(closed%' OR 
      DHC_CO_NM_1 LIKE '%(Opening%' OR 
      DHC_CO_NM_1 LIKE '%(Closing%')
    AND DHC_CO_NM_2 IS NULL;


-- This will fix Acquired by, to retain both names

    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_CO_NM_1 = LEFT(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)-2),
      DHC_CO_NM_2 = SUBSTRING(DHC_CO_NM_1,CHARINDEX('Acquired by', DHC_CO_NM_1)+11,LEN(DHC_CO_NM_1)-CHARINDEX('Acquired by', DHC_CO_NM_1)-11) , 
      DHC_CO_NM_2_TYP = 'Acquired'    
    WHERE 
    DHC_CO_NM_1 LIKE '%Acquired by%'
    AND DHC_CO_NM_2 IS NULL;
    
    -- This will fix Merged with, to retain both names
    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_CO_NM_1 = dbo.fnInit(LEFT(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)-2)),
      DHC_CO_NM_2 = dbo.fnInit(SUBSTRING(DHC_CO_NM_1,CHARINDEX('Merged with', DHC_CO_NM_1)+11,LEN(DHC_CO_NM_1)-CHARINDEX('Merged with', DHC_CO_NM_1)-11) ), 
      DHC_CO_NM_2_TYP = 'Merged'    
    WHERE 
    DHC_CO_NM_1 LIKE '%Merged with%'
    AND DHC_CO_NM_2 IS NULL;
    
    -- This will get rid of the (Closed - no longer  . . 
    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_CO_NM_1 = dbo.fnInit(LEFT(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)-2)),
      DHC_CO_NM_2_TYP = 'Closed'    
    WHERE 
    CHARINDEX('(Closed', DHC_CO_NM_1) > 0
    AND DHC_CO_NM_2 IS NULL;

    
    
-- Cleanse issue ith VA
    UPDATE STAGE.DHC_COMPANY
    SET 
      DHC_CO_NM_2_TYP = CASE WHEN CHARINDEX('VA ', DHC_CO_NM_1) > 0 THEN 'VA Affiliate' ELSE NULL END,
      DHC_CO_NM_1 = LEFT(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)-2),
      DHC_CO_NM_2 = SUBSTRING(DHC_CO_NM_1,CHARINDEX('(', DHC_CO_NM_1)+1,LEN(DHC_CO_NM_1)-CHARINDEX('(', DHC_CO_NM_1)-1)
    WHERE DHC_CO_NM_1 LIKE '%(%'
    AND DHC_CO_NM_2 IS NULL;


  END;