CREATE PROCEDURE [PCM].[spPCM_Prod_Pricing] (
@CNT_NR VARCHAR(20), @UNM Varchar(20),
@Initiator varchar(50) output, @Org_Role varchar(50) output,
@Region varchar(50) output, @RD varchar(50) output,
@BG_NM varchar(150) output, @BG_Addr varchar(150) output, 
@BG_CITY_ST varchar(150) output
)
WITH EXEC AS CALLER
AS
BEGIN

DECLARE @TERRID VARCHAR(10);

  SELECT C.CNT_NR, P.PRODUCT, P.PRODUCT_DESC,   
  I.ITM_PRC AS CURR_PRC, P.LIST_PRICE, I.CURR_VOL, P.ASP6, P.ASP12, P.VIZ_PRC, P.AMERI_TIER_1, P.AMERI_TIER_2, P.HPG_PRC
  FROM PCM.PCM_CONTRACT C
  JOIN PCM.PCM_CNT_ITEM I ON I.CNT_NR = C.CNT_NR
  JOIN PCM.PCM_PROD_PRC P ON P.PRODUCT = I.ITM_NR
  WHERE C.CNT_NR = @CNT_NR 
  
  Select @TERRID = U.TERR_ID FROM PCM.PCM_USER U WHERE USR_LOGIN_NM = @UNM
  IF @TERRID = 'NA'
    BEGIN
      Select DISTINCT 
        @Initiator = U.USR_FULL_NM,  @Org_Role = U.ORG_ROLE,  @Region = '', @RD =''
        FROM PCM.PCM_USER U
        WHERE USR_LOGIN_NM = @UNM;
    END
  ELSE
    BEGIN
        Select DISTINCT 
        @Initiator = U.USR_FULL_NM, @Org_Role = U.ORG_ROLE,  @RD ='Regional Director: '+ T.RD_NAME,  @Region='Region: '+ T.REGION_NAME
        FROM PCM.PCM_USER U
        JOIN PDI_SALESTRACING.REPORT.DIM_TERRITORY T ON U.TERR_ID = T.TERRITORY_ID
        WHERE T.CURRENT_INDICATOR_YN = 'Y'
        AND USR_LOGIN_NM = @UNM;
    END
  
  SELECT @BG_NM = G.GRP_SHRT_NM, @BG_Addr = G.Address1, @BG_CITY_ST = (G.City+', '+G.State+', '+G.Zip)
  FROM PCM.PCM_CONTRACT C
  JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID
  WHERE C.CNT_NR = @CNT_NR
  
END