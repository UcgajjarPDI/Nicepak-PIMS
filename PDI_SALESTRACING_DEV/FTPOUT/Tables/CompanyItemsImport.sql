CREATE TABLE [FTPOUT].[CompanyItemsImport] (
    [ITEM_NO]                   VARCHAR (30) NOT NULL,
    [SELL_UOM]                  CHAR (4)     NULL,
    [ITEM_DESCRIPTION]          VARCHAR (50) NULL,
    [EXTRA_ITEM_DESCRIPTION]    VARCHAR (50) NULL,
    [MARKETING_CATEGORY]        VARCHAR (50) NOT NULL,
    [PRODUCT_FAMILY]            VARCHAR (50) NOT NULL,
    [SALES_TEAM]                VARCHAR (50) NULL,
    [SALES_TYPE]                VARCHAR (20) NULL,
    [NEW_PRODUCT_INDICATOR_Y_N] CHAR (1)     NULL,
    [DIVISION_ID]               CHAR (4)     NULL
);

