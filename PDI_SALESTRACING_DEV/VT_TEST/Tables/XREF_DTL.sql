﻿CREATE TABLE [VT_TEST].[XREF_DTL] (
    [Line]               INT           NULL,
    [DistID]             NVARCHAR (50) NULL,
    [ZIP_RAW]            NVARCHAR (50) NULL,
    [ZIP_5]              NVARCHAR (50) NULL,
    [DistAcctID_VT]      NVARCHAR (50) NULL,
    [ZIP_LEN]            INT           NULL,
    [DDS_EDI_ID]         NVARCHAR (50) NULL,
    [DistAcctID_DDS]     NVARCHAR (50) NULL,
    [CoAcctID_VT]        INT           NULL,
    [CoAcctID_DDS]       INT           NULL,
    [COACCT_MATCH_IN]    NVARCHAR (50) NULL,
    [CoAcct_NAME_VT]     NVARCHAR (72) NULL,
    [CoAcct_ADDR1_VT]    NVARCHAR (59) NULL,
    [CoAcct_ADDR2_VT]    NVARCHAR (50) NULL,
    [CoAcct_ADDR3_VT]    NVARCHAR (20) NULL,
    [CoAcct_CITY_VT]     NVARCHAR (52) NULL,
    [CoAcct_STATE_VT]    NVARCHAR (50) NULL,
    [CoAcct_ZIP_VT]      NVARCHAR (50) NULL,
    [DistAcct_NAME_VT]   NVARCHAR (65) NULL,
    [DistAcct_ADDR1_VT]  NVARCHAR (64) NULL,
    [DistAcct_VT_ADDR2]  NVARCHAR (60) NULL,
    [DistAcct_VT_ADDR3]  NVARCHAR (52) NULL,
    [DistAcct_VT_CITY]   NVARCHAR (50) NULL,
    [DistAcct_VT_STATE]  NVARCHAR (50) NULL,
    [DistAcct_VT_ZIP]    NVARCHAR (50) NULL,
    [CoAcct_NAME_DDS]    NVARCHAR (75) NULL,
    [CoAcct_ADDR1_DDS]   NVARCHAR (64) NULL,
    [CoAcct_ADDR2_DDS]   NVARCHAR (60) NULL,
    [CoAcct_ADDR3_DDS]   NVARCHAR (20) NULL,
    [CoAcct_CITY_DDS]    NVARCHAR (52) NULL,
    [CoAcctI_STATE_DDS]  NVARCHAR (50) NULL,
    [CoAcct_ZIP_DDS]     NVARCHAR (50) NULL,
    [DistAcct_DDS_NAME]  NVARCHAR (65) NULL,
    [DistAcct_DDS_ADDR1] NVARCHAR (64) NULL,
    [DistAcct_DDS_ADDR2] NVARCHAR (60) NULL,
    [DistAcct_DDS_ADDR3] NVARCHAR (52) NULL,
    [DistAcct_DDS_CITY]  NVARCHAR (50) NULL,
    [DistAcct_DDS_STATE] NVARCHAR (50) NULL,
    [DistAcct_DDS_ZIP]   NVARCHAR (50) NULL,
    [RAW_NAME_MATCH]     NVARCHAR (50) NULL,
    [RAW_ADDR1_MATCH]    NVARCHAR (50) NULL,
    [RAW_ADDR2_MATCH]    NVARCHAR (50) NULL,
    [RAW_ADDR3_MATCH]    NVARCHAR (50) NULL,
    [RAW_CITY_MATCH]     NVARCHAR (50) NULL,
    [RAW_STATE_MATCH]    NVARCHAR (50) NULL,
    [RAW_ZIP_MATCH]      NVARCHAR (50) NULL,
    [COACCT_NAME_MATCH]  NVARCHAR (50) NULL,
    [COACCT_ADDR1_MATCH] NVARCHAR (50) NULL,
    [COACCT_ADDR2_MATCH] NVARCHAR (50) NULL,
    [COACCT_CITY_MATCH]  NVARCHAR (50) NULL,
    [COACCT_STATE_MATCH] NVARCHAR (50) NULL,
    [COACCT_ZIP_MATCH]   NVARCHAR (50) NULL
);

