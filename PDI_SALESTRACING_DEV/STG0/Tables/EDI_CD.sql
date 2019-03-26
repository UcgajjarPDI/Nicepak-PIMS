CREATE TABLE [STG0].[EDI_CD] (
    [EDI_CD_ID_PK]           INT          NOT NULL,
    [EDI_TRDNG_PRTNRS_ID_FK] INT          NULL,
    [TP_PDI_ID]              VARCHAR (20) NOT NULL,
    [TP_EDI_ID]              VARCHAR (40) NOT NULL,
    [EDI_ID]                 VARCHAR (10) NOT NULL,
    [SEGMENT]                VARCHAR (20) NOT NULL,
    [PDI_ACTION_CD]          INT          NOT NULL,
    [EDI_HDR_CD]             VARCHAR (10) NOT NULL,
    [EDI_LIN_CD]             VARCHAR (10) NULL
);

