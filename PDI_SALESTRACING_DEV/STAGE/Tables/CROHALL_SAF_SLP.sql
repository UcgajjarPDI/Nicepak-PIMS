CREATE TABLE [STAGE].[CROHALL_SAF_SLP] (
    [Year_Month]   VARCHAR (6)     NULL,
    [ENDUSER_ID]   VARCHAR (150)   NOT NULL,
    [ENDUSER_NAME] VARCHAR (150)   NULL,
    [COACCTID]     VARCHAR (20)    NULL,
    [COACCTMAX]    VARCHAR (20)    NULL,
    [ADDR1]        VARCHAR (250)   NULL,
    [ADDR2]        VARCHAR (250)   NULL,
    [CITY]         VARCHAR (50)    NULL,
    [ST]           VARCHAR (2)     NULL,
    [ZIP]          VARCHAR (10)    NULL,
    [COITEMID]     VARCHAR (30)    NULL,
    [SLS_2018]     NUMERIC (38, 2) NULL
);

