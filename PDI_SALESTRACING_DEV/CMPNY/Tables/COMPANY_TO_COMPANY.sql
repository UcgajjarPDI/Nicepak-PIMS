CREATE TABLE [CMPNY].[COMPANY_TO_COMPANY] (
    [CMPNY_TO_CMPNY_ID] INT      IDENTITY (1, 1) NOT NULL,
    [CMPNY_TO_ID]       INT      NOT NULL,
    [CMPNY_ID]          INT      NOT NULL,
    [RLTN_TYP_ID]       INT      NOT NULL,
    [REC_EFF_DT]        DATE     NULL,
    [REC_EXP_DT]        DATE     NULL,
    [REC_STAT_IN]       CHAR (1) NULL
);

