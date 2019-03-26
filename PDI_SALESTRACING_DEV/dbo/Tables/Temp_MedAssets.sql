CREATE TABLE [dbo].[Temp_MedAssets] (
    [MedAssets_Member ID] NVARCHAR (255) NULL,
    [Member Name]         NVARCHAR (255) NULL,
    [Street]              NVARCHAR (255) NULL,
    [City, State]         NVARCHAR (255) NULL,
    [State]               NVARCHAR (255) NULL,
    [Zip code]            NVARCHAR (255) NULL,
    [Contract Number]     NVARCHAR (255) NULL,
    [Distributor]         NVARCHAR (255) NULL,
    [Tracking_Number]     NVARCHAR (255) NULL,
    [Tier_Level]          FLOAT (53)     NULL,
    [Date_Dist# Notified] DATETIME       NULL,
    [Effective_Date]      DATETIME       NULL,
    [Expiration _Date]    DATETIME       NULL,
    [Comments]            NVARCHAR (255) NULL
);

