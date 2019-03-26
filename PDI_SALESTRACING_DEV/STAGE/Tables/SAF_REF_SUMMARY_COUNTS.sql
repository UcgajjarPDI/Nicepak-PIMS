CREATE TABLE [STAGE].[SAF_REF_SUMMARY_COUNTS] (
    [SALESPERIOD]     VARCHAR (10)    NULL,
    [DISTCOID]        VARCHAR (20)    NULL,
    [DISTID]          VARCHAR (8)     NULL,
    [RecCount]        INT             NULL,
    [TotQtySold]      NUMERIC (38, 8) NULL,
    [TotSalesAmt]     NUMERIC (38, 2) NULL,
    [TotRbtApprvdAmt] NUMERIC (38, 2) NULL,
    [TotRbtAmt]       NUMERIC (38, 4) NULL
);

