-- =============================================
-- Author:		Krunal Trivedi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CONT].[UPDATE_CONT_PRODID]

(@CNT_NR [varchar](20),
@PROD_EFF_DT date,
@PROD_EXP_DT date,
@prod_prc [decimal](18, 2),
@prod_ID [varchar](20)
)
	as
BEGIN
	update [CONT].[CNT_PROD]
	set [PROD_EFF_DT]=@PROD_EFF_DT,[PROD_EXP_DT]=@PROD_EXP_DT,[PROD_PRC]=@prod_prc
	where [CNT_NR]=@CNT_NR and [PROD_ID]=@prod_ID and [PROD_STAT_CD]='p'

END
