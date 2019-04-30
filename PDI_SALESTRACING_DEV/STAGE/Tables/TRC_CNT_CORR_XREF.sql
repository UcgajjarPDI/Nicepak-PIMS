CREATE TABLE [STAGE].[TRC_CNT_CORR_XREF] (
    [TRC_CNT_ID]     NVARCHAR (255) NULL,
    [PROD_ID]        VARCHAR (20)   NULL,
    [UPD_CNT_ID]     NVARCHAR (255) NULL,
    [UPD_CNT_EXP_DT] DATE           NULL,
    [TRC_CNT_TYP]    CHAR (3)       NULL,
    [RECON_STAT_CD]  CHAR (1)       NULL,
    [RECON_DT]       DATE           NULL,
    [RECON_BY]       INT            NULL,
    [RECON_TYP]      CHAR (3)       NULL,
    [EXCPTN_DT]      DATE           NULL,
    [DAYS_EXPIRED]   INT            NULL,
    [RECON_ACTN]     CHAR (1)       NULL
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'R - Replacement, X - Reject, P - Pass', @level0type = N'SCHEMA', @level0name = N'STAGE', @level1type = N'TABLE', @level1name = N'TRC_CNT_CORR_XREF', @level2type = N'COLUMN', @level2name = N'RECON_ACTN';

