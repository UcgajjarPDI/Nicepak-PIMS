CREATE TABLE [CONT].[COMMUNICATION] (
    [COMM_ID]           INT            IDENTITY (1, 1) NOT NULL,
    [COMM_BY_USR_ID_FK] VARCHAR (50)   NULL,
    [CNTXT]             VARCHAR (20)   NOT NULL,
    [COMM_USR_ID]       VARCHAR (100)  NULL,
    [COMM]              VARCHAR (4000) NULL,
    [COMM_TYP_CD]       VARCHAR (10)   NULL,
    [RESP_NEED_IN]      CHAR (1)       NULL,
    [RESP_REQ_USR_ID]   VARCHAR (100)  NULL,
    [COMM_DTTS]         DATETIME       NULL
);

