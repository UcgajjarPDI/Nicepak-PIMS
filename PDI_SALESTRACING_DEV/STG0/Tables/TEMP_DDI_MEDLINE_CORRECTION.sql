﻿CREATE TABLE [STG0].[TEMP_DDI_MEDLINE_CORRECTION] (
    [SALES_PERIOD]      VARCHAR (10)    NULL,
    [INV_ID]            VARCHAR (MAX)   NULL,
    [INV_DT]            VARCHAR (MAX)   NULL,
    [INV_DT_NR]         VARCHAR (MAX)   NULL,
    [TRC_UNIT]          VARCHAR (MAX)   NULL,
    [TRC_QTY_SLD]       VARCHAR (MAX)   NULL,
    [TRC_CNT_PRC]       VARCHAR (MAX)   NULL,
    [TRC_LIST_PRC]      VARCHAR (MAX)   NULL,
    [TRC_DIST_PRC]      VARCHAR (MAX)   NULL,
    [TRC_EXT_LIST_COST] VARCHAR (MAX)   NULL,
    [TRC_EXT_DIST_COST] INT             NULL,
    [TRC_EXT_CNT_COST]  VARCHAR (MAX)   NULL,
    [TRC_RBT_AMT]       VARCHAR (MAX)   NULL,
    [LINE_NR]           VARCHAR (MAX)   NULL,
    [SHPTO_ID]          VARCHAR (MAX)   NULL,
    [SHPTO_NM]          VARCHAR (MAX)   NULL,
    [SHPTO_ADDR_1]      VARCHAR (MAX)   NULL,
    [SHPTO_ADDR_2]      VARCHAR (MAX)   NULL,
    [SHPTO_CITY]        VARCHAR (MAX)   NULL,
    [SHPTO_ST]          VARCHAR (MAX)   NULL,
    [SHPTO_ZIP]         VARCHAR (MAX)   NULL,
    [TRC_SALES_AMT]     DECIMAL (38, 8) NULL,
    [TRC_EXT_RBT_AMT]   VARCHAR (MAX)   NULL,
    [TRC_PROD_DESC]     VARCHAR (MAX)   NULL,
    [LOAD_IN]           CHAR (1)        NULL,
    [CH_DIST_ID]        VARCHAR (MAX)   NULL
);

