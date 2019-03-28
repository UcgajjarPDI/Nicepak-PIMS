﻿CREATE TABLE [CMPNY].[GPO_MEMBER] (
    [PDI_GPO_MEMBER_ID]     INT           IDENTITY (7000001, 1) NOT NULL,
    [GPO_CMPNY_ID]          INT           NULL,
    [SRC_GPO_MEMBER_ID]     VARCHAR (50)  NOT NULL,
    [SRC_GPO_MEMBER_ALT_ID] VARCHAR (50)  NULL,
    [CMPNY_ID]              INT           NULL,
    [MMBR_NM]               VARCHAR (255) NOT NULL,
    [MMBR_ADDR_1]           VARCHAR (255) NULL,
    [MMBR_ADDR_2]           VARCHAR (255) NULL,
    [MMBR_CITY]             VARCHAR (255) NULL,
    [MMBR_ST]               CHAR (2)      NULL,
    [MMBR_ZIP]              VARCHAR (10)  NOT NULL,
    [MMBR_CNTRY]            CHAR (3)      NULL,
    [GLN_NR]                VARCHAR (50)  NULL,
    [HIN_NR]                VARCHAR (50)  NULL,
    [DEA_NR]                VARCHAR (50)  NULL,
    [NPI_NR]                VARCHAR (50)  NULL,
    [MMBR_EFF_DT]           DATE          NULL,
    [MMBR_EXP_DT]           DATE          NULL,
    [MMB_ACT_STAT_CD]       CHAR (1)      NULL,
    [REC_EFF_DT]            DATE          NULL,
    [REC_EXP_DT]            DATE          NULL,
    [REC_STAT_IN]           CHAR (1)      NULL
);
