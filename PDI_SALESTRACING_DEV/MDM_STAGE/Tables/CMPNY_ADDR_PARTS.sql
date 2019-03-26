CREATE TABLE [MDM_STAGE].[CMPNY_ADDR_PARTS] (
    [CMPNY_ADDR_ID] INT           IDENTITY (1, 1) NOT NULL,
    [ST_NR]         VARCHAR (100) NULL,
    [ST_NM]         VARCHAR (255) NULL,
    [ST_TYP]        VARCHAR (50)  NULL,
    [ST_DIR]        VARCHAR (50)  NULL,
    [ST_NR_2]       VARCHAR (20)  NULL,
    [BLDG_NR]       VARCHAR (20)  NULL,
    [FL_NR]         VARCHAR (20)  NULL,
    [STE_NR]        VARCHAR (20)  NULL,
    [DIR_1]         VARCHAR (20)  NULL,
    [ADDR_1]        VARCHAR (255) NULL,
    [ADDR_2]        VARCHAR (100) NULL
);

