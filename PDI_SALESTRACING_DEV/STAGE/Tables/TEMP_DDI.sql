﻿CREATE TABLE [STAGE].[TEMP_DDI] (
    [SALES_PERIOD] VARCHAR (10)  NULL,
    [DIST_ID]      VARCHAR (48)  NULL,
    [SHPTO_ID]     VARCHAR (20)  NULL,
    [SHPTO_NM]     VARCHAR (200) NULL,
    [SHPTO_ADDR_1] VARCHAR (100) NULL,
    [SHPTO_ADDR_2] VARCHAR (100) NULL,
    [SHPTO_CITY]   VARCHAR (100) NULL,
    [SHPTO_ST]     VARCHAR (10)  NULL,
    [SHPTO_ZIP]    VARCHAR (12)  NULL,
    [UPD_PROD_ID]  VARCHAR (48)  NULL,
    [SALES]        FLOAT (53)    NULL,
    [TERRITORY]    VARCHAR (200) NULL,
    [UPD_ADDR_1]   VARCHAR (200) NULL,
    [UPD_ADDR_2]   VARCHAR (200) NULL,
    [UPD_ZIP]      CHAR (5)      NULL,
    [UPD_ST]       CHAR (2)      NULL,
    [PROD_DESC]    VARCHAR (200) NULL,
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [UPD_CITY]     VARCHAR (200) NULL
);

