-- =============================================
-- Author:		Keyur
-- Create date: 04/03/2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.family_tree
AS
BEGIN
	
	SET NOCOUNT ON;

   select * from CMPNY.COMPANY c left join CMPNY.COMPANY prn on c.IDN_SRC_ID = prn.IDN_PRNT_SRC_ID
                               left join CMPNY.COMPANY net_prn on prn.IDN_PRNT_SRC_ID = net_prn.IDN_CMPNY_ID
							   left join CMPNY.COMPANY net_sib on net_prn.IDN_CMPNY_ID =net_sib.CMPNY_PRNT_ID
   where c.CMPNY_NM = 'Long Island Jewish Home Care'
END