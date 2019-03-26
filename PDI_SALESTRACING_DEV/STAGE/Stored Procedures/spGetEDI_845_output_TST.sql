-- =============================================
-- Author:           <Author,,Name>
-- Create date: <Create Date,,>
-- Description:      <Description,,>
-- =============================================
CREATE PROCEDURE [STAGE].[spGetEDI_845_output_TST]
       ( @RCVR_ID varchar(20), @TRNSFR_ID int)
WITH EXEC AS CALLER
AS
BEGIN
       SELECT 
  C.SENDER_ID AS [Sender ID], C.RCVR_ID AS [Receiver ID], 
  EH.EDI_HDR_CD AS [Notification Purpose Code], C.TRNSFR_DTE AS [Notification Date],
  [MF Contract Number], [Contract Status Code], [Buyer Group Contract Number], [MF Contract Name], [Previous Contract Number],
  [Contract Effective Date], [Contract Expiration Date], [Replaced Contract Expiration Date], [Contract Tier Number],
  [Buyer Group Name], [Eligible Buyer Name], [Manufacturer Name], [Buyer Group HIN], [Manufacturer HIN], 
  [Eligible Buyer Account Number], [Eligible Buyer GPO Account Number], 
  [Eligible Buyer Address 1], [Eligible Buyer Address 2], [Eligible Buyer City], [Eligible Buyer State], [Eligible Buyer Zip],
  [Eligible Buyer Country Code], 
  T.[Update Reason Code],
  [Eligible Buyer Effective Date], [Eligible Buyer Expiration Date], 
  EH.EDI_LIN_CD
  [Item Description], [Manufacturers Item ID], 
  [Contract Unit Price], [Quantity Information], [Unit of Measure], [Product Effective Date], [Product Expiration Date], T.[Orig Contract Expiration Date],
  '310819000000' AS [Manufacturer GLN]
  FROM [EDI].[EDI845_TRANSFER_TMPLT_TST] T
  JOIN [EDI].[EDI_TRNSFR_CNTRL_TABLE_TST] C ON T.[Transfer ID] = C.TRNSFR_ID
  JOIN EDI.EDI_CD EH ON T.[PDI Action Code] = EH.PDI_ACTION_CD AND C.RCVR_ID = EH.TP_EDI_ID
  WHERE C.TRNSFR_STAT = 'P' AND C.TRNSFR_TYP_CD = 'SND' and c.RCVR_ID=@RCVR_ID and c.TRNSFR_ID=@TRNSFR_ID 
  ORDER BY C.RCVR_ID, C.NOTFN_PRPS_CD
END