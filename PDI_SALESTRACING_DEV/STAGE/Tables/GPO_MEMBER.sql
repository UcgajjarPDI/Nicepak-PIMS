CREATE TABLE [STAGE].[GPO_MEMBER] (
    [PDI_GPO_MMBR_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [GPO_CMPNY_ID]          INT           NULL,
    [GPO_NM]                VARCHAR (255) NULL,
    [SRC_GPO_MEMBER_ID]     VARCHAR (50)  NULL,
    [SRC_GPO_MEMBER_ALT_ID] VARCHAR (50)  NULL,
    [MMBR_NM]               VARCHAR (255) NULL,
    [MMBR_ADDR_1]           VARCHAR (255) NULL,
    [MMBR_ADDR_2]           VARCHAR (255) NULL,
    [MMBR_CITY]             VARCHAR (255) NULL,
    [MMBR_ST]               CHAR (2)      NULL,
    [MMBR_ZIP]              VARCHAR (10)  NULL,
    [MMBR_CNTRY]            CHAR (3)      NULL,
    [GLN_NR]                VARCHAR (50)  NULL,
    [HIN_NR]                VARCHAR (50)  NULL,
    [DEA_NR]                VARCHAR (50)  NULL,
    [NPI_NR]                VARCHAR (50)  NULL,
    [MMBR_EFF_DT]           DATE          NULL,
    [MMBR_EXP_DT]           DATE          NULL,
    [MMB_ACT_STAT_CD]       CHAR (1)      NULL,
    [MMBR_STATUS]           VARCHAR (20)  NULL,
    [GPO_MEMBER_PARENT_ID]  VARCHAR (50)  NULL,
    [GPO_MEMBER_PARENT_NM]  VARCHAR (255) NULL,
    [GPO_MEMBER_LIC_NR]     VARCHAR (50)  NULL,
    [MMBR_SGMNT]            VARCHAR (100) NULL,
    [CURRENT TIMESTAMP]     VARCHAR (50)  DEFAULT (getdate()) NOT NULL,
    [PRCS_IN]               CHAR (1)      DEFAULT ('P') NOT NULL,
    [UPD_ADDR1]             VARCHAR (255) NULL,
    [UPD_ADDR2]             VARCHAR (255) NULL
);





