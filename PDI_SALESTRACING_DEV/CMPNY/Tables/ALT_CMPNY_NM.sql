﻿CREATE TABLE [CMPNY].[ALT_CMPNY_NM] (
    [ALT_CMPNY_NM_ID]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_ID]          INT           NOT NULL,
    [SRCE_CMPNY_ID]     VARCHAR (40)  NULL,
    [ALT_CMPNY_NM]      VARCHAR (255) NOT NULL,
    [REC_EFF_DT]        DATE          NULL,
    [REC_EXP_DT]        DATE          NULL,
    [REC_STAT_IN]       CHAR (1)      NULL,
    [CURRENT TIMESTAMP] ROWVERSION    NOT NULL
);

