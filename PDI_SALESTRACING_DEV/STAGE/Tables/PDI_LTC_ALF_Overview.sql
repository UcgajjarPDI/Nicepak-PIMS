﻿CREATE TABLE [STAGE].[PDI_LTC_ALF_Overview] (
    [HOSPITAL_ID]                        INT           NULL,
    [NPI_NUMBER]                         VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                      VARCHAR (MAX) NULL,
    [FIRM_TYPE]                          VARCHAR (MAX) NULL,
    [HQ_ADDRESS]                         VARCHAR (MAX) NULL,
    [HQ_ADDRESS1]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                            VARCHAR (MAX) NULL,
    [HQ_STATE]                           VARCHAR (MAX) NULL,
    [HQ_COUNTY]                          VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                        INT           NULL,
    [HQ_PHONE]                           VARCHAR (MAX) NULL,
    [NETWORK_ID]                         INT           NULL,
    [NETWORK_NAME]                       VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]                  VARCHAR (MAX) NULL,
    [NETWORK_PARENT_NAME]                VARCHAR (MAX) NULL,
    [CRM_INTEGRATION_LINK]               VARCHAR (MAX) NULL,
    [CBSA_CODE]                          VARCHAR (MAX) NULL,
    [CBSA_POPULATION_EST_MOST_RECENT]    INT           NULL,
    [CBSA_POPULATION_GROWTH_MOST_RECENT] VARCHAR (MAX) NULL,
    [WEBSITE]                            VARCHAR (MAX) NULL,
    [FIPS]                               INT           NULL,
    [FULL_CENSUS_TRACT]                  FLOAT (53)    NULL
);

