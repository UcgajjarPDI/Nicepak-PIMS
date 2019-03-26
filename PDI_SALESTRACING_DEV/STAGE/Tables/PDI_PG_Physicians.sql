CREATE TABLE [STAGE].[PDI_PG_Physicians] (
    [PG_DEF_ID]                         INT           NULL,
    [PG_NAME]                           VARCHAR (MAX) NULL,
    [NPI]                               INT           NULL,
    [LAST_NAME]                         VARCHAR (MAX) NULL,
    [FIRST_NAME]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                           VARCHAR (MAX) NULL,
    [HQ_STATE]                          VARCHAR (MAX) NULL,
    [HQ_ZIP_CODE]                       INT           NULL,
    [HQ_PHONE]                          VARCHAR (MAX) NULL,
    [MEDICARE_CLAIMS]                   FLOAT (53)    NULL,
    [MEDICARE_CHARGE_AMT]               FLOAT (53)    NULL,
    [MEDICARE_PAYMENT_AMT]              FLOAT (53)    NULL,
    [MEDICARE_ALLOWED_AMT]              FLOAT (53)    NULL,
    [SPECIALTY_PRIMARY]                 VARCHAR (MAX) NULL,
    [SPECIALTY_SECONDARY]               VARCHAR (MAX) NULL,
    [PRIMARY_AFFILIATION_HOSPITAL_NAME] VARCHAR (MAX) NULL
);

