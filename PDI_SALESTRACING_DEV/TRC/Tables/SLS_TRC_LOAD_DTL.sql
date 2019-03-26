CREATE TABLE [TRC].[SLS_TRC_LOAD_DTL] (
    [LOAD_ID]              INT             IDENTITY (301, 1) NOT NULL,
    [DIST_ID]              VARCHAR (15)    NULL,
    [DIST_TRC_NM]          VARCHAR (15)    NULL,
    [SALES_PERIOD]         VARCHAR (10)    NULL,
    [RECVD_DTE]            INT             NULL,
    [LOAD_STAT]            VARCHAR (20)    NULL,
    [REC_CNT]              DECIMAL (32)    NULL,
    [REC_CNT_CALC]         DECIMAL (32)    NULL,
    [REC_CNT_REC_REQD]     DECIMAL (32)    NULL,
    [CS_QTY]               DECIMAL (18, 2) NULL,
    [ROLLING_6_MN_AV_QTY]  DECIMAL (18, 2) NULL,
    [ROLLING_12_MN_AV_QTY] DECIMAL (18, 2) NULL,
    [SALES_AMT]            DECIMAL (18, 2) NULL,
    [ROLLING_6_MN_AV_AMT]  DECIMAL (18, 2) NULL,
    [ROLLING_12_MN_AV_AMT] DECIMAL (18, 2) NULL,
    [PROC_STAT]            VARCHAR (20)    NULL,
    [SRC_FILE_TYP]         CHAR (3)        NULL
);

