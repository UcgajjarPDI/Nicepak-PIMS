CREATE TABLE [CONT].[CNT_PROD] (
    [CNT_PROD_PK]        INT             IDENTITY (1, 1) NOT NULL,
    [REC_EFF_DT]         DATE            NOT NULL,
    [REC_EXP_DT]         DATE            NOT NULL,
    [REC_STAT_CD]        CHAR (1)        NOT NULL,
    [Contract_ID_FK]     INT             NULL,
    [CNT_NR]             VARCHAR (20)    NOT NULL,
    [PROD_ID_FK]         INT             NULL,
    [PROD_ID]            VARCHAR (20)    NOT NULL,
    [PROD_EFF_DT]        DATE            NOT NULL,
    [PROD_EXP_DT]        DATE            NOT NULL,
    [PROD_EFF_DT_NR]     INT             NOT NULL,
    [PROD_EXP_DT_NR]     INT             NOT NULL,
    [PROD_UOM]           CHAR (2)        NOT NULL,
    [PROD_PRC]           DECIMAL (18, 2) NOT NULL,
    [PROD_STAT_CD]       VARCHAR (20)    NULL,
    [SRCE_REC_MOD_DT_NR] BIGINT          NULL,
    [CURRENT TIMESTAMP]  DATETIME        NULL
);

