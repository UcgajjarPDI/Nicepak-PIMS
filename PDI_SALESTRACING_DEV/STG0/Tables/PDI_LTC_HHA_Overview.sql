﻿CREATE TABLE [STG0].[PDI_LTC_HHA_Overview] (
    [HOSPITAL_ID]                        VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                      VARCHAR (MAX) NULL,
    [PROVIDER_NUMBER]                    VARCHAR (MAX) NULL,
    [FIRM_TYPE]                          VARCHAR (MAX) NULL,
    [HQ_ADDRESS]                         VARCHAR (MAX) NULL,
    [HQ_ADDRESS1]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                            VARCHAR (MAX) NULL,
    [HQ_STATE]                           VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                        VARCHAR (MAX) NULL,
    [HQ_COUNTY]                          VARCHAR (MAX) NULL,
    [HQ_LATITUDE]                        VARCHAR (MAX) NULL,
    [HQ_LONGITUDE]                       VARCHAR (MAX) NULL,
    [CBSA_CODE]                          VARCHAR (MAX) NULL,
    [CBSA_POPULATION_EST_MOST_RECENT]    VARCHAR (MAX) NULL,
    [CBSA_POPULATION_GROWTH_MOST_RECENT] VARCHAR (MAX) NULL,
    [WEBSITE]                            VARCHAR (MAX) NULL,
    [TYPE_OF_OWNERSHIP]                  VARCHAR (MAX) NULL,
    [DATE_CERTIFIED]                     VARCHAR (MAX) NULL,
    [ACCREDITATION_AGENCY]               VARCHAR (MAX) NULL,
    [BPCI_MODEL]                         VARCHAR (MAX) NULL,
    [CRM_INTEGRATION_LINK]               VARCHAR (MAX) NULL,
    [NPI_NUMBER]                         VARCHAR (MAX) NULL,
    [FINANCIAL_DATA_DATE]                VARCHAR (MAX) NULL,
    [DATE_FISCAL_YEAR_END]               VARCHAR (MAX) NULL,
    [FINANCIAL_DATA_DATE_BEGIN]          VARCHAR (MAX) NULL,
    [TOT_PATIENT_REVENUE]                VARCHAR (MAX) NULL,
    [PATIENT_DISCOUNTS]                  VARCHAR (MAX) NULL,
    [NET_PATIENT_REVENUE]                VARCHAR (MAX) NULL,
    [PCT_PATIENT_DISCOUNTS]              VARCHAR (MAX) NULL,
    [NET_OPERATING_MARGIN]               VARCHAR (MAX) NULL,
    [TOTAL_REVENUE]                      VARCHAR (MAX) NULL,
    [TOT_SALARIES]                       VARCHAR (MAX) NULL,
    [TOT_OPERATING_EXPENSES]             VARCHAR (MAX) NULL,
    [TOT_EMPL_BENE_COSTS]                VARCHAR (MAX) NULL,
    [TOT_COSTS_OTHER]                    VARCHAR (MAX) NULL,
    [TOT_COSTS]                          VARCHAR (MAX) NULL,
    [OPERATING_INCOME]                   VARCHAR (MAX) NULL,
    [TOT_OTHER_INCOME]                   VARCHAR (MAX) NULL,
    [NET_INCOME]                         VARCHAR (MAX) NULL,
    [NET_INCOME_MARGIN]                  VARCHAR (MAX) NULL,
    [CASH_ON_HAND]                       VARCHAR (MAX) NULL,
    [TEMP_INVESTMENTS]                   VARCHAR (MAX) NULL,
    [ACCOUNTS_RECEIVABLE]                VARCHAR (MAX) NULL,
    [DAYS_SALES_OUTSTANDING]             VARCHAR (MAX) NULL,
    [ALLOWANCES_FOR_UNCOLLECTIBLE]       VARCHAR (MAX) NULL,
    [TOT_CURRENT_ASSETS]                 VARCHAR (MAX) NULL,
    [TOT_FIXED_ASSETS]                   VARCHAR (MAX) NULL,
    [TOT_OTHER_ASSETS]                   VARCHAR (MAX) NULL,
    [TOT_ASSETS]                         VARCHAR (MAX) NULL,
    [TOT_CURRENT_LIABILITIES]            VARCHAR (MAX) NULL,
    [LONG_TERM_LIABILTIES]               VARCHAR (MAX) NULL,
    [TOT_LIABILITIES]                    VARCHAR (MAX) NULL,
    [GENERAL_FIND_BALANCE]               VARCHAR (MAX) NULL,
    [TOT_LIABILITIES_FUND_BALANCE]       VARCHAR (MAX) NULL,
    [TOT_FUND_BALANCE]                   VARCHAR (MAX) NULL,
    [LIABILITIES_FUND_BALANCE]           VARCHAR (MAX) NULL,
    [CURRENT_RATIO]                      VARCHAR (MAX) NULL,
    [DEBT_TO_EQUITY_RATIO]               VARCHAR (MAX) NULL,
    [TOTAL_VISITS]                       VARCHAR (MAX) NULL,
    [MEDICARE_VISITS]                    VARCHAR (MAX) NULL,
    [CURRENT_MEDICARE_COST_YEAR]         VARCHAR (MAX) NULL,
    [OTHER_VISITS]                       VARCHAR (MAX) NULL,
    [TOTAL_PATIENTS]                     VARCHAR (MAX) NULL,
    [MEDICARE_PATIENTS]                  VARCHAR (MAX) NULL,
    [OTHER_PATIENTS]                     VARCHAR (MAX) NULL,
    [PATIENT_TRANSPORTATION]             VARCHAR (MAX) NULL,
    [TOTAL_CONTRACT_LABOR]               VARCHAR (MAX) NULL,
    [STAR_RATING]                        VARCHAR (MAX) NULL,
    [SUMMARY_STAR]                       VARCHAR (MAX) NULL,
    [NUMBER_EMPLOYEES]                   VARCHAR (MAX) NULL,
    [NUM_REGISTERED_NURSES]              VARCHAR (MAX) NULL,
    [NETWORK_ID]                         VARCHAR (MAX) NULL,
    [NETWORK_NAME]                       VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]                  VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_ID]                 VARCHAR (MAX) NULL,
    [NETWORK_PARENT_NAME]                VARCHAR (MAX) NULL,
    [HOSPITAL_PARENT_NAME]               VARCHAR (MAX) NULL,
    [RELATED_TO_HOSPITAL]                VARCHAR (MAX) NULL,
    [RELATED_TO_ASC]                     VARCHAR (MAX) NULL,
    [RELATED_TO_PG]                      VARCHAR (MAX) NULL,
    [RELATED_TO_IMAGING]                 VARCHAR (MAX) NULL,
    [RELATED_TO_SNF]                     VARCHAR (MAX) NULL,
    [RELATED_TO_HHA]                     VARCHAR (MAX) NULL,
    [RELATED_TO_HOSPICE]                 VARCHAR (MAX) NULL,
    [RELATED_TO_PAYOR]                   VARCHAR (MAX) NULL,
    [ACO_NAME_FOR_EXPORT]                VARCHAR (MAX) NULL,
    [HIE_AFFILIATIONS]                   VARCHAR (MAX) NULL,
    [CIN_AFFILIATIONS]                   VARCHAR (MAX) NULL,
    [NUMBER_HOSPITALS]                   VARCHAR (MAX) NULL,
    [PG_PARENT_ID]                       VARCHAR (MAX) NULL,
    [SF_PARENT_ACCOUNT_ID]               VARCHAR (MAX) NULL,
    [SF_PARENT_ACCOUNT_NAME]             VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]                  DATETIME      DEFAULT (getdate()) NOT NULL
);
