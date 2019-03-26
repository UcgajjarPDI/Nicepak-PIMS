CREATE TABLE [STAGE].[CONTRAXX_ITM_TEST] (
    [CNT_NR]            VARCHAR (20)    NOT NULL,
    [ITM_NR]            VARCHAR (20)    NOT NULL,
    [ITM_EFF_DT_NR]     INT             NULL,
    [ITM_EXP_DT_NR]     INT             NULL,
    [CNT_PRC]           DECIMAL (18, 2) NULL,
    [UOM]               VARCHAR (10)    NULL,
    [LAST_MOD_DT_NR]    BIGINT          NULL,
    [CURRENT TIMESTAMP] VARCHAR (50)    CONSTRAINT [DF_STAGE_CONTRAXX_ITM_TEST_1] DEFAULT (getdate()) NOT NULL
);

