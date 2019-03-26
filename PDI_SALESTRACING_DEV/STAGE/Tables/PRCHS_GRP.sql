CREATE TABLE [STAGE].[PRCHS_GRP] (
    [PDI_GRP_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [DHC_ID]        INT            NULL,
    [CMS_NM]        NVARCHAR (255) NULL,
    [GRP_NM]        NVARCHAR (255) NULL,
    [Alias]         NVARCHAR (255) NULL,
    [HIN]           NVARCHAR (255) NULL,
    [Address1]      NVARCHAR (255) NULL,
    [City]          NVARCHAR (255) NULL,
    [State]         NVARCHAR (255) NULL,
    [Zip]           VARCHAR (10)   NULL,
    [Mmbr_Hosp_Cnt] INT            NULL,
    [Bed_Cnt]       INT            NULL,
    [GRP_TYPE]      CHAR (3)       NULL,
    [CMPNY_ID]      INT            NULL
);

