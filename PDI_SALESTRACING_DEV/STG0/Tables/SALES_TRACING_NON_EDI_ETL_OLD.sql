﻿CREATE TABLE [STG0].[SALES_TRACING_NON_EDI_ETL_OLD] (
    [MONTH]                CHAR (2)        NULL,
    [DAY]                  CHAR (2)        NULL,
    [SALES PERIOD]         VARCHAR (10)    NULL,
    [YEAR]                 CHAR (4)        NULL,
    [RPT Date]             DECIMAL (8)     NULL,
    [DISTID]               VARCHAR (48)    NULL,
    [DIST NO]              VARCHAR (15)    NULL,
    [TRC Trans Type]       VARCHAR (MAX)   NULL,
    [TRC Contract ID]      VARCHAR (MAX)   NULL,
    [TRC Prod ID]          VARCHAR (MAX)   NULL,
    [TRC Price Type]       VARCHAR (MAX)   NULL,
    [Invoice ID]           VARCHAR (MAX)   NULL,
    [Invoice Date]         DATE            NULL,
    [nInvoice Date]        VARCHAR (MAX)   NULL,
    [TRC Unit]             VARCHAR (MAX)   NULL,
    [TRC Qty Sold]         VARCHAR (MAX)   NULL,
    [TRC Contract Price]   VARCHAR (MAX)   NULL,
    [TRC List Price]       VARCHAR (MAX)   NULL,
    [TRC Dist Price]       VARCHAR (MAX)   NULL,
    [TRC Rebate Amount]    VARCHAR (MAX)   NULL,
    [Line_Nr]              VARCHAR (MAX)   NULL,
    [ShipTo_CD]            VARCHAR (MAX)   NULL,
    [ShipTo_NM]            VARCHAR (MAX)   NULL,
    [ShipTo_ADD1]          VARCHAR (MAX)   NULL,
    [ShipTo_ADD2]          VARCHAR (MAX)   NULL,
    [ShipTo_City]          VARCHAR (MAX)   NULL,
    [ShipTo_ST]            VARCHAR (MAX)   NULL,
    [ShipTo_Zip]           VARCHAR (MAX)   NULL,
    [ShipTo_Type]          VARCHAR (MAX)   NULL,
    [EndUser_CD]           VARCHAR (MAX)   NULL,
    [EndUser_NM]           VARCHAR (MAX)   NULL,
    [EndUser_ADD1]         VARCHAR (MAX)   NULL,
    [EndUser_ADD2]         VARCHAR (MAX)   NULL,
    [EndUser_City]         VARCHAR (MAX)   NULL,
    [EndUser_ST]           VARCHAR (MAX)   NULL,
    [EndUser_ZIP]          VARCHAR (MAX)   NULL,
    [EndUser_TYPE]         VARCHAR (MAX)   NULL,
    [Debit_Memo]           VARCHAR (MAX)   NULL,
    [CURRENT TIMESTAMP]    VARCHAR (50)    NOT NULL,
    [Updated Contract ID]  VARCHAR (30)    NULL,
    [Updated Prod ID]      VARCHAR (48)    NULL,
    [TRC CS PRICE]         DECIMAL (38, 8) NULL,
    [CONT Exp Date]        DATE            NULL,
    [TRC Updated Unit]     CHAR (2)        NULL,
    [Updated CS Qty]       DECIMAL (38, 8) NULL,
    [Updated CS Price]     DECIMAL (38, 4) NULL,
    [TRC Sales Amt]        DECIMAL (38, 8) NULL,
    [Updated Sales Amt]    DECIMAL (38, 8) NULL,
    [TRC Variance]         DECIMAL (38, 8) NULL,
    [REBATE_STATUS_CD]     CHAR (3)        NULL,
    [Updated Rebate Amt]   DECIMAL (38, 8) NULL,
    [SALES_CALC_IN]        CHAR (1)        NULL,
    [RBT Contract ID]      VARCHAR (30)    NULL,
    [Updated Price Type]   CHAR (4)        NULL,
    [TRC UPDATED CS PRICE] DECIMAL (38, 4) NULL,
    [ERROR CODE]           VARCHAR (40)    NULL,
    [LIST CS Price]        DECIMAL (38, 4) NULL
);
