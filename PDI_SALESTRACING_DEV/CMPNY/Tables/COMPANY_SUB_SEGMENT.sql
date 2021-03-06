﻿CREATE TABLE [CMPNY].[COMPANY_SUB_SEGMENT] (
    [CMPNY_SUB_SGMNT_ID]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_SGMNT_ID]       SMALLINT      NOT NULL,
    [CMPNY_SUB_SGMNT_NM]   VARCHAR (100) NOT NULL,
    [CMPNY_SUB_SGMNT_DESC] VARCHAR (100) NULL,
    [REC_EFF_DT]           DATE          NULL,
    [REC_EXP_DT]           DATE          NULL,
    [REC_STAT_IN]          CHAR (1)      NULL
);

