CREATE TABLE [CNT].[PROD_RATIONALE] (
    [PROD_RATIONALE_ID] INT           IDENTITY (1, 1) NOT NULL,
    [CNT_NR]            VARCHAR (7)   NULL,
    [PROD_ID]           VARCHAR (7)   NULL,
    [RATIONALE]         VARCHAR (500) NULL,
    [REC_EFF_DT]        DATE          NULL,
    [REC_EXP_DT]        DATE          NULL,
    [REC_STAT_CD]       CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([PROD_RATIONALE_ID] ASC)
);

