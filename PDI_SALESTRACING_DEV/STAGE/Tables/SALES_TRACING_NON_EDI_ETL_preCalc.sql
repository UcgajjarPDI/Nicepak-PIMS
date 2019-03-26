﻿CREATE TABLE [STAGE].[SALES_TRACING_NON_EDI_ETL_preCalc] (
    [MNTH]              CHAR (2)        NULL,
    [DAY]               CHAR (2)        NULL,
    [SALES_PERIOD]      VARCHAR (10)    NULL,
    [YEAR]              CHAR (4)        NULL,
    [RPT_DT]            DATE            NULL,
    [DIST_ID]           VARCHAR (48)    NULL,
    [DIST_NR]           VARCHAR (15)    NULL,
    [TRC_TRNS_TYP]      CHAR (2)        NULL,
    [TRC_CNT_ID]        VARCHAR (30)    NULL,
    [TRC_PROD_ID]       VARCHAR (48)    NULL,
    [TRC_PRC_TYP]       CHAR (4)        NULL,
    [INV_ID]            VARCHAR (30)    NULL,
    [INV_DT]            DATE            NULL,
    [INV_DT_NR]         INT             NULL,
    [TRC_UNIT]          CHAR (3)        NULL,
    [TRC_QTY_SLD]       FLOAT (53)      NULL,
    [TRC_CNT_PRC]       FLOAT (53)      NULL,
    [TRC_LIST_PRC]      FLOAT (53)      NULL,
    [TRC_DIST_PRC]      FLOAT (53)      NULL,
    [TRC_RBT_AMT]       FLOAT (53)      NULL,
    [LINE_NR]           SMALLINT        NULL,
    [SHPTO_ID]          VARCHAR (20)    NULL,
    [SHPTO_NM]          VARCHAR (200)   NULL,
    [SHPTO_ADDR_1]      VARCHAR (100)   NULL,
    [SHPTO_ADDR_2]      VARCHAR (100)   NULL,
    [SHPTO_CITY]        VARCHAR (100)   NULL,
    [SHPTO_ST]          VARCHAR (10)    NULL,
    [SHPTO_ZIP]         VARCHAR (12)    NULL,
    [SHPTO_TYP]         VARCHAR (100)   NULL,
    [BILLTO_ID]         VARCHAR (20)    NULL,
    [BILLTO_NM]         VARCHAR (200)   NULL,
    [BILLTO_ADDR_1]     VARCHAR (150)   NULL,
    [BILLTO_ADDR_2]     VARCHAR (150)   NULL,
    [BILLTO_CITY]       VARCHAR (100)   NULL,
    [BILLTO_ST]         VARCHAR (10)    NULL,
    [BILLTO_ZIP]        VARCHAR (12)    NULL,
    [BILLTO_TYP]        VARCHAR (100)   NULL,
    [DBT_MEMO]          VARCHAR (40)    NULL,
    [CURRENT TIMESTAMP] VARCHAR (50)    NOT NULL,
    [UPD_CNT_ID]        VARCHAR (30)    NULL,
    [UPD_PROD_ID]       VARCHAR (48)    NULL,
    [TRC_CS_PRC]        FLOAT (53)      NULL,
    [CNT_EXP_DT]        DATE            NULL,
    [TRC_UPD_UNIT]      CHAR (2)        NULL,
    [UPD_CS_QTY]        FLOAT (53)      NULL,
    [UPD_CS_PRC]        FLOAT (53)      NULL,
    [TRC_SALES_AMT]     FLOAT (53)      NULL,
    [UPD_SALES_AMT]     FLOAT (53)      NULL,
    [TRC_VAR]           FLOAT (53)      NULL,
    [RBT_STAT_CD]       CHAR (3)        NULL,
    [UPD_RBT_AMT]       FLOAT (53)      NULL,
    [RBT_CALC_STAT]     CHAR (1)        NULL,
    [RBT_CNT_ID]        VARCHAR (30)    NULL,
    [UPD_PRC_TYP]       CHAR (4)        NULL,
    [TRC_UPD_CS_PRC]    FLOAT (53)      NULL,
    [ERR_CD]            VARCHAR (40)    NULL,
    [RBT_LIST_PRC]      FLOAT (53)      NULL,
    [SAF_VARIANCE]      DECIMAL (38, 8) NULL,
    [SAF_SALES_AMT]     MONEY           NULL,
    [TRC_EXT_LIST_COST] FLOAT (53)      NULL,
    [TRC_EXT_CNT_COST]  FLOAT (53)      NULL,
    [INV_DT_IN]         CHAR (1)        NULL,
    [CNT_EXP_DAYS]      SMALLINT        NULL,
    [SLS_CALC_STAT]     CHAR (1)        NULL,
    [RBT_PRC_TYP]       CHAR (4)        NULL
);

