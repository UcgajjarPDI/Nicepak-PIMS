﻿CREATE TABLE [STAGE].[PDI_PG_Overview] (
    [HOSPITAL_ID]                        INT            NULL,
    [HOSPITAL_NAME]                      VARCHAR (MAX)  NULL,
    [HQ_ADDRESS]                         VARCHAR (MAX)  NULL,
    [HQ_ADDRESS1]                        VARCHAR (MAX)  NULL,
    [HQ_CITY]                            VARCHAR (MAX)  NULL,
    [HQ_STATE]                           VARCHAR (MAX)  NULL,
    [HQ_COUNTY]                          VARCHAR (MAX)  NULL,
    [HQ_ZIP_CODE]                        INT            NULL,
    [WEBSITE]                            VARCHAR (MAX)  NULL,
    [HQ_PHONE]                           VARCHAR (MAX)  NULL,
    [NETWORK_ID]                         VARCHAR (MAX)  NULL,
    [NETWORK_NAME]                       VARCHAR (MAX)  NULL,
    [NETWORK_PARENT_ID]                  VARCHAR (MAX)  NULL,
    [NETWORK_PARENT_NAME]                VARCHAR (MAX)  NULL,
    [HOSPITAL_PARENT_ID]                 VARCHAR (MAX)  NULL,
    [HOSPITAL_PARENT_NAME]               VARCHAR (MAX)  NULL,
    [GPO_NAME_FOR_EXPORT]                VARCHAR (MAX)  NULL,
    [ACO_NAME_FOR_EXPORT]                VARCHAR (MAX)  NULL,
    [HIE_AFFILIATIONS]                   VARCHAR (MAX)  NULL,
    [CIN_AFFILIATIONS]                   VARCHAR (MAX)  NULL,
    [CBSA_CODE]                          NVARCHAR (100) NULL,
    [NPI_NUMBER]                         INT            NULL,
    [NUMBER_PHYSICIANS_PHYSICIAN_GROUP]  INT            NULL,
    [COMPANY_STATUS]                     VARCHAR (MAX)  NULL,
    [CRM_INTEGRATION_LINK]               VARCHAR (MAX)  NULL,
    [PG_TYPE]                            VARCHAR (MAX)  NULL,
    [FIRM_TYPE]                          VARCHAR (MAX)  NULL,
    [CBSA_POPULATION_EST_MOST_RECENT]    INT            NULL,
    [CBSA_POPULATION_GROWTH_MOST_RECENT] VARCHAR (MAX)  NULL,
    [MANAGEMENT_SERVICE_ORGANIZATION]    VARCHAR (MAX)  NULL,
    [OWNED_LEASED_REAL_ESTATE]           VARCHAR (MAX)  NULL,
    [GROUP_PRACTICE_PAC_ID]              VARCHAR (MAX)  NULL,
    [NUMBER_GROUP_PRACTICE_MEMBERS]      INT            NULL,
    [NUMBER_PHYSICIANS_PHYS_COMP]        INT            NULL,
    [MAIN_SPECIALTY]                     VARCHAR (MAX)  NULL,
    [OTHER_SPECIALTIES]                  VARCHAR (MAX)  NULL,
    [NUMBER_PROCEDURES]                  FLOAT (53)     NULL,
    [MEDICARE_CHARGE_AMT]                FLOAT (53)     NULL,
    [MEDICARE_ALLOWED_AMT]               FLOAT (53)     NULL,
    [MEDICARE_PAYMENT_AMT]               FLOAT (53)     NULL,
    [Meaningful_Use_Percentile]          FLOAT (53)     NULL,
    [Participating_in_PQRS]              VARCHAR (MAX)  NULL,
    [PQRS_PERCENTILE]                    FLOAT (53)     NULL,
    [BPCI_MODEL]                         VARCHAR (MAX)  NULL,
    [CPC_PARTICIPATION]                  VARCHAR (MAX)  NULL,
    [ONCOLOGY_CARE_PARTICIPATION]        VARCHAR (MAX)  NULL
);

