CREATE TABLE [PCM].[PCM_WFL_ROLE_TASK] (
    [WFL_TASK_ROLE_ID] INT          NULL,
    [WFL_ID_FK]        INT          NULL,
    [WFL_NM]           VARCHAR (24) NULL,
    [ROLE_ID_FK]       INT          NULL,
    [ROLE]             VARCHAR (24) NULL,
    [TASK_ID_FK]       INT          NULL,
    [TASK_NM]          VARCHAR (24) NULL,
    [ACTIVE_IN]        CHAR (1)     NULL,
    [CREAT_TS]         DATETIME     NULL,
    [LAST_MOD_TS]      DATETIME     NULL
);

