CREATE TABLE [STAGE].[CONTRAXX_CNT] (
    [CNT_NR]            VARCHAR (20)  NOT NULL,
    [CNT_EFF_DT_NR]     INT           NULL,
    [CNT_EXP_DT_NR]     INT           NULL,
    [CNT_APPRV_DT]      INT           NULL,
    [CNT_TYP_CD]        VARCHAR (20)  NULL,
    [CNT_STATUS_CODE]   VARCHAR (40)  NULL,
    [CNT_DESC]          VARCHAR (MAX) NULL,
    [BUYER_GRP_CNT_NR]  VARCHAR (40)  NULL,
    [CNT_TIER_LVL]      VARCHAR (20)  NULL,
    [LAST_MOD_DT_NR]    BIGINT        NULL,
    [GRP_NM]            VARCHAR (100) NULL,
    [GRP_ADDR_1]        VARCHAR (200) NULL,
    [GRP_ADDR_2]        VARCHAR (150) NULL,
    [GRP_CITY]          VARCHAR (100) NULL,
    [GRP_ST]            VARCHAR (40)  NULL,
    [GRP_ZIP]           VARCHAR (20)  NULL,
    [CNT_EXTND_DT]      INT           NULL,
    [RENEW_CNT_NR]      VARCHAR (20)  NULL,
    [CURRENT TIMESTAMP] VARCHAR (50)  DEFAULT (getdate()) NOT NULL
);

