CREATE TABLE [PCM].[PCM_CNT_PND_ITM] (
    [CNT_PND_ITM_PK] INT             IDENTITY (1, 1) NOT NULL,
    [CNT_NR]         VARCHAR (20)    NOT NULL,
    [ITM_NR]         VARCHAR (20)    NOT NULL,
    [ITM_PRC]        DECIMAL (18, 2) NULL,
    [CREATE_DTTS]    DATETIME        NULL
);

