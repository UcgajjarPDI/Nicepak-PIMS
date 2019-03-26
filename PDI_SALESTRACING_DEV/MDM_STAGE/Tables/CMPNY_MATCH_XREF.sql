CREATE TABLE [MDM_STAGE].[CMPNY_MATCH_XREF] (
    [CMPNY_MATCH_XREF_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [SRC_TYP]              VARCHAR (10)  NULL,
    [SRC_ID]               VARCHAR (10)  NULL,
    [SRC_NM]               VARCHAR (50)  NULL,
    [SRC_ACCT_ID]          VARCHAR (10)  NULL,
    [SRC_DATA_ID]          INT           NULL,
    [MTCH_To_TYPE]         VARCHAR (10)  NULL,
    [MTCH_To_ID]           INT           NULL,
    [MTCH_To_CMPNY_NM]     VARCHAR (150) NULL,
    [MTCH_To_CMPNY_ADDR_1] VARCHAR (150) NULL,
    [MTCH_To_CMPNY_ADDR_2] VARCHAR (100) NULL,
    [MTCH_To_CMPNY_CITY]   VARCHAR (100) NULL,
    [MTCH_To_CMPNY_STATE]  CHAR (2)      NULL,
    [MTCH_To_CMPNY_ZIP]    VARCHAR (10)  NULL,
    [UNMATCH_REASON]       VARCHAR (20)  NULL
);

