-- HABIB query to output EDI845
create  proc [dbo].[usp_sql_to_output_EDI845]
as

SELECT 
  C.SENDER_ID AS [Sender ID], C.RCVR_ID AS [Receiver ID], 
  C.NOTFN_PRPS_CD AS [Notification Purpose Code], C.TRNSFR_DTE AS [Notification Date],
  [MF Contract Number], [Contract Status Code], [Buyer Group Contract Number], [MF Contract Name], [Previous Contract Number],
  [Contract Effective Date], [Contract Expiration Date], [Replaced Contract Expiration Date], [Contract Tier Number],
  [Buyer Group Name], [Eligible Buyer Name], [Manufacturer Name], [Buyer Group HIN], [Manufacturer HIN], 
  [Eligible Buyer Account Number], [Eligible Buyer GPO Account Number], 
  [Eligible Buyer Address 1], [Eligible Buyer Address 2], [Eligible Buyer City], [Eligible Buyer State], [Eligible Buyer Zip],
  [Eligible Buyer Country Code], 
  CASE WHEN E.SEGMENT = 'Eligible Buyer' THEN E.EDI_LIN_CD ELSE NULL END AS[Update Reason Code], 
  [Eligible Buyer Effective Date], [Eligible Buyer Expiration Date], 
  CASE WHEN E.SEGMENT = 'Product' THEN E.EDI_LIN_CD ELSE NULL END AS [Item Update Type Code], [Item Description], [Manufacturers Item ID], 
  [Contract Unit Price], [Quantity Information], [Unit of Measure], [Product Effective Date], [Product Expiration Date], T.[Orig Contract Expiration Date]
  FROM [PDI_SALESTRACING_TEST].[STAGE].[EDI845_TRANSFER_TMPLT] T
  JOIN [PDI_SALESTRACING_TEST].[STAGE].[EDI_TRNSFR_CNTRL_TABLE] C ON T.[Transfer ID] = C.TRNSFR_ID
  JOIN PDI_SALESTRACING_TEST.STAGE.EDI_CD E ON T.[PDI Action Code] = E.PDI_ACTION_CD AND C.RCVR_ID = E.TP_EDI_ID
  WHERE C.TRNSFR_STAT = 'P' AND C.TRNSFR_TYP_CD = 'SND' --AND C.TRNSFR_ID > 1
  ORDER BY C.RCVR_ID, C.NOTFN_PRPS_CD
