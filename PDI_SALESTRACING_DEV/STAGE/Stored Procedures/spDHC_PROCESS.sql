create PROCEDURE [STAGE].[spDHC_PROCESS]

WITH EXEC AS CALLER
AS
BEGIN  


-------------  ADDRESS PROCESS -----------
  -- Load Addresss Data
  INSERT INTO MDM_STAGE.TEMP_ADDR (SRC_ID, ADDR_1, ADDR_2 )
  SELECT DHC_CO_ID, DHC_CO_ADDR_1, DHC_CO_ADDR_2 
  FROM STAGE.DHC_COMPANY

  -- Process Address -- This will have clean address in the 'TEMP_ADDR_PARTS table
  EXEC [STAGE].[spADDR_LAUNDRY];
  
  -- Load unique address into the CMPNY_address_table
  
  -- Then create the xref table with primary and other address status

END