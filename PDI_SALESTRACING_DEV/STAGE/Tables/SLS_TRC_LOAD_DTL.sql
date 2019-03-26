CREATE TABLE [STAGE].[SLS_TRC_LOAD_DTL] (
    [LOAD_ID]              INT          IDENTITY (301, 1) NOT NULL,
    [DIST_ID]              VARCHAR (15) NULL,
    [DIST_TRC_NM]          VARCHAR (15) NULL,
    [SALES_PERIOD]         VARCHAR (10) NULL,
    [RECVD_DTE]            INT          NULL,
    [LOAD_STAT]            VARCHAR (20) NULL,
    [REC_CNT]              INT          NULL,
    [REC_CNT_CALC]         INT          NULL,
    [EXCP_COUNT]           INT          NULL,
    [CS_QTY]               DECIMAL (18) NULL,
    [ROLLING_6_MN_AV_QTY]  DECIMAL (18) NULL,
    [ROLLING_12_MN_AV_QTY] DECIMAL (18) NULL,
    [SALES_AMT]            DECIMAL (18) NULL,
    [ROLLING_6_MN_AV_AMT]  DECIMAL (18) NULL,
    [ROLLING_12_MN_AV_AMT] DECIMAL (18) NULL,
    [PROC_STAT]            VARCHAR (20) NULL,
    [SRC_FILE_TYP]         CHAR (3)     NULL
);

