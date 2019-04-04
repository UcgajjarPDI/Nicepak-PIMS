-- =============================================
-- Author:		Keyur Patel
-- Create date: 4/3/2019
-- Description:	Exercise 1
-- =============================================
CREATE PROCEDURE dbo.upsert_contract 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	SET IDENTITY_INSERT SNDBX.CONTRACT ON

	-- Update existing record when expiration date is late than in target table
UPDATE TC
SET TC.CNT_UPD_TYP = 'Extended Contract'
FROM SNDBX.CONTRACT TC INNER JOIN STG0.CONTRACT SC 
        ON TC.CONTRACT_ID_PK = SC.CONTRACT_ID_PK
WHERE TC.CNT_EXP_DT >GETDATE()
AND TC.CONTRACT_ID_PK IN (SELECT CONTRACT_ID_PK FROM SNDBX.CONTRACT)

	-- Update existing record when expiration date is earlier than in target table

UPDATE TC
SET TC.CNT_UPD_TYP = 'Expired Contract'
FROM SNDBX.CONTRACT TC INNER JOIN STG0.CONTRACT SC 
        ON TC.CONTRACT_ID_PK = SC.CONTRACT_ID_PK
WHERE TC.CNT_EXP_DT < GETDATE()
AND TC.CONTRACT_ID_PK IN (SELECT CONTRACT_ID_PK FROM SNDBX.CONTRACT)

-- Insert new record not exists in target table
INSERT INTO [SNDBX].[CONTRACT]
           ([REC_EFF_DT]
           ,[REC_EXP_DT]
           ,[REC_STAT_CD]
           ,[CNT_NR]
           ,[CNT_EFF_DT]
           ,[CNT_EXP_DT]
           ,[CNT_EFF_DT_NR]
           ,[CNT_EXP_DT_NR]
           ,[CNT_APPRV_DT]
           ,[CNT_TYP_CD]
           ,[CNT_STAT_CD]
           ,[RENEW_IN]
           ,[RENEW_CNT_NR]
           ,[BUYER_GRP_CNT_NR]
           ,[BUYER_GRP_ID]
           ,[CNT_TIER_LVL]
           ,[CNT_TIER_LVL_NR]
           ,[CNT_VALID_IN]
           ,[BUYER_GRP_NM]
           ,[CNT_DESC]
           ,[SRC_REC_LST_MOD_DT]
           ,[CNT_UPD_TYP]
           ,[RPLCD_CNT_NR]
           ,[ORIG_EXP_DTE]
           ,[CURRENT TIMESTAMP])
select [REC_EFF_DT]
      ,[REC_EXP_DT]
      ,[REC_STAT_CD]
      ,[CNT_NR]
      ,[CNT_EFF_DT]
      ,[CNT_EXP_DT]
      ,[CNT_EFF_DT_NR]
      ,[CNT_EXP_DT_NR]
      ,[CNT_APPRV_DT]
      ,[CNT_TYP_CD]
      ,[CNT_STAT_CD]
      ,[RENEW_IN]
      ,[RENEW_CNT_NR]
      ,[BUYER_GRP_CNT_NR]
      ,[BUYER_GRP_ID]
      ,[CNT_TIER_LVL]
      ,[CNT_TIER_LVL_NR]
      ,[CNT_VALID_IN]
      ,[BUYER_GRP_NM]
      ,[CNT_DESC]
      ,[SRC_REC_LST_MOD_DT]
      ,[CNT_UPD_TYP]
      ,[RPLCD_CNT_NR]
      ,[ORIG_EXP_DTE]
      ,[CURRENT TIMESTAMP] from STG0.CONTRACT SC
where SC.CONTRACT_ID_PK not in (SELECT CONTRACT_ID_PK FROM SNDBX.CONTRACT)


END