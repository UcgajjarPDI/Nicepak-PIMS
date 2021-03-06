﻿CREATE TABLE [STAGE].[DIM_CONTRACT] (
    [CONTRACT_KEY]      SMALLINT      NOT NULL,
    [CONTRACT_NO]       VARCHAR (50)  NOT NULL,
    [GROUP_KEY]         SMALLINT      NOT NULL,
    [GROUP_ID]          VARCHAR (50)  NULL,
    [GROUP_NAME]        VARCHAR (70)  NULL,
    [REFERENCE_NO]      VARCHAR (100) NULL,
    [CONTRACT_TYPE]     CHAR (3)      NULL,
    [TIER_LEVEL]        VARCHAR (20)  NULL,
    [GROUP_ADMIN_FEES]  REAL          NOT NULL,
    [CURRENT_INDICATOR] NCHAR (10)    NOT NULL,
    [EFF_DATE]          DATE          NOT NULL,
    [EXP_DATE]          DATE          NOT NULL,
    [DIST_CONTRACT_NO]  VARCHAR (50)  NULL,
    [ETL_AUDIT_KEY]     INT           NOT NULL,
    [CURRENT TIMESTAMP] DATETIME      NOT NULL,
    [CNT_DESC]          VARCHAR (MAX) NULL
);

