CREATE TABLE [STAGE].[TEMP_DDI_2018_2] (
    [SHPTO_NM]     VARCHAR (200) NULL,
    [SHPTO_ADDR_1] VARCHAR (100) NULL,
    [SHPTO_ADDR_2] VARCHAR (100) NULL,
    [UPD_CITY]     VARCHAR (200) NULL,
    [UPD_ST]       CHAR (2)      NULL,
    [UPD_ZIP]      CHAR (5)      NULL,
    [SALES]        FLOAT (53)    NULL,
    [ID]           INT           IDENTITY (1, 1) NOT NULL
);

