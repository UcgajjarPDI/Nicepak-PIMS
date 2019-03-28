﻿CREATE TABLE [STG0].[PDI_RELATIONSHIP_FILE] (
    [COMAPNY_ID]        VARCHAR (MAX) NULL,
    [PARENTCOMPANYID]   VARCHAR (MAX) NULL,
    [RELATIONSHIPTYPE]  VARCHAR (MAX) NULL,
    [PARENTIDCOUNT]     VARCHAR (MAX) NULL,
    [DISTANCETOCHILD]   VARCHAR (MAX) NULL,
    [HOSPITAL_ID]       VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP] DATETIME      DEFAULT (getdate()) NOT NULL
);
