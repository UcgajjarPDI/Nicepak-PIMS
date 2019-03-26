CREATE TABLE [STAGE].[CONT_PRICE] (
    [Contract ID]    VARCHAR (50)    NOT NULL,
    [ITEMID]         VARCHAR (30)    NOT NULL,
    [Contract Price] DECIMAL (38, 2) NULL,
    [Eff Date]       DATE            NULL,
    [Exp Date]       DATE            NULL,
    [nExp Date]      INT             NULL,
    [nEff Date]      INT             NULL
);

