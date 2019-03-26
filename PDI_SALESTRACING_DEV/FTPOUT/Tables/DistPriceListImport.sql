CREATE TABLE [FTPOUT].[DistPriceListImport] (
    [DISTID]        VARCHAR (30)   NOT NULL,
    [ITEMID]        VARCHAR (30)   NOT NULL,
    [EFFDATE]       DATE           NOT NULL,
    [EXPDATE]       DATE           NOT NULL,
    [DISTLISTPRICE] DECIMAL (8, 2) NULL
);

