CREATE TABLE [STAGE].[CONTRAXX_CNT_ADDR] (
    [CNT_NR]            VARCHAR (20)  NOT NULL,
    [CNT_DESC]          VARCHAR (MAX) NULL,
    [CNT_STATUS_CODE]   VARCHAR (40)  NULL,
    [CNT_TYPE]          VARCHAR (10)  NULL,
    [ADDR_1]            VARCHAR (250) NULL,
    [CITY]              VARCHAR (100) NULL,
    [STATE]             VARCHAR (20)  NULL,
    [ZIP]               VARCHAR (10)  NULL,
    [CURRENT TIMESTAMP] VARCHAR (50)  DEFAULT (getdate()) NOT NULL
);

