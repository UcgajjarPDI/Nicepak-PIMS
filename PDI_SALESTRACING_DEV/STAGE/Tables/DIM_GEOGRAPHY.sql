CREATE TABLE [STAGE].[DIM_GEOGRAPHY] (
    [ZIPCODE_SHORT]         NCHAR (10)    NOT NULL,
    [ZIPCODE_LONG]          NCHAR (10)    NULL,
    [CITY]                  VARCHAR (100) NULL,
    [STATE_CODE]            NCHAR (5)     NULL,
    [STATE]                 VARCHAR (50)  NULL,
    [COUNTRY]               VARCHAR (50)  NULL,
    [TERRITORY_TYPE]        NCHAR (3)     NULL,
    [TERRITORY_ID]          INT           NULL,
    [TERRITORY_NAME]        VARCHAR (50)  NULL,
    [REGION_NAME]           VARCHAR (50)  NULL,
    [COMPANY_ID]            NCHAR (2)     NULL,
    [DIVISION]              NCHAR (4)     NULL,
    [EFF_DATE]              DATE          NULL,
    [EXP_DATE]              DATE          NULL,
    [CURRENT_INDICATOR_Y_N] NCHAR (1)     NOT NULL,
    [CURRENT TIMESTAMP]     VARCHAR (50)  DEFAULT (getdate()) NOT NULL
);

