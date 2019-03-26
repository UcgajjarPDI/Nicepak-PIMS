-- =============================================
-- Author:Krunal Trivedi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CONT].[INSERT_CONT_PRODID]
(@CNT_NR [varchar](20),
@PROD_EFF_DT date,
@PROD_EXP_DT date,
@prod_prc decimal(18, 2),
@prod_ID varchar(20),
@rationale varchar(500)
)
AS
BEGIN
	insert into [CONT].[CNT_PROD](
	[PROD_ID],
	[PROD_EFF_DT],
	[PROD_EXP_DT],
   PROD_EFF_DT_NR, 
   PROD_EXP_DT_NR,
	[PROD_PRC],
	[PROD_STAT_CD],
	[CNT_NR],
   REC_EFF_DT, REC_EXP_DT, REC_STAT_CD, PROD_UOM
	)
	select 
  @prod_ID,
  @PROD_EFF_DT,
  @PROD_EXP_DT,
  YEAR(@PROD_EFF_DT)*10000+MONTH(@PROD_EFF_DT)*100+DAY(@PROD_EFF_DT) AS PROD_EFF_DT_NR,
  YEAR(@PROD_EXP_DT)*10000+MONTH(@PROD_EXP_DT)*100+DAY(@PROD_EXP_DT) AS PROD_EXP_DT_NR,
  @prod_prc,
  'P',
  @CNT_NR,
  convert(DATE,GETDATE()) AS REC_EFF_DT, 
  convert(DATE,'9999-12-31') AS PROD_EXP_DT_NR,
  'A','CS'

  exec [CNT].[spSAVE_PROD_RATIONALE]  @CNT_NR, @prod_ID, @rationale

END