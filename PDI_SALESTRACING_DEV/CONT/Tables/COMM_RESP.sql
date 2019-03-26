CREATE TABLE [CONT].[COMM_RESP] (
    [COMM_RESP_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [COMM_ID_FK]      INT            NOT NULL,
    [RESP]            VARCHAR (4000) NULL,
    [RESP_DTTS]       DATE           NULL,
    [RESP_USER_ID_FK] INT            NULL,
    [RESP_USER_ID]    VARCHAR (100)  NULL,
    [RESP_BY_USER_ID] VARCHAR (100)  NULL
);

