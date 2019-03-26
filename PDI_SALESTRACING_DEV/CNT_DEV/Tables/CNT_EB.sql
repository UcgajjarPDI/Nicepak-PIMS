CREATE TABLE [CNT_DEV].[CNT_EB] (
    [CNT_EB_PK]   INT          IDENTITY (1, 1) NOT NULL,
    [CNT_NR]      VARCHAR (20) NOT NULL,
    [CMPNY_ID]    INT          NULL,
    [REC_EFF_DT]  DATE         NOT NULL,
    [REC_EXP_DT]  DATE         NOT NULL,
    [REC_STAT_CD] CHAR (1)     NOT NULL
);

