CREATE TABLE [TRC].[SALES_TRACING_VAR] (
    [SALES_PERIOD]  VARCHAR (10)     NULL,
    [DIST_NR]       VARCHAR (15)     NULL,
    [DIST_ID]       VARCHAR (48)     NULL,
    [PDI_REC_CNT]   INT              NULL,
    [VC_REC_CNT]    INT              NULL,
    [VAR_REC_CNT]   INT              NULL,
    [PDI_QtySold]   DECIMAL (18, 2)  NULL,
    [VC_QtySold]    DECIMAL (18, 2)  NULL,
    [VAR_QTY_SOLD]  DECIMAL (19, 2)  NULL,
    [PDI_SALESAMT]  DECIMAL (18, 2)  NULL,
    [VC_SALESAMT]   DECIMAL (18, 2)  NULL,
    [VAR_SALES_AMT] DECIMAL (19, 2)  NULL,
    [SLS_VAR_PCT]   DECIMAL (38, 15) NULL
);


GO
GRANT INSERT
    ON OBJECT::[TRC].[SALES_TRACING_VAR] TO [NICEPAK\Sajal.Dutta]
    AS [NICEPAK\htarafder];

