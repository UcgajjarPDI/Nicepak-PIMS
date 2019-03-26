﻿CREATE PROCEDURE [PCM].[spSubmit_Request]
@CNT_NR varchar(20), @UNM varchar(20)
WITH EXEC AS CALLER
AS
BEGIN

  DECLARE @NewID VARCHAR(20); declare @Rec_Cnt int;

  SELECT @Rec_Cnt = COUNT(*) FROM [PCM].[PCM_CONT_PND] ;
  set @NewID = 'CNT'+LTRIM(STR(@Rec_Cnt+5000))+LTRIM('P')
  
  INSERT INTO [PCM].[PCM_CONT_PND]
  (CNT_NR, INIT_USR_NM, CNT_INIT_DT, CNT_RVW_DL_DT, CNT_TYP_CD, CNT_STAT_CD, PDI_GROUP_ID)
  SELECT 
    @NewID, @UNM,
    CONVERT(VARCHAR(10),GETDATE(),101) AS INIT_DT, 
    CONVERT(VARCHAR(10),DATEADD(D,90,GETDATE()),101) AS RVW_DL_DT,
    'SPR', 'Pending Review', C.PDI_GROUP_ID
  FROM PCM.PCM_CONTRACT C
  WHERE C.CNT_NR = @CNT_NR
  
    /*
  INSERT INTO PCM.PCM_CNT_PND_ITM
  (CNT_NR, ITM_NR, ITM_PRC, CREATE_DTTS)
  VALUES()

    */
  
END