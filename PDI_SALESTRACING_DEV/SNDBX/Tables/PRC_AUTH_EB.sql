﻿CREATE TABLE [SNDBX].[PRC_AUTH_EB] (
    [PRC_AUTH_ID]         INT           NOT NULL,
    [PDI_GPO_ID]          INT           NULL,
    [GPO_NM]              VARCHAR (15)  NULL,
    [GPO_MBR_ID]          VARCHAR (15)  NULL,
    [GPO_MBR_NM]          VARCHAR (250) NULL,
    [GPO_MBR_ADDR1]       VARCHAR (250) NULL,
    [GPO_MBR_ADDR2]       VARCHAR (250) NULL,
    [GPO_MBR_CITY]        VARCHAR (50)  NULL,
    [GPO_MBR_ST]          VARCHAR (50)  NULL,
    [GPO_MBR_ZIP]         VARCHAR (5)   NULL,
    [GPO_CNT_NR]          VARCHAR (15)  NULL,
    [MFG_CNT_NR]          VARCHAR (15)  NULL,
    [TIER_NR]             INT           NULL,
    [PRC_EFF_DT]          DATE          NULL,
    [PRC_EXP_DT]          DATE          NULL,
    [PRC_ACT_NR]          VARCHAR (50)  NULL,
    [PRC_ACT_DT]          DATE          NULL,
    [LIC_NR]              VARCHAR (10)  NULL,
    [STATUS]              VARCHAR (20)  NULL,
    [SRC_REC_ID]          VARCHAR (15)  NULL,
    [DEA]                 VARCHAR (50)  NULL,
    [GLN]                 VARCHAR (50)  NULL,
    [HIN]                 VARCHAR (50)  NULL,
    [SEGMENT]             VARCHAR (50)  NULL,
    [REC_STAT_CD]         CHAR (1)      NULL,
    [REC_EFF_DT]          DATE          NULL,
    [REC_EXP_DT]          DATE          NULL,
    [EDI_TRANSFER_STAT]   CHAR (1)      NULL,
    [CURRENT_TIMESTAMP]   DATETIME      NULL,
    [CMPNY_ID]            INT           NULL,
    [PRC_AUTH_STAT_CD]    CHAR (1)      DEFAULT ('P') NOT NULL,
    [APPRD_CONTRACT_TIER] VARCHAR (20)  NULL
);





