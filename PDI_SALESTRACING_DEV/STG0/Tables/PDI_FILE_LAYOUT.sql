CREATE TABLE [STG0].[PDI_FILE_LAYOUT] (
    [File]              VARCHAR (MAX) NULL,
    [Field]             VARCHAR (MAX) NULL,
    [Description]       VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP] DATETIME      DEFAULT (getdate()) NOT NULL
);

