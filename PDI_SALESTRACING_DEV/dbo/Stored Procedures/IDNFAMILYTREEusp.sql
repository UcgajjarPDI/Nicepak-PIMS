﻿CREATE PROCEDURE IDNFAMILYTREEusp 
AS

BEGIN 

SELECT  B.SRC_CMPNY_ID,B.CMPNY_ID,A.CMPNY_NM,B.IDN_PRNT_SRC_ID,B.IDN_SRC_ID FROM    [CMPNY].[COMPANY] A

JOIN [CMPNY].[COMPANY] B ON A.IDN_CMPNY_ID=B.IDN_CMPNY_ID

WHERE A.CMPNY_NM LIKE '%Long Island Jewish Home Care%'

END