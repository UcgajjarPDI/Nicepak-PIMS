﻿CREATE TABLE [STAGE].[DIM_TERRITORY] (
    [RECORD_KEY]           INT            IDENTITY (-1, 1) NOT NULL,
    [TERRITORY_KEY]        INT            NOT NULL,
    [TERRITORY_ID]         NCHAR (10)     NOT NULL,
    [TERRITORY_TYPE]       NCHAR (10)     NOT NULL,
    [COMPANY_ID]           NCHAR (4)      NOT NULL,
    [DIVISION]             NCHAR (4)      NOT NULL,
    [TERRITORY_NAME]       VARCHAR (50)   NOT NULL,
    [TERRITORY_SHORT_NAME] NCHAR (10)     NULL,
    [TSM_ID]               VARCHAR (20)   NOT NULL,
    [TSM_NAME]             VARCHAR (50)   NOT NULL,
    [TSM_ADDRESS]          VARCHAR (255)  NULL,
    [TSM_CITY]             VARCHAR (50)   NULL,
    [TSM_STATE]            NCHAR (4)      NULL,
    [TSM_ZIP]              NCHAR (10)     NULL,
    [TSM_COUNTRY]          VARCHAR (20)   NULL,
    [TSM_PHONE]            VARCHAR (15)   NULL,
    [TSM_EMAIL]            VARCHAR (50)   NULL,
    [REGION_NAME]          VARCHAR (50)   NOT NULL,
    [REGION_SHORT_NAME]    NCHAR (10)     NULL,
    [RD_ID]                VARCHAR (20)   NOT NULL,
    [RD_NAME]              VARCHAR (50)   NOT NULL,
    [RD_EMAIL]             VARCHAR (50)   NULL,
    [CURRENT_INDICATOR_YN] NCHAR (10)     NOT NULL,
    [EFF_DATE]             DATE           NOT NULL,
    [EXP_DATE]             DATE           NOT NULL,
    [RD_EFF_DATE]          DATE           NULL,
    [RD_EXP_DATE]          DATE           NULL,
    [BURST_RD]             NVARCHAR (MAX) NULL,
    [BURST_TSM]            NVARCHAR (MAX) NULL,
    [ETL_AUDIT_KEY]        AS             (checksum([TERRITORY_KEY],[TERRITORY_ID],[TSM_NAME])),
    [CURRENT TIMESTAMP]    DATETIME       DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_STAGE_DIM_TERRITORY_1] PRIMARY KEY CLUSTERED ([RECORD_KEY] ASC) WITH (FILLFACTOR = 100)
);

