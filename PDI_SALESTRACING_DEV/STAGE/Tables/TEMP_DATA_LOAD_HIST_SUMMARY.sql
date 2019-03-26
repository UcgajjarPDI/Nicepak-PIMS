CREATE TABLE [STAGE].[TEMP_DATA_LOAD_HIST_SUMMARY] (
    [SALESPERIOD]        VARCHAR (10)    NULL,
    [DIST_NR]            VARCHAR (20)    NULL,
    [DISTID]             VARCHAR (20)    NULL,
    [REC_CNT]            INT             NULL,
    [CS_QTY]             NUMERIC (38, 8) NULL,
    [SALES_AMT]          NUMERIC (38, 2) NULL,
    [CS_QTY_6MO_AVG]     DECIMAL (38, 2) NULL,
    [CS_QTY_12MO_AVG]    DECIMAL (38, 2) NULL,
    [SALES_AMT_6MO_AVG]  DECIMAL (38, 2) NULL,
    [SALES_AMT_12MO_AVG] DECIMAL (38, 2) NULL,
    [SALES_PERIOD_DT]    DATE            NULL
);

