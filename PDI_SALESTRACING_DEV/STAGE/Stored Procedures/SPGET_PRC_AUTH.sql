-- =============================================
-- Author:	 KRUNAL TRIVEDI
-- Create date: 12/19/2018
-- Description:	PRICE AUTHORIZATION aggregate
-- =============================================
CREATE PROCEDURE [STAGE].[SPGET_PRC_AUTH]	
	
	
AS
BEGIN

	SET NOCOUNT ON;
	INSERT INTO [STAGE].[PRC_AUTH1]
           ([GPO_NM]
           ,[GPO_MBR_ID]
           ,[GPO_MBR_NM]
           ,[GPO_MBR_ADDR1]
           ,[GPO_MBR_ADDR2]
           ,[GPO_MBR_CITY]
           ,[GPO_MBR_ST]
           ,[GPO_MBR_ZIP]
           ,[GPO_CNT_NR]
           ,[MFG_CNT_NR]
           ,[TIER_NR]
           ,[TIER_DESC]
           ,[PRC_EFF_DT]
           ,[PRC_EXP_DT]
           ,[IDN_NM]
           ,[DIST_NM_1]
           ,[DIST_NM_2]
           ,[PRC_ACT_NR]
           ,[LIC_NR]
           ,[PRC_ACT_DT]
           ,[STATUS]
           ,[SRC_REC_ID]
           ,[DEA]
           ,[GLN]
           ,[HIN]
           ,[SEGMENT]
           )
   

SELECT 
      left ([GPO_NM],15)
      ,left ([GPO_MBR_ID],15)
      ,left ([GPO_MBR_NM],250)
      ,left ([GPO_MBR_ADDR1],250)
      ,left ([GPO_MBR_ADDR2],250)
      ,left ([GPO_MBR_CITY],50)
      ,left ([GPO_MBR_ST],50)
      ,left ([GPO_MBR_ZIP],5)
      ,left ([GPO_CNT_NR],15)
      ,left ([MFG_CNT_NR],15)
      ,isnull ([TIER_NR],isnull(try_convert(int,case when CHARINDEX('Grandfathered',[TIER_DESC])>0 then '6'else substring([TIER_DESC],CHARINDEX('TIER',[TIER_DESC])+5,1)end),'99')) 
      ,left ([TIER_DESC],250)
      ,try_convert(date,[PRC_EFF_DT])
      ,try_convert(date,[PRC_EXP_DT])
      ,left ([IDN_NM],250)
      ,left ([DIST_NM_1],250)
      ,left ([DIST_NM_2],250)
      ,left([PRC_ACT_NR],50)
      ,left([LIC_NR],10)
      ,try_convert(date,[PRC_ACT_DT])
      ,left([STATUS],20)
      ,left([SRC_REC_ID],15)
      ,left([DEA],50)
      ,left([GLN],50)
      ,left([HIN],50)
      ,left([SEGMENT],50)
  FROM [PDI_SALESTRACING_DEV].[STG0].[PRC_AUTH]
----------------------------------------------------------------------------------------------------------------------------------------------------------------


update u
set u.MFG_CNT_NR=s.MFG_CNT_NR , U.TIER_NR=S.TIER_NR


from [STAGE].[PRC_AUTH1] u
inner join stg0.premier_cont_ref s on
u.GPO_CNT_NR=s.GPO_CNT_NR 
              AND U.GPO_NM='PREMIER' AND U.[TIER_DESC]=S.[TIER_DESC]



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#PRC_AUTH') IS NOT NULL DROP TABLE #PRC_AUTH

--DROP TABLE  #PRC_AUTH

CREATE TABLE #PRC_AUTH
(
PRC_AUTH_ID INT NULL,
[GPO_NM] [varchar](15) NULL,
	[GPO_MBR_ID] [varchar](15) NULL,
	[GPO_MBR_NM] [varchar](250) NULL,
	[GPO_MBR_ADDR1] [varchar](250) NULL,
	[GPO_MBR_ADDR2] [varchar](250) NULL,
	[GPO_MBR_CITY] [varchar](50) NULL,
	[GPO_MBR_ST] [varchar](50) NULL,
	[GPO_MBR_ZIP] [varchar](5) NULL,
	[GPO_CNT_NR] [varchar](15) NULL,
	[MFG_CNT_NR] [varchar](15) NULL,
	[TIER_NR] [int] NULL,
	[TIER_DESC] [varchar](250) NULL,
	[PRC_EFF_DT] [date] NULL,
	[PRC_EXP_DT] [date] NULL,
	[IDN_NM] [varchar](250) NULL,
	[DIST_NM_1] [varchar](250) NULL,
	[DIST_NM_2] [varchar](250) NULL,
	[PRC_ACT_NR] [varchar](50) NULL,
	[LIC_NR] [varchar](10) NULL,
	[PRC_ACT_DT] [date] NULL,
	[STATUS] [varchar](20) NULL,
	[SRC_REC_ID] [varchar](15) NULL,
	[DEA] [varchar](50) NULL,
	[GLN] [varchar](50) NULL,
	[HIN] [varchar](50) NULL,
	[SEGMENT] [varchar](50) NULL,
	[REC_STAT] [char](1) NULL,
	[REC_EFF_DT]  [date] NULL,
	[REC_EXP_DT]  [date] NULL

)

INSERT INTO #PRC_AUTH(  PRC_AUTH_ID,GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, GPO_CNT_NR, MFG_CNT_NR, TIER_NR, TIER_DESC, PRC_EFF_DT, PRC_EXP_DT, IDN_NM, DIST_NM_1, DIST_NM_2, PRC_ACT_NR, LIC_NR, PRC_ACT_DT, STATUS, SRC_REC_ID, DEA, GLN, HIN, SEGMENT, REC_STAT, REC_EFF_DT, REC_EXP_DT )
SELECT DISTINCT  T.PRC_AUTH_ID, T.GPO_NM, T.GPO_MBR_ID, T.GPO_MBR_NM, T.GPO_MBR_ADDR1, T.GPO_MBR_ADDR2, T.GPO_MBR_CITY, T.GPO_MBR_ST, T.GPO_MBR_ZIP, T.GPO_CNT_NR, T.MFG_CNT_NR, T.TIER_NR, T.TIER_DESC, T.PRC_EFF_DT, T.PRC_EXP_DT, T.IDN_NM, T.DIST_NM_1, T.DIST_NM_2, T.PRC_ACT_NR, T.LIC_NR, T.PRC_ACT_DT, T.STATUS, T.SRC_REC_ID, T.DEA, T.GLN, T.HIN, T.SEGMENT, T.REC_STAT, T.REC_EFF_DT, T.REC_EXP_DT FROM STAGE.PRC_AUTH1 T,
(SELECT GPO_NM, GPO_MBR_ID,min(PRC_EFF_DT) as PRC_EFF_DT
FROM STAGE.PRC_AUTH1
GROUP BY GPO_NM, GPO_MBR_ID, mfg_cnt_NR) I

WHERE T.GPO_NM = I.GPO_NM AND T.PRC_EFF_DT = I.PRC_EFF_DT AND T.GPO_MBR_ID = I.GPO_MBR_ID

AND T.PRC_EXP_DT >= TRY_CONVERT(DATE,'09/30/2018')


TRUNCATE TABLE STAGE.PRC_AUTH1

INSERT INTO STAGE.PRC_AUTH1 (GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, GPO_CNT_NR, MFG_CNT_NR, TIER_NR, TIER_DESC, PRC_EFF_DT, PRC_EXP_DT, IDN_NM, DIST_NM_1, DIST_NM_2, PRC_ACT_NR, LIC_NR, PRC_ACT_DT, STATUS, SRC_REC_ID, DEA, GLN, HIN, SEGMENT,REC_STAT)
SELECT GPO_NM, GPO_MBR_ID, GPO_MBR_NM, GPO_MBR_ADDR1, GPO_MBR_ADDR2, GPO_MBR_CITY, GPO_MBR_ST, GPO_MBR_ZIP, GPO_CNT_NR, MFG_CNT_NR, TIER_NR, TIER_DESC, PRC_EFF_DT, PRC_EXP_DT, IDN_NM, DIST_NM_1, DIST_NM_2, PRC_ACT_NR, LIC_NR, PRC_ACT_DT, STATUS, SRC_REC_ID, DEA, GLN, HIN, SEGMENT,REC_STAT

FROM #PRC_AUTH



  
END
