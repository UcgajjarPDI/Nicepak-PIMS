CREATE TABLE [CMPNY].[CMPNY_TO_ADDR_XREF] (
    [XREF_ID]          INT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_ID]         INT      NULL,
    [SRC_DATA_ID]      INT      NOT NULL,
    [ADDR_ID]          INT      NULL,
    [PRIMARY_ADDR_IN]  CHAR (1) NULL,
    [MLTPL_CMPNY_IN]   CHAR (1) NULL,
    [PRIMARY_CMPNY_IN] CHAR (1) NULL,
    [REC_EFF_DT]       DATE     NULL,
    [REC_EXP_DT]       DATE     NULL,
    [REC_STAT_CD]      CHAR (1) NULL
);

