-- =============================================
-- Author:		Krunal Trivedi
-- Create date: 1/14/2019
-- Description:	save contract details from new contract page
-- =============================================
CREATE PROCEDURE [CNT].[spSAVE_NEW_CONTRACT]
(@CNT_NR            VARCHAR(20), --1
 @CNT_EFF_DT        DATE, --4
 @CNT_EXP_DT        DATE, --5
 @CNT_TYP_CD        VARCHAR(20), 
 @RENEW_IN          CHAR(1), 
 @REPLCNG_CNT_NR    VARCHAR(20), 
 @BUYER_GRP_CNT_NR  VARCHAR(40), 
 @BUYE_GRP_CMPNY_ID INT, 
 @TIER_ID           INT, 
 @TIER_DESC         VARCHAR(20), 
 @CNT_DESC          [VARCHAR](MAX), 
 @USER_ID			INT,
 @duplicarion       CHAR(1) OUTPUT
)
AS
    BEGIN
        SET NOCOUNT ON;
        SET @duplicarion = 'N';
        IF NOT EXISTS
        (
            SELECT *
            FROM [CNT_DEV].[CONTRACT]
            WHERE cnt_nr = @CNT_NR
        )
            BEGIN
                INSERT INTO [CNT_DEV].[CONTRACT]
                (CNT_NR, 
                 CNT_EFF_DT, 
                 CNT_EXP_DT, 
                 CNT_TYP_CD, 
                 CNT_STAT_CD, 
                 RENEW_IN, 
                 RENEW_CNT_NR, 
                 BUYER_GRP_CNT_NR, 
                 BUYE_GRP_CMPNY_ID, 
                 TIER_ID, 
                 TIER_DESC, 
                 CNT_DESC, 
                 CNT_LIFECYCLE_CD, 
                 REC_EFF_DT, 
                 REC_EXP_DT, 
                 REC_STAT_CD,
				 USER_ID
                )
                VALUES
                (@CNT_NR, 
                 @CNT_EFF_DT, 
                 @CNT_EXP_DT, 
                 @CNT_TYP_CD, 
                 'P', 
                 @RENEW_IN, 
                 @REPLCNG_CNT_NR, 
                 @BUYER_GRP_CNT_NR, 
                 @BUYE_GRP_CMPNY_ID, 
                 @TIER_ID, 
                 @TIER_DESC, 
                 @CNT_DESC, 
                 'GI', 
                 CONVERT(DATE, GETDATE()), 
                 CONVERT(DATE, '9999-12-31'), 
                 'A',
				 @USER_ID
                );
                INSERT INTO CNT_DEV.CNT_EB
                (
                CNT_NR, 
                CMPNY_ID, 
                REC_EFF_DT, 
                REC_EXP_DT, 
                REC_STAT_CD
                )
                       SELECT @CNT_NR, CMPNY_ID, 
                              CONVERT(DATE, GETDATE()) AS REC_EFF_DT, 
                              CONVERT(DATE, '9999-12-31') AS PROD_EXP_DT_NR, 
                              'A'
                       FROM CMPNY.COMPANY
                       WHERE IDN_CMPNY_ID = @BUYE_GRP_CMPNY_ID
                       UNION ALL
                       SELECT @CNT_NR, c.CMPNY_ID, 
                              CONVERT(DATE, GETDATE()) AS REC_EFF_DT, 
                              CONVERT(DATE, '9999-12-31') AS PROD_EXP_DT_NR, 
                              'A'
                       FROM CMPNY.COMPANY C
                            JOIN
                       (
                           SELECT DISTINCT 
                                  CMPNY_ID
                           FROM CMPNY.COMPANY
                           WHERE IDN_CMPNY_ID = @BUYE_GRP_CMPNY_ID
                       ) I ON C.CMPNY_PRNT_ID = I.CMPNY_ID;
        END;
            ELSE
            SET @duplicarion = 'Y';
        SELECT @duplicarion;
    END;