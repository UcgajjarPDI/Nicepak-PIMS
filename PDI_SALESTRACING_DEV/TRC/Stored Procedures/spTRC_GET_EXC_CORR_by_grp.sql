CREATE PROCEDURE [TRC].[spTRC_GET_EXC_CORR_by_grp] @vCNT_ID  VARCHAR(30) = NULL, 
                                                  @vPROD_ID VARCHAR(15) = NULL
WITH EXEC AS CALLER
AS
    BEGIN
        SELECT DISTINCT 
               CN.GROUP_NAME, 
               CN.CONTRACT_NO, 
               C.ITEMID, 
			   CONVERT(char(10), C.[Exp Date],126) AS EXP_DT, 
               'Description' AS CNT_DES,
			   CN.TIER_LEVEL
        FROM PDI_SALESTRACING_DEV.STAGE.CONT_PRICE C, 
             [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] CO, 
             [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] CN
        WHERE(CO.CONTRACT_NO = @vCNT_ID
              AND CO.CURRENT_INDICATOR = 'Y')
             AND (CN.GROUP_NAME = CO.GROUP_NAME
                  AND CN.CURRENT_INDICATOR = 'Y')
             AND C.[Contract ID] = CN.CONTRACT_NO
             AND C.ITEMID = @vPROD_ID
			 and  CN.CONTRACT_NO != @vCNT_ID
        --AND C.[Exp Date] > '2018-09-01'    -- Hard coded - should be earliest inv date @INVDATE from last page

    END;