CREATE TABLE [STAGE].[TEMP_UPD_ITEM_BKUP] (
    [CNT_NR]             VARCHAR (20)    NOT NULL,
    [ITM_NR]             VARCHAR (20)    NOT NULL,
    [ITM_EFF_DT_NR]      INT             NULL,
    [ITM_EXP_DT_NR]      INT             NULL,
    [ITM_UOM]            VARCHAR (10)    NULL,
    [ITM_PRC]            DECIMAL (18, 2) NULL,
    [SRCE_REC_MOD_DT_NR] BIGINT          NULL,
    [LAST_ITM_EXP_DT_NR] INT             NULL,
    [ITM_STAT_CD]        VARCHAR (20)    NULL
);

