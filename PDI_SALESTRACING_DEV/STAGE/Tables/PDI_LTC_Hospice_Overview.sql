﻿CREATE TABLE [STAGE].[PDI_LTC_Hospice_Overview] (
    [HOSPITAL_ID]                        INT           NULL,
    [PROVIDER_NUMBER]                    VARCHAR (MAX) NULL,
    [NPI_NUMBER]                         VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                      VARCHAR (MAX) NULL,
    [FIRM_TYPE]                          VARCHAR (MAX) NULL,
    [HQ_ADDRESS]                         VARCHAR (MAX) NULL,
    [HQ_CITY]                            VARCHAR (MAX) NULL,
    [HQ_STATE]                           VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                        INT           NULL,
    [HQ_PHONE]                           VARCHAR (MAX) NULL,
    [DATE_FISCAL_YEAR_END]               VARCHAR (MAX) NULL,
    [NUM_REGISTERED_NURSES]              VARCHAR (MAX) NULL,
    [NETWORK_ID]                         INT           NULL,
    [NETWORK_NAME]                       VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]                  VARCHAR (MAX) NULL,
    [NETWORK_PARENT_NAME]                VARCHAR (MAX) NULL,
    [CRM_INTEGRATION_LINK]               VARCHAR (MAX) NULL,
    [CBSA_CODE]                          VARCHAR (MAX) NULL,
    [CBSA_POPULATION_EST_MOST_RECENT]    INT           NULL,
    [CBSA_POPULATION_GROWTH_MOST_RECENT] VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_ID]                 VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_NAME]               VARCHAR (MAX) NULL,
    [WEBSITE]                            VARCHAR (MAX) NULL,
    [NUMBER_HOSPITALS]                   VARCHAR (MAX) NULL,
    [HQ_COUNTY]                          VARCHAR (MAX) NULL,
    [HQ_REGION]                          VARCHAR (MAX) NULL,
    [TOT_MEDICARE_CLAIMS]                VARCHAR (MAX) NULL,
    [TOT_MEDICARE_CHARGES]               VARCHAR (MAX) NULL,
    [HQ_ADDRESS1]                        VARCHAR (MAX) NULL,
    [TOT_MEDICARE_PAYMENTS]              VARCHAR (MAX) NULL,
    [BPCI_MODEL]                         VARCHAR (MAX) NULL,
    [HQ_LATITUDE]                        FLOAT (53)    NULL,
    [HQ_LONGITUDE]                       FLOAT (53)    NULL,
    [DATE_ENTERED]                       DATETIME2 (7) NULL,
    [SF_PARENT_ACCOUNT_ID]               INT           NULL,
    [SF_PARENT_ACCOUNT_NAME]             VARCHAR (MAX) NULL,
    [COMPANY_STATUS]                     VARCHAR (MAX) NULL,
    [FINANCIAL_DATA_DATE]                VARCHAR (MAX) NULL,
    [HOSPITAL_OWNERSHIP]                 VARCHAR (MAX) NULL,
    [related_to_hospital]                VARCHAR (MAX) NULL,
    [related_to_asc]                     VARCHAR (MAX) NULL,
    [related_to_pg]                      VARCHAR (MAX) NULL,
    [related_to_imaging]                 VARCHAR (MAX) NULL,
    [related_to_snf]                     VARCHAR (MAX) NULL,
    [related_to_hha]                     VARCHAR (MAX) NULL,
    [related_to_hospice]                 VARCHAR (MAX) NULL,
    [related_to_payor]                   VARCHAR (MAX) NULL,
    [ACCREDITATION_AGENCY]               VARCHAR (MAX) NULL,
    [ALLOWANCES_FOR_UNCOLLECTIBLE]       VARCHAR (MAX) NULL,
    [AVG_DAILY_CENSUS]                   VARCHAR (MAX) NULL,
    [CASH_ON_HAND]                       VARCHAR (MAX) NULL,
    [TEMP_INVESTMENTS]                   VARCHAR (MAX) NULL,
    [Accounts_Receivable]                VARCHAR (MAX) NULL,
    [TOT_CURRENT_ASSETS]                 VARCHAR (MAX) NULL,
    [TOT_FIXED_ASSETS]                   VARCHAR (MAX) NULL,
    [TOT_OTHER_ASSETS]                   VARCHAR (MAX) NULL,
    [TOT_ASSETS]                         VARCHAR (MAX) NULL,
    [AVE_LOS]                            VARCHAR (MAX) NULL,
    [AVE_LOS_TITLE_XVIII]                VARCHAR (MAX) NULL,
    [AVE_LOS_TITLE_XIX]                  VARCHAR (MAX) NULL,
    [ADMISSIONS]                         VARCHAR (MAX) NULL,
    [ADMISSIONS_TITLE_XVIII]             VARCHAR (MAX) NULL,
    [ADMISSIONS_TITLE_XIX]               VARCHAR (MAX) NULL,
    [inventory]                          VARCHAR (MAX) NULL,
    [TOTAL_DEDUCTIONS]                   VARCHAR (MAX) NULL,
    [TOT_Operating_expenses]             VARCHAR (MAX) NULL,
    [TOT_Deductions]                     VARCHAR (MAX) NULL,
    [net_income]                         VARCHAR (MAX) NULL,
    [TOTAL_GENERAL_INPATIENT_REV]        VARCHAR (MAX) NULL,
    [GPO_NAME_FOR_EXPORT]                VARCHAR (MAX) NULL
);
