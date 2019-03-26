CREATE TABLE [STAGE].[CONT_EDI_TRACING] (
    [dist_id]     VARCHAR (15)    NULL,
    [item_no]     VARCHAR (15)    NULL,
    [qty]         DECIMAL (38, 8) NULL,
    [uom_dis]     VARCHAR (15)    NULL,
    [cs_pr_sys]   DECIMAL (38, 8) NULL,
    [ea_pr]       DECIMAL (38, 8) NULL,
    [total_sales] DECIMAL (38, 2) NULL,
    [total_qty]   DECIMAL (38, 8) NULL,
    [date1]       DATE            NULL,
    [inv]         VARCHAR (15)    NULL
);

