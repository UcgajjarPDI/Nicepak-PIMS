﻿CREATE TABLE [STAGE].[PDI_Hospital_Beds_Breakdown] (
    [HOSPITAL_ID]         INT           NULL,
    [HOSPITAL_NAME]       VARCHAR (MAX) NULL,
    [BED_TYPE]            VARCHAR (MAX) NULL,
    [REVENUES]            FLOAT (53)    NULL,
    [INPATIENT_REVENUE]   VARCHAR (MAX) NULL,
    [OUTPATIENT_REVENUES] FLOAT (53)    NULL,
    [COSTS]               FLOAT (53)    NULL,
    [SALARIES]            FLOAT (53)    NULL,
    [NUMBER_BEDS]         VARCHAR (MAX) NULL,
    [MEDICARE_DAYS]       VARCHAR (MAX) NULL,
    [MEDICAID_DAYS]       VARCHAR (MAX) NULL,
    [OTHER_DAYS]          VARCHAR (MAX) NULL,
    [TOTAL_DAYS]          VARCHAR (MAX) NULL,
    [BED_DAYS_AVAILABLE]  VARCHAR (MAX) NULL,
    [UTILIZATION_RATE]    VARCHAR (MAX) NULL
);

