﻿CREATE TABLE [CNT].[CONTRACT] (
    [CONTRACT_ID_PK]     INT           IDENTITY (1, 1) NOT NULL,
    [REC_EFF_DT]         DATE          NOT NULL,
    [REC_EXP_DT]         DATE          NOT NULL,
    [REC_STAT_CD]        CHAR (1)      NOT NULL,
    [CNT_NR]             VARCHAR (20)  NOT NULL,
    [CNT_EFF_DT]         DATE          NOT NULL,
    [CNT_EXP_DT]         DATE          NOT NULL,
    [CNT_EFF_DT_NR]      INT           NULL,
    [CNT_EXP_DT_NR]      INT           NULL,
    [CNT_APPRV_DT]       DATE          NULL,
    [CNT_TYP_CD]         VARCHAR (20)  NULL,
    [CNT_STAT_CD]        VARCHAR (20)  NOT NULL,
    [RENEW_IN]           CHAR (1)      NULL,
    [RENEW_CNT_NR]       VARCHAR (20)  NULL,
    [BUYER_GRP_CNT_NR]   VARCHAR (40)  NULL,
    [BUYER_GRP_ID]       INT           NULL,
    [BUYER_GRP_NM]       VARCHAR (200) NULL,
    [BUYER_GRP_ADDR_1]   VARCHAR (200) NULL,
    [BUYER_GRP_CITY]     VARCHAR (100) NULL,
    [BUYER_GRP_ST]       VARCHAR (20)  NULL,
    [BUYER_GRP_ZIP]      VARCHAR (20)  NULL,
    [CNT_TIER_LVL]       VARCHAR (20)  NULL,
    [CNT_TIER_LVL_NR]    INT           NULL,
    [CNT_VALID_IN]       CHAR (1)      NULL,
    [CNT_DESC]           VARCHAR (MAX) NULL,
    [SRC_REC_LST_MOD_DT] BIGINT        NULL,
    [CNT_UPD_TYP]        VARCHAR (32)  NULL,
    [RPLCD_CNT_NR]       VARCHAR (20)  NULL,
    [ORIG_EXP_DTE]       INT           NULL,
    [CURRENT TIMESTAMP]  DATETIME      NULL,
    [DATA_XFER_IN]       CHAR (1)      NULL
);





