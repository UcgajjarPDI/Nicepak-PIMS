CREATE TABLE [SNDBX].[TEMP_NEW_CNT] (
    [REC_EFF_DT]         DATE          NULL,
    [REC_EXP_DT]         DATE          NULL,
    [REC_STAT_CD]        VARCHAR (1)   NOT NULL,
    [CNT_NR]             VARCHAR (20)  NOT NULL,
    [CNT_EFF_DT]         DATE          NULL,
    [CNT_EXP_DT]         DATE          NULL,
    [CNT_EFF_DT_NR]      INT           NULL,
    [CNT_EXP_DT_NR]      INT           NULL,
    [CNT_TYP_CD]         VARCHAR (20)  NULL,
    [CNT_APPRV_DT]       DATE          NULL,
    [CNT_STAT_CD]        VARCHAR (1)   NOT NULL,
    [BUYE_GRP_NM]        VARCHAR (100) NULL,
    [BUYER_GRP_CNT_NR]   VARCHAR (40)  NOT NULL,
    [CNT_TIER_LVL]       VARCHAR (20)  NOT NULL,
    [CNT_DESC]           VARCHAR (MAX) NULL,
    [CNT_UPD_TYP]        VARCHAR (16)  NOT NULL,
    [RPLCD_CNT_NR]       VARCHAR (20)  NULL,
    [SRC_REC_LST_MOD_DT] BIGINT        NULL,
    [CURRENT TIMESTAMP]  DATETIME      NOT NULL
);

