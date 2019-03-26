CREATE TABLE [PCM].[PCM_CNT_TASK] (
    [CNT_TASK_ID]      INT      NULL,
    [CNT_ID]           INT      NULL,
    [USR_ID]           INT      NULL,
    [ASGN_DT_TS]       DATETIME NULL,
    [ASSGN_BY_USER_ID] INT      NULL,
    [CMPLT_BY_DT]      DATE     NULL,
    [TASK_STAT_CD]     INT      NULL,
    [TASK_ACTIVE_IN]   CHAR (1) NULL,
    [CREAT_TS]         DATETIME NULL,
    [LAST_MOD_TS]      DATETIME NULL
);

