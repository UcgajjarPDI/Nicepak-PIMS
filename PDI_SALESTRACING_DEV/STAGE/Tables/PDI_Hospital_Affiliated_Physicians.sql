CREATE TABLE [STAGE].[PDI_Hospital_Affiliated_Physicians] (
    [PRIMARY_AFFILIATION_HOSPITAL_ID]   VARCHAR (MAX) NULL,
    [PRIMARY_AFFILIATION_HOSPITAL_NAME] VARCHAR (MAX) NULL,
    [NPI]                               INT           NULL,
    [FIRST_NAME]                        VARCHAR (MAX) NULL,
    [LAST_NAME]                         VARCHAR (MAX) NULL,
    [HQ_CITY]                           VARCHAR (MAX) NULL,
    [HQ_STATE]                          VARCHAR (MAX) NULL,
    [HQ_PHONE]                          VARCHAR (MAX) NULL,
    [SPECIALTY_PRIMARY]                 VARCHAR (MAX) NULL,
    [MEDICARE_CLAIMS]                   VARCHAR (MAX) NULL,
    [MEDICARE_CHARGE_AMT]               VARCHAR (MAX) NULL,
    [MEDICARE_ALLOWED_AMT]              VARCHAR (MAX) NULL,
    [MEDICARE_PAYMENT_AMT]              VARCHAR (MAX) NULL
);

