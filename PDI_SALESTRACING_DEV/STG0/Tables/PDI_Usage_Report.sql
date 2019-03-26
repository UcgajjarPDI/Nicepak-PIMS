CREATE TABLE [STG0].[PDI_Usage_Report] (
    [First Name]        VARCHAR (MAX) NULL,
    [Last Name]         VARCHAR (MAX) NULL,
    [User Name]         VARCHAR (MAX) NULL,
    [Status]            VARCHAR (MAX) NULL,
    [Number of Logins]  VARCHAR (MAX) NULL,
    [Number of Reports] VARCHAR (MAX) NULL,
    [Number of Exports] VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP] DATETIME      DEFAULT (getdate()) NOT NULL
);

