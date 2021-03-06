﻿CREATE TABLE [STAGE].[TRC_ENDUSER_1] (
    [TRC_ENDUSER_1_ID]  INT             IDENTITY (1, 1) NOT NULL,
    [DISTCOID]          VARCHAR (20)    NULL,
    [DISTID]            VARCHAR (8)     NULL,
    [DISTACCTID]        VARCHAR (20)    NULL,
    [DISTACCTSHIPNAME]  VARCHAR (50)    NULL,
    [DISTACCTSHIPADDR1] VARCHAR (50)    NULL,
    [DISTACCTSHIPADDR2] VARCHAR (50)    NULL,
    [DISTACCTSHIPCITY]  VARCHAR (50)    NULL,
    [DISTACCTSHIPSTATE] VARCHAR (2)     NULL,
    [DISTACCTSHIPZIP]   VARCHAR (10)    NULL,
    [COACCTID]          VARCHAR (20)    NULL,
    [COACCTMAX]         VARCHAR (20)    NULL,
    [SALES_SUM]         NUMERIC (38, 2) NULL,
    [ISSUE]             VARCHAR (40)    NULL,
    [UPD_CITY]          VARCHAR (50)    NULL,
    [Cleanse_Flag]      CHAR (1)        NULL,
    [UPD_ADDR1]         VARCHAR (250)   NULL,
    [UPD_ADDR2]         VARCHAR (250)   NULL,
    [COACCTSHIPNAME]    VARCHAR (100)   NULL,
    [COACCTSHIPADDR1]   VARCHAR (100)   NULL,
    [COACCTSHIPADDR2]   VARCHAR (50)    NULL,
    [COACCTSHIPADDR3]   VARCHAR (50)    NULL,
    [COACCTSHIPCITY]    VARCHAR (50)    NULL,
    [COACCTSHIPSTATE]   VARCHAR (2)     NULL,
    [COACCTSHIPZIP]     VARCHAR (10)    NULL,
    [COMPANY_ID]        INT             NULL,
    [Match_by_Addr]     SMALLINT        NULL,
    [Match_by_MAX]      SMALLINT        NULL,
    [Match_by_DQS_NM]   SMALLINT        NULL,
    [Match_by_DQS_Addr] SMALLINT        NULL,
    [COMPANY_ID_MAX]    INT             NULL,
    [PREMISE]           INT             NULL,
    [PREFIX]            VARCHAR (12)    NULL,
    [STRT_NM_PRT_1]     VARCHAR (100)   NULL,
    [RDWY]              VARCHAR (50)    NULL,
    [SUFFIX]            VARCHAR (12)    NULL
);

