CREATE TABLE [CMPNY].[SHPTO] (
    [SHPTO_ID]           INT           IDENTITY (1, 1) NOT NULL,
    [SHPTO_NM]           VARCHAR (255) NOT NULL,
    [SHPTO_ADDR_1]       VARCHAR (255) NULL,
    [SHPTO_ADDR_2]       VARCHAR (255) NULL,
    [SHPTO_CITY]         VARCHAR (255) NULL,
    [SHPTO_ST]           CHAR (2)      NULL,
    [SHPTO_ZIP]          VARCHAR (10)  NOT NULL,
    [SHPTO_CNTRY]        CHAR (3)      NULL,
    [SHPTO_TYP_ID]       SMALLINT      NULL,
    [SHPTO_CTGRY_ID]     SMALLINT      NULL,
    [SHPTO_SGMNT_ID]     SMALLINT      NULL,
    [SHPTO_SUB_SGMNT_ID] SMALLINT      NULL,
    [NPI_NR]             VARCHAR (50)  NULL,
    [GLN_NR]             VARCHAR (50)  NULL,
    [HIN_NR]             VARCHAR (50)  NULL,
    [DEA_NR]             VARCHAR (50)  NULL,
    [REC_EFF_DT]         DATE          NULL,
    [REC_EXP_DT]         DATE          NULL,
    [REC_STAT_IN]        CHAR (1)      NULL
);

