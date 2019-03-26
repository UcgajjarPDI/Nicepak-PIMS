
CREATE PROCEDURE [CNT].[spSAVE_PROD_RATIONALE] 
	@cntNr varchar(7),
	@prodId varchar(7),
	@rationale varchar(500)
AS
BEGIN
	
	SET NOCOUNT ON;

	update [CNT].[PROD_RATIONALE] Set [REC_STAT_CD] = 'I', [REC_EXP_DT]='12/31/9999' 
		Where [CNT_NR]= @cntNr and [PROD_ID] =@prodId

	INSERT INTO [CNT].[PROD_RATIONALE]
           ([CNT_NR]
           ,[PROD_ID]
           ,[RATIONALE]
		   ,[REC_EFF_DT]
           ,[REC_EXP_DT]
           ,[REC_STAT_CD])
     VALUES(
			@cntNr,		
			@prodId,
			@rationale,
			CONVERT(DATE, GETDATE()),
			CONVERT(DATE, '9999-12-31'),
			'A')	

END

--select * from [CNT].[PROD_RATIONALE]