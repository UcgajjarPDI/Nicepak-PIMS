﻿CREATE TABLE [CMPNY].[COMPANY_DATA_SOURCE] (
    [CMPNY_SRCE_ID]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_SRCE_NM]   VARCHAR (50)  NOT NULL,
    [CMPNY_SRCE_DESC] VARCHAR (255) NULL,
    [REC_EFF_DT]      DATE          NULL,
    [REC_EXP_DT]      DATE          NULL,
    [REC_STAT_IN]     CHAR (1)      NULL
);
