﻿CREATE TABLE [STG0].[PRC_AUTH] (
    [PRC_AUTH_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [GPO_NM]            VARCHAR (MAX) NULL,
    [GPO_MBR_ID]        VARCHAR (MAX) NULL,
    [GPO_MBR_NM]        VARCHAR (MAX) NULL,
    [GPO_MBR_ADDR1]     VARCHAR (MAX) NULL,
    [GPO_MBR_ADDR2]     VARCHAR (MAX) NULL,
    [GPO_MBR_CITY]      VARCHAR (MAX) NULL,
    [GPO_MBR_ST]        VARCHAR (MAX) NULL,
    [GPO_MBR_ZIP]       VARCHAR (MAX) NULL,
    [GPO_CNT_NR]        VARCHAR (MAX) NULL,
    [MFG_CNT_NR]        VARCHAR (MAX) NULL,
    [TIER_NR]           VARCHAR (MAX) NULL,
    [TIER_DESC]         VARCHAR (MAX) NULL,
    [PRC_EFF_DT]        VARCHAR (MAX) NULL,
    [PRC_EXP_DT]        VARCHAR (MAX) NULL,
    [IDN_NM]            VARCHAR (MAX) NULL,
    [DIST_NM_1]         VARCHAR (MAX) NULL,
    [DIST_NM_2]         VARCHAR (MAX) NULL,
    [PRC_ACT_NR]        VARCHAR (MAX) NULL,
    [LIC_NR]            VARCHAR (MAX) NULL,
    [PRC_ACT_DT]        VARCHAR (MAX) NULL,
    [STATUS]            VARCHAR (MAX) NULL,
    [SRC_REC_ID]        VARCHAR (MAX) NULL,
    [DEA]               VARCHAR (MAX) NULL,
    [GLN]               VARCHAR (MAX) NULL,
    [HIN]               VARCHAR (MAX) NULL,
    [SEGMENT]           VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP] DATETIME      DEFAULT (getdate()) NOT NULL
);

