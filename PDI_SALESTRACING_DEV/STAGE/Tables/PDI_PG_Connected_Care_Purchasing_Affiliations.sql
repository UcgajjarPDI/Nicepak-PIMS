﻿CREATE TABLE [STAGE].[PDI_PG_Connected_Care_Purchasing_Affiliations] (
    [HOSPITAL_ID]                  INT           NULL,
    [HOSPITAL_NAME]                VARCHAR (MAX) NULL,
    [FIRM_TYPE]                    VARCHAR (MAX) NULL,
    [HQ_CITY]                      VARCHAR (MAX) NULL,
    [HQ_STATE]                     VARCHAR (MAX) NULL,
    [NETWORK_ID]                   INT           NULL,
    [NETWORK_NAME]                 VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]            INT           NULL,
    [NETWORK_PARENT_NAME]          VARCHAR (MAX) NULL,
    [RELATIONSHIP_TYPE]            VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_ID]        INT           NULL,
    [AFFILIATED_ACCOUNT_NAME]      VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_FIRM_TYPE] VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_HQ_CITY]   VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_HQ_STATE]  VARCHAR (MAX) NULL
);

