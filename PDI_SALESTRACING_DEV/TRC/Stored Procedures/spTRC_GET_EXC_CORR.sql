CREATE PROCEDURE [TRC].[spTRC_GET_EXC_CORR] @vCNT_ID  VARCHAR(30) = NULL, 
                                           @vPROD_ID VARCHAR(15) = NULL
WITH EXEC AS CALLER
AS
    BEGIN
        SELECT DISTINCT TOP 10  
        D.GROUP_NAME, 
        D.CONTRACT_NO, 
        C.ITEMID, 
        CONVERT(CHAR(10), C.[Exp Date], 126) AS EXP_DT, 
        'Description' AS CNT_DES, 
        D.TIER_LEVEL
        FROM PDI_SALESTRACING_DEV.STAGE.CONT_PRICE C
             JOIN [PDI_SALESTRACING_DEV].[STAGE].[DIM_CONTRACT] D ON C.[Contract ID] = D.CONTRACT_NO
                                                                     AND D.CURRENT_INDICATOR = 'Y'
        WHERE C.ITEMID = @vPROD_ID
              AND C.[Exp Date] > '2018-09-01'    
			  AND C.[Contract ID] != @vCNT_ID
    END;