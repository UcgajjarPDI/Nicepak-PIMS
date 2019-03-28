﻿CREATE TABLE [STAGE].[SALES_TRACING_NON_EDI_ETL_bkup] (
    [MNTH]               CHAR (2)        NULL,
    [DAY]                CHAR (2)        NULL,
    [SALES_PERIOD]       VARCHAR (10)    NULL,
    [YEAR]               CHAR (4)        NULL,
    [RPT_DT]             DATE            NULL,
    [DIST_ID]            VARCHAR (48)    NULL,
    [DIST_NR]            VARCHAR (15)    NULL,
    [TRC_TRNS_TYP]       CHAR (2)        NULL,
    [TRC_CNT_ID]         VARCHAR (30)    NULL,
    [TRC_PROD_ID]        VARCHAR (48)    NULL,
    [TRC_PRC_TYP]        CHAR (4)        NULL,
    [INV_ID]             VARCHAR (30)    NULL,
    [INV_DT]             DATE            NULL,
    [INV_DT_NR]          DATE            NULL,
    [TRC_UNIT]           CHAR (3)        NULL,
    [TRC_QTY_SLD]        FLOAT (53)      NULL,
    [TRC_CNT_PRC]        FLOAT (53)      NULL,
    [TRC_LIST_PRC]       FLOAT (53)      NULL,
    [TRC_DIST_PRC]       FLOAT (53)      NULL,
    [TRC_RBT_AMT]        FLOAT (53)      NULL,
    [LINE_NR]            SMALLINT        NULL,
    [SHPTO_ID]           VARCHAR (20)    NULL,
    [SHPTO_NM]           VARCHAR (200)   NULL,
    [SHPTO_ADDR_1]       VARCHAR (100)   NULL,
    [SHPTO_ADDR_2]       VARCHAR (100)   NULL,
    [SHPTO_CITY]         VARCHAR (100)   NULL,
    [SHPTO_ST]           VARCHAR (10)    NULL,
    [SHPTO_ZIP]          VARCHAR (12)    NULL,
    [SHPTO_TYP]          VARCHAR (100)   NULL,
    [BILLTO_ID]          VARCHAR (20)    NULL,
    [BILLTO_NM]          VARCHAR (200)   NULL,
    [BILLTO_ADDR_1]      VARCHAR (150)   NULL,
    [BILLTO_ADDR_2]      VARCHAR (150)   NULL,
    [BILLTO_CITY]        VARCHAR (100)   NULL,
    [BILLTO_ST]          VARCHAR (10)    NULL,
    [BILLTO_ZIP]         VARCHAR (12)    NULL,
    [BILLTO_TYP]         VARCHAR (100)   NULL,
    [DBT_MEMO]           VARCHAR (40)    NULL,
    [CURRENT TIMESTAMP]  VARCHAR (50)    NOT NULL,
    [UPDT_CNT_ID]        VARCHAR (30)    NULL,
    [UPDT_PROD_ID]       VARCHAR (48)    NULL,
    [TRC_CS_PRC]         FLOAT (53)      NULL,
    [CNT_EXP_DT]         DATE            NULL,
    [TRC_UPDT_UNIT]      CHAR (2)        NULL,
    [UPDT_CS_QTY]        FLOAT (53)      NULL,
    [UPDT_CS_PRC]        FLOAT (53)      NULL,
    [TRC_SALES_AMT]      FLOAT (53)      NULL,
    [UPDT_SALES_AMT]     FLOAT (53)      NULL,
    [TRC_VAR]            FLOAT (53)      NULL,
    [RBT_STAT_CD]        CHAR (3)        NULL,
    [UPDT_RBT_AMT]       FLOAT (53)      NULL,
    [SALES_CALC_IN]      CHAR (1)        NULL,
    [RBT_CNT_ID]         VARCHAR (30)    NULL,
    [UPDT_PRC_TYP]       CHAR (4)        NULL,
    [TRC_UPDT_CS_PRC]    FLOAT (53)      NULL,
    [ERR_CD]             VARCHAR (40)    NULL,
    [LIST_CS_PRC]        FLOAT (53)      NULL,
    [Updated Sales Amt]  MONEY           NULL,
    [SAF_VARIANCE]       DECIMAL (38, 8) NULL,
    [SAF_SALES_AMT]      MONEY           NULL,
    [UPDATED_REBATE_AMT] MONEY           NULL,
    [REBATE_STATUS_CD]   VARCHAR (15)    NULL,
    [TRC_EXT_LIST_COST]  FLOAT (53)      NULL,
    [TRC_EXT_CNT_COST]   FLOAT (53)      NULL
);
