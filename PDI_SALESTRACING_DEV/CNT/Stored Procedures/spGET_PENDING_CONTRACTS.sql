CREATE PROCEDURE [CNT].[spGET_PENDING_CONTRACTS]

AS
    BEGIN
        SET NOCOUNT ON;
        --SELECT CNT_NR, 
        --       G.GRP_SHRT_NM, 
        --       INIT_USR_NM, 
        --       CNT_INIT_DT, 
        --       CONVERT(VARCHAR, CNT_RVW_DL_DT, 101) AS CNT_RVW_DL_DT, 
        --       'Post Feedback' AS CNT_TYP_CD, 
        --       CNT_STAT_CD, 
        --       PDI_GROUP_ID
        --FROM PCM.PCM_CONT_PND C
        --     JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID

			 SELECT 
	c.CONTRACT_ID_PK,
	c.CNT_NR, 
		cmp.CMPNY_NM,
		u.USR_FULL_NM,
		'Pending Review'as CNT_STAT_CD,
		'Post Feedback' AS CNT_TYP_CD,
		CONVERT(VARCHAR(10),DATEADD(day,30,c.REC_EFF_DT),101) 	AS CNT_RVW_DL_DT
	 FROM CNT_DEV.CONTRACT c
	 INNER JOIN CMPNY.COMPANY cmp ON cmp.CMPNY_ID = c.BUYE_GRP_CMPNY_ID
	 INNER JOIN PCM.PCM_USER u ON u.USR_ID = c.user_ID
	 WHERE c.CNT_STAT_CD ='P'


    END;

	