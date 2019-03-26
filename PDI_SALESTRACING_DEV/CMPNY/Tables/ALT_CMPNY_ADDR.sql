CREATE TABLE [CMPNY].[ALT_CMPNY_ADDR] (
    [ALT_CMPNY_ADDR_ID] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_ID]          INT           NOT NULL,
    [SRCE_CMPNY_ID]     VARCHAR (40)  NULL,
    [ADDR1]             VARCHAR (255) NOT NULL,
    [ADDR2]             VARCHAR (255) NULL,
    [CITY]              VARCHAR (100) NOT NULL,
    [ST]                VARCHAR (2)   NOT NULL,
    [ZIP]               VARCHAR (20)  NOT NULL,
    [ALT_ADDR_TYPE]     VARCHAR (10)  NULL,
    [REC_EFF_DT]        DATE          NULL,
    [REC_EXP_DT]        DATE          NULL,
    [REC_STAT_IN]       CHAR (1)      NULL,
    [BLDG_NR]           VARCHAR (10)  NULL,
    [FL_NR]             VARCHAR (10)  NULL,
    [STE_NR]            VARCHAR (10)  NULL
);

