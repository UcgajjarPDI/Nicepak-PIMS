﻿CREATE TABLE [STAGE].[COMPANY] (
    [COMPANY_ID]         INT           IDENTITY (7000001, 1) NOT NULL,
    [DHC_ID]             INT           NULL,
    [COMPANY_NM]         VARCHAR (255) NULL,
    [COMPANY_ALT_NM]     VARCHAR (255) NULL,
    [ALT_NM_TYP]         VARCHAR (20)  NULL,
    [ADDR_1]             VARCHAR (255) NULL,
    [ADDR_2]             VARCHAR (255) NULL,
    [CITY]               VARCHAR (255) NULL,
    [ST]                 CHAR (2)      NULL,
    [ZIP]                VARCHAR (10)  NOT NULL,
    [CNTRY]              CHAR (3)      NULL,
    [COMPANY_CAT_CD]     VARCHAR (10)  NULL,
    [COMPANY_SUB_CAT_CD] VARCHAR (255) NULL,
    [NTWRK_ID]           INT           NOT NULL,
    [NTWRK_PARENT_ID]    INT           NOT NULL,
    [COMPANY_URL]        VARCHAR (255) NULL,
    [NPI_NR]             VARCHAR (50)  NULL,
    [GLN_NR]             VARCHAR (50)  NULL,
    [HIN_NR]             VARCHAR (50)  NULL,
    [DEA_NR]             VARCHAR (50)  NULL,
    [DHC_STAT]           VARCHAR (40)  NULL,
    [ISSUE_FLG]          VARCHAR (20)  NULL
);
