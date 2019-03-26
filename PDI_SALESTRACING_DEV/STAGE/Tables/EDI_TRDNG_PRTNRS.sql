CREATE TABLE [STAGE].[EDI_TRDNG_PRTNRS] (
    [EDI_TRDNG_PRTNRS_ID_PK] INT           NOT NULL,
    [EDI_ID]                 SMALLINT      NULL,
    [TP_PDI_ID]              VARCHAR (20)  NOT NULL,
    [TP_EDI_ID]              VARCHAR (40)  NOT NULL,
    [TP_NM]                  VARCHAR (100) NOT NULL,
    [DATA_XCHNG_TYP]         CHAR (4)      NOT NULL
);

