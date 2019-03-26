
CREATE PROCEDURE [CNT].[spGET_CONTRACT_DETAILS_BY_NUMBER] --'CNT6030'
	  @name varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;

	Select  ctr.CONTRACT_ID_PK 		as CntId,
			ctr.REC_EFF_DT 		 as RecEffDate,
			ctr.REC_EXP_DT 		as RecExpDate,
			ctr.REC_STAT_CD 		as RecStatCd,
			ctr.CNT_NR 			as CntNr,
			ctr.CNT_EFF_DT 		as CntEffDate,
			ctr.CNT_EXP_DT 		as CntExpDate,
			ctr.CNT_TYP_CD as CNT_TYP_CD,
			ctr.RENEW_IN ,
			ctr.BUYER_GRP_CNT_NR,
			ctr.CNT_DESC,
			ctr.BUYE_GRP_CMPNY_ID,
			C.CMPNY_NM 
	from [CNT_DEV].[CONTRACT] ctr
	 JOIN CMPNY.COMPANY C ON C.CMPNY_ID = ctr.BUYE_GRP_CMPNY_ID
		AND ctr.REC_STAT_CD = 'A'
	Where ctr.CNT_NR = @name

END
