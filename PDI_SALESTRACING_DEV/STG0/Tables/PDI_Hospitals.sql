﻿CREATE TABLE [STG0].[PDI_Hospitals] (
    [HOSPITAL_ID]           VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]         VARCHAR (MAX) NULL,
    [PROVIDER_NUMBER]       VARCHAR (MAX) NULL,
    [FIRM_TYPE]             VARCHAR (MAX) NULL,
    [HOSPITAL_TYPE]         VARCHAR (MAX) NULL,
    [HQ_ADDRESS]            VARCHAR (MAX) NULL,
    [HQ_ADDRESS1]           VARCHAR (MAX) NULL,
    [HQ_CITY]               VARCHAR (MAX) NULL,
    [HQ_STATE]              VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]           VARCHAR (MAX) NULL,
    [HQ_PHONE]              VARCHAR (MAX) NULL,
    [WEBSITE]               VARCHAR (MAX) NULL,
    [NETWORK_ID]            VARCHAR (MAX) NULL,
    [NETWORK_NAME]          VARCHAR (MAX) NULL,
    [NETWORK_PARENT_ID]     VARCHAR (MAX) NULL,
    [NETOWRK_PARENT_NAME]   VARCHAR (MAX) NULL,
    [FINANCIAL_DATA_DATE]   VARCHAR (MAX) NULL,
    [NUMBER_DISCHARGES]     VARCHAR (MAX) NULL,
    [NUMBER_BEDS]           VARCHAR (MAX) NULL,
    [BED_UTILIZATION]       VARCHAR (MAX) NULL,
    [NUM_OPERATING_ROOMS]   VARCHAR (MAX) NULL,
    [ADJUSTED_PATIENT_DAYS] VARCHAR (MAX) NULL,
    [OUTPATIENT_SURGERIES]  VARCHAR (MAX) NULL,
    [INPATIENT_SUGERIES]    VARCHAR (MAX) NULL,
    [ICU_UTILIZATION_RATE]  VARCHAR (MAX) NULL,
    [CCU_UTILIZATION_RATE]  VARCHAR (MAX) NULL,
    [MAX_ID]                VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]     DATETIME      DEFAULT (getdate()) NOT NULL
);
