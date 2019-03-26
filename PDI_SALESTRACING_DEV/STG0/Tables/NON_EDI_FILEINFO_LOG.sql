CREATE TABLE [STG0].[NON_EDI_FILEINFO_LOG] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [FolderPath]        VARCHAR (255) NULL,
    [FileName]          VARCHAR (255) NULL,
    [SheetName]         VARCHAR (255) NULL,
    [Rows]              INT           NULL,
    [LastDateModified]  DATETIME      NULL,
    [LastAccessTime]    DATETIME      NULL,
    [FileSizeinKB]      INT           NULL,
    [CURRENT TIMESTAMP] VARCHAR (50)  DEFAULT (getdate()) NOT NULL
);

