CREATE TABLE [PCM].[PCM_COMM_RESP] (
    [PCM_COMM_RESP_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [PCM_COMM_ID_FK]        INT            NOT NULL,
    [RESP_REQST_FRM_USR_ID] INT            NULL,
    [RESP_NEED_BY_DT]       DATE           NULL,
    [RESP_ACTUAL_DT]        DATE           NULL,
    [RESP]                  VARCHAR (4000) NULL,
    [RESP_REQ_STAT_ID]      INT            NULL,
    [ACTIVE_IN]             CHAR (1)       NULL,
    [CREAT_TS]              DATETIME       NULL,
    [LAST_MOD_TS]           DATETIME       NULL
);

