﻿CREATE TABLE [STAGE].[DIST_PRICE_ORIG] (
    [DISTID]   VARCHAR (30)   NOT NULL,
    [ITEMID]   VARCHAR (30)   NOT NULL,
    [EFFDATE]  DECIMAL (8)    NOT NULL,
    [EXPDATE]  DECIMAL (8)    NOT NULL,
    [CS_PRICE] DECIMAL (8, 2) NULL,
    [BX_PRICE] DECIMAL (8, 2) NULL,
    [EA_PRICE] DECIMAL (8, 2) NULL
);

