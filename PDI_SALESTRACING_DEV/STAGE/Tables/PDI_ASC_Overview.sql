﻿CREATE TABLE [STAGE].[PDI_ASC_Overview] (
    [HOSPITAL_ID]                        VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                      VARCHAR (MAX) NULL,
    [PROVIDER_NUMBER]                    VARCHAR (MAX) NULL,
    [NPI_NUMBER]                         VARCHAR (MAX) NULL,
    [FIRM_TYPE]                          VARCHAR (MAX) NULL,
    [HQ_ADDRESS]                         VARCHAR (MAX) NULL,
    [HQ_ADDRESS1]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                            VARCHAR (MAX) NULL,
    [HQ_STATE]                           VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                        VARCHAR (MAX) NULL,
    [HQ_PHONE]                           VARCHAR (MAX) NULL,
    [HQ_REGION]                          VARCHAR (MAX) NULL,
    [HQ_LATITUDE]                        VARCHAR (MAX) NULL,
    [HQ_LONGITUDE]                       VARCHAR (MAX) NULL,
    [HQ_COUNTY]                          VARCHAR (MAX) NULL,
    [FIPS]                               VARCHAR (MAX) NULL,
    [EMRA]                               VARCHAR (MAX) NULL,
    [CBSA_CODE]                          VARCHAR (MAX) NULL,
    [CBSA_POPULATION_EST_MOST_RECENT]    VARCHAR (MAX) NULL,
    [CBSA_POPULATION_GROWTH_MOST_RECENT] VARCHAR (MAX) NULL,
    [WEBSITE]                            VARCHAR (MAX) NULL,
    [CRM_INTEGRATION_LINK]               VARCHAR (MAX) NULL,
    [NUMBER_OPERATING_ROOMS]             VARCHAR (MAX) NULL,
    [ACCREDITATION_AGENCY]               VARCHAR (MAX) NULL,
    [COMPANY_STATUS]                     VARCHAR (MAX) NULL,
    [GEOGRAPHIC_CLASSIFICATION]          VARCHAR (MAX) NULL,
    [GLN]                                VARCHAR (MAX) NULL,
    [HIN]                                VARCHAR (MAX) NULL,
    [TOTAL_CHARGES]                      VARCHAR (MAX) NULL,
    [NUMBER_CLAIMS]                      VARCHAR (MAX) NULL,
    [CHARGE_PER_CLAIM]                   VARCHAR (MAX) NULL,
    [CHARGE_PER_CLAIM_STATE]             VARCHAR (MAX) NULL,
    [CHARGE_PER_CLAIM_NATIONAL]          VARCHAR (MAX) NULL,
    [NETWORK_ID]                         VARCHAR (MAX) NULL,
    [NETWORK_NAME]                       VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]                  VARCHAR (MAX) NULL,
    [NETWORK_PARENT_NAME]                VARCHAR (MAX) NULL,
    [SF_PARENT_ACCOUNT_ID]               VARCHAR (MAX) NULL,
    [SF_PARENT_ACCOUNT_NAME]             VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_ID]                 VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_NAME]               VARCHAR (MAX) NULL,
    [GPO_NAME_FOR_EXPORT]                VARCHAR (MAX) NULL,
    [ACO_NAME_FOR_EXPORT]                VARCHAR (MAX) NULL,
    [HIE_AFFILIATIONS]                   VARCHAR (MAX) NULL,
    [NUMBER_HOSPITALS]                   VARCHAR (MAX) NULL,
    [RELATED_TO_HHA]                     VARCHAR (MAX) NULL,
    [RELATED_TO_IMAGING]                 VARCHAR (MAX) NULL,
    [RELATED_TO_HOSPITAL]                VARCHAR (MAX) NULL,
    [RELATED_TO_ASC]                     VARCHAR (MAX) NULL,
    [RELATED_TO_HOSPICE]                 VARCHAR (MAX) NULL,
    [RELATED_TO_PAYOR]                   VARCHAR (MAX) NULL,
    [RELATED_TO_SNF]                     VARCHAR (MAX) NULL,
    [RELATED_TO_PG]                      VARCHAR (MAX) NULL,
    [PG_PARENT_ID]                       VARCHAR (MAX) NULL,
    [PG_PARENT_NAME]                     VARCHAR (MAX) NULL,
    [GROUP_PRACTICE_PAC_ID]              VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]                  DATETIME      NOT NULL
);

