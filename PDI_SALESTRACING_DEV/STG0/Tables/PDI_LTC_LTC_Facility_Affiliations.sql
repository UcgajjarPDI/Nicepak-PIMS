﻿CREATE TABLE [STG0].[PDI_LTC_LTC_Facility_Affiliations] (
    [HOSPITAL_ID]                  VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                VARCHAR (MAX) NULL,
    [FIRM_TYPE]                    VARCHAR (MAX) NULL,
    [HQ_CITY]                      VARCHAR (MAX) NULL,
    [HQ_STATE]                     VARCHAR (MAX) NULL,
    [NETWORK_ID]                   VARCHAR (MAX) NULL,
    [NETWORK_NAME]                 VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]            VARCHAR (MAX) NULL,
    [NETWORK_PARENT_NAME]          VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_ID]        VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_NAME]      VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_FIRM_TYPE] VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_HQ_CITY]   VARCHAR (MAX) NULL,
    [AFFILIATED_ACCOUNT_HQ_STATE]  VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]            DATETIME      DEFAULT (getdate()) NOT NULL
);

