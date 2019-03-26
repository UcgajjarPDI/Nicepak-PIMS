﻿CREATE TABLE [PCM].[PCM_PROD_PRC] (
    [PRODUCT]      VARCHAR (20)    NOT NULL,
    [PRODUCT_DESC] VARCHAR (255)   NOT NULL,
    [LIST_PRICE]   DECIMAL (38, 2) NULL,
    [ASP6]         DECIMAL (38, 2) NOT NULL,
    [ASP12]        DECIMAL (38, 2) NOT NULL,
    [VIZ_PRC]      DECIMAL (38, 2) NOT NULL,
    [AMERI_TIER_1] DECIMAL (38, 2) NOT NULL,
    [AMERI_TIER_2] DECIMAL (38, 2) NOT NULL,
    [HPG_PRC]      DECIMAL (38, 2) NOT NULL,
    [CURR_VOL]     DECIMAL (18)    NULL
);

