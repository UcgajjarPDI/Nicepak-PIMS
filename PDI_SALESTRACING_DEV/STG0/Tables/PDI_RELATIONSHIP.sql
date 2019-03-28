﻿CREATE TABLE [STG0].[PDI_RELATIONSHIP] (
    [COMPANYID]         VARCHAR (MAX) NULL,
    [PARENTCOMPANYID]   VARCHAR (MAX) NULL,
    [RELATIONSHIPTYPE]  VARCHAR (MAX) NULL,
    [PARENTIDNCOUNT]    VARCHAR (MAX) NULL,
    [DISTANCETOCHILD]   VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP] DATETIME      DEFAULT (getdate()) NOT NULL
);
