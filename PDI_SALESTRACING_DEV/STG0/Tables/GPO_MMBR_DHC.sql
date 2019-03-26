CREATE TABLE [STG0].[GPO_MMBR_DHC] (
    [GPO_MMBR_DHC_ID] INT           IDENTITY (1, 1) NOT NULL,
    [GPO_NM]          VARCHAR (MAX) NULL,
    [DHC_ID]          INT           NULL,
    [CMPNY_NM]        VARCHAR (MAX) NULL,
    [REL_TYP]         VARCHAR (MAX) NULL,
    [CMPNY_TYP]       VARCHAR (MAX) NULL,
    [ADDR1]           VARCHAR (MAX) NULL,
    [ADDR2]           VARCHAR (MAX) NULL,
    [CITY]            VARCHAR (MAX) NULL,
    [ST]              VARCHAR (20)  NULL,
    [ZIP]             VARCHAR (20)  NULL,
    [TEL_NR]          VARCHAR (20)  NULL,
    [NTWROK_ID]       INT           NULL,
    [NTWRK_NM]        VARCHAR (MAX) NULL,
    [NTWRK_PRNT_ID]   INT           NULL,
    [NTWRK_PRNT_NM]   VARCHAR (MAX) NULL
);

