CREATE TABLE [REF].[ZIP_CODE] (
    [ZIP_CODE_ID_PK]      INT              IDENTITY (1, 1) NOT NULL,
    [Zipcode]             VARCHAR (20)     NULL,
    [City]                VARCHAR (255)    NULL,
    [State]               VARCHAR (255)    NULL,
    [Latitude]            DECIMAL (28, 10) NULL,
    [Longitude]           DECIMAL (28, 10) NULL,
    [ZipCodeType]         VARCHAR (40)     NULL,
    [LocationType]        VARCHAR (20)     NULL,
    [TaxReturnsFiled]     INT              NULL,
    [EstimatedPopulation] INT              NULL,
    [TotalWages]          VARCHAR (255)    NULL,
    [Notes]               VARCHAR (255)    NULL
);

