CREATE TABLE [STG0].[PDI_PG_Physicians] (
    [PG_DEF_ID]                         VARCHAR (MAX) NULL,
    [PG_NAME]                           VARCHAR (MAX) NULL,
    [NPI]                               VARCHAR (MAX) NULL,
    [LAST_NAME]                         VARCHAR (MAX) NULL,
    [FIRST_NAME]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                           VARCHAR (MAX) NULL,
    [HQ_STATE]                          VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                       VARCHAR (MAX) NULL,
    [HQ_PHONE]                          VARCHAR (MAX) NULL,
    [MEDICARE_CLAIMS]                   VARCHAR (MAX) NULL,
    [MEDICARE_CHARGE_AMT]               VARCHAR (MAX) NULL,
    [MEDICARE_PAYMENT_AMT]              VARCHAR (MAX) NULL,
    [MEDICARE_ALLOWED_AMT]              VARCHAR (MAX) NULL,
    [SPECIALTY_PRIMARY]                 VARCHAR (MAX) NULL,
    [SPECIALTY_SECONDARY]               VARCHAR (MAX) NULL,
    [PRIMARY_AFFILIATION_HOSPITAL_NAME] VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]                 DATETIME      DEFAULT (getdate()) NOT NULL
);

