CREATE PROCEDURE [TRC].[spTRC_GET_EXC_CORR]
@vCNT_ID varchar(30) = null, @vPROD_ID varchar(15) = null
WITH EXEC AS CALLER
AS
BEGIN

  SELECT DISTINCT TOP 10  -- HARD CODED - Need to evaluate if this is necessary or not
    D.GROUP_NAME, D.CONTRACT_NO, C.ITEMID, C.[Exp Date] AS EXP_DT, 'Description' AS CNT_DES
  FROM 
    PDI_SALESTRACING_DEV.STAGE.CONT_PRICE C
    JOIN [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] D ON C.[Contract ID] = D.CONTRACT_NO AND D.CURRENT_INDICATOR = 'Y'
  WHERE  
    C.ITEMID = 'A500F48' -- @vPROD_ID
    AND C.[Exp Date] > '2018-09-01'    -- Hard coded - should be earliest inv date @INVDATE from last page

END