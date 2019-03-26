CREATE TABLE [PCM].[PCM_COMM] (
    [PCM_COMM_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [CNT_ID]         INT            NOT NULL,
    [COMM_BY_USR_ID] INT            NOT NULL,
    [COMM]           VARCHAR (4000) NULL,
    [COMM_TYP_ID_FK] INT            NULL,
    [COMM_TYP_CD]    VARCHAR (10)   NULL,
    [RESP_NEED_IN]   CHAR (1)       NULL,
    [CREAT_TS]       DATETIME       NULL,
    [LAST_MOD_TS]    DATETIME       NULL
);

