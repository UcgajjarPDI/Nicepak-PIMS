CREATE TABLE [PDI_MDM].[CNT_ITM] (
    [CNT_ITM_PK]         INT             IDENTITY (1, 1) NOT NULL,
    [REC_EFF_DT]         DATE            NOT NULL,
    [REC_EXP_DT]         DATE            NOT NULL,
    [REC_STAT_CD]        CHAR (1)        NOT NULL,
    [Contract_ID_FK]     INT             NULL,
    [CNT_NR]             VARCHAR (20)    NOT NULL,
    [ITM_ID_FK]          INT             NULL,
    [ITM_NR]             VARCHAR (20)    NOT NULL,
    [ITM_EFF_DT]         DATE            NOT NULL,
    [ITM_EXP_DT]         DATE            NOT NULL,
    [ITM_EFF_DT_NR]      INT             NOT NULL,
    [ITM_EXP_DT_NR]      INT             NOT NULL,
    [ITM_UOM]            CHAR (2)        NOT NULL,
    [ITM_PRC]            DECIMAL (18, 2) NOT NULL,
    [ITM_STAT_CD]        VARCHAR (10)    NULL,
    [SRCE_REC_MOD_DT_NR] BIGINT          NULL
);

