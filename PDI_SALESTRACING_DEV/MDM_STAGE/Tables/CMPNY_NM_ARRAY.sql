﻿CREATE TABLE [MDM_STAGE].[CMPNY_NM_ARRAY] (
    [CMPNY_ID]          INT           NOT NULL,
    [NM_PARTS]          VARCHAR (100) NULL,
    [NM_PARTS_TYP]      CHAR (1)      NULL,
    [NM_PARTS_HIER]     CHAR (1)      NULL,
    [REC_STAT_IN]       CHAR (1)      NULL,
    [CURRENT TIMESTAMP] ROWVERSION    NOT NULL
);

