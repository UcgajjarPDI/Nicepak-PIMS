﻿CREATE TABLE [MDM_STAGE].[TEMP_ADDR] (
    [SRC_ID]       INT           NOT NULL,
    [SRC_CNTXT_ID] INT           NULL,
    [ADDR_1]       VARCHAR (255) NULL,
    [ADDR_2]       VARCHAR (255) NULL,
    [ST_NR]        VARCHAR (100) NULL,
    [DIR_1]        VARCHAR (20)  NULL,
    [ST_NR_2]      VARCHAR (10)  NULL,
    [ST_NM]        VARCHAR (255) NULL,
    [ST_TYP]       VARCHAR (100) NULL,
    [HWY_NR]       VARCHAR (50)  NULL,
    [DIR_2]        VARCHAR (20)  NULL,
    [ADDR_TYP]     VARCHAR (50)  NULL,
    [BLDG_NR]      VARCHAR (50)  NULL,
    [FL_NR]        VARCHAR (50)  NULL,
    [STE_NR]       VARCHAR (50)  NULL,
    [ZIP]          VARCHAR (10)  NULL,
    [LW_1]         VARCHAR (100) NULL,
    [LW_2]         VARCHAR (100) NULL,
    [STAT_1_CD]    SMALLINT      NULL,
    [STAT_2_CD]    SMALLINT      NULL,
    [WB_1]         VARCHAR (200) NULL,
    [WB_2]         VARCHAR (200) NULL,
    [WC_1]         VARCHAR (200) NULL,
    [WC_2]         VARCHAR (100) NULL,
    [HWY_IN]       CHAR (1)      NULL,
    [UPD_ADDR1]    VARCHAR (200) NULL,
    [UPD_ADDR2]    VARCHAR (50)  NULL,
    [ORIG_NM]      VARCHAR (200) NULL,
    [UPD_NM]       VARCHAR (200) NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GPO company ID - to make the src-id - (gopo member id) unique', @level0type = N'SCHEMA', @level0name = N'MDM_STAGE', @level1type = N'TABLE', @level1name = N'TEMP_ADDR', @level2type = N'COLUMN', @level2name = N'SRC_CNTXT_ID';

