CREATE TABLE [EDI].[EDI_TRNSFR_CNTRL_TABLE] (
    [EDI_TRNSFR_CNTRL_ID_PK] INT          IDENTITY (1, 1) NOT NULL,
    [TRNSFR_ID]              INT          NULL,
    [TRNSFR_DTE]             DECIMAL (8)  NOT NULL,
    [EDI_NR]                 VARCHAR (10) NOT NULL,
    [NOTFN_PRPS_CD]          CHAR (2)     NOT NULL,
    [SENDER_ID]              VARCHAR (20) NOT NULL,
    [SENDER_NM]              VARCHAR (20) NULL,
    [RCVR_ID]                VARCHAR (20) NULL,
    [RCVR_NM]                VARCHAR (40) NULL,
    [EDI_TYPE]               CHAR (3)     NULL,
    [TRNSFR_STAT]            CHAR (1)     NULL,
    [EDI_FILE_NM]            VARCHAR (60) NULL,
    [TRNSFR_TYP_CD]          CHAR (3)     NULL,
    [TOT_REC_NR]             INT          NULL,
    [Current Timestamp]      DATETIME     NOT NULL
);

