CREATE TABLE [STG0].[PDI_ASC_Physician_Referrals] (
    [HOSPITAL_ID]                       VARCHAR (MAX) NULL,
    [HOSPITAL_NAME]                     VARCHAR (MAX) NULL,
    [NPI]                               VARCHAR (MAX) NULL,
    [LAST_NAME]                         VARCHAR (MAX) NULL,
    [FIRST_NAME]                        VARCHAR (MAX) NULL,
    [HQ_CITY]                           VARCHAR (MAX) NULL,
    [HQ_STATE]                          VARCHAR (MAX) NULL,
    [SPECIALTY_PRIMARY]                 VARCHAR (MAX) NULL,
    [PRIMARY_AFFILIATION_HOSPITAL_ID]   VARCHAR (MAX) NULL,
    [PRIMARY_AFFILIATION_HOSPITAL_NAME] VARCHAR (MAX) NULL,
    [CURRENT_TIMESTAMP]                 DATETIME      DEFAULT (getdate()) NOT NULL
);

