CREATE TABLE [STAGE].[CROTHALL_COMPANY] (
    [CROTHALL_CMPNY_ID]     VARCHAR (20)  NULL,
    [CMPNY_NM]              VARCHAR (255) NULL,
    [ADDR_1]                VARCHAR (255) NULL,
    [ADDR_2]                VARCHAR (255) NULL,
    [CITY]                  VARCHAR (255) NULL,
    [ST]                    CHAR (2)      NULL,
    [ZIP]                   VARCHAR (10)  NOT NULL,
    [ORIG_CMPNY_NM]         VARCHAR (100) NULL,
    [PDI_CROTHALL_CMPNY_ID] INT           IDENTITY (1, 1) NOT NULL,
    [UPD_ADDR1]             VARCHAR (255) NULL,
    [UPD_ADDR2]             VARCHAR (255) NULL,
    [UPD_CITY]              VARCHAR (100) NULL,
    [CMPNY_ID]              INT           NULL
);

