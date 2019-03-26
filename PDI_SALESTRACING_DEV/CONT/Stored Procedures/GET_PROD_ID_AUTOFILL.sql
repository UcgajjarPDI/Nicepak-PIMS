-- =============================================
-- Author:		krunal trivedi
-- Create date:01/15/2019
-- Description:autofill by prod id
-- =============================================
CREATE PROCEDURE [CONT].[GET_PROD_ID_AUTOFILL]
	(@cntnr varchar (20),
	 @NAME varchar (15)
	
	)
AS
BEGIN
	
	SET NOCOUNT ON;

    select x.[PROD_ID] from [PROD].[PRODUCT] x inner join  [CONT].[CNT_PROD] y on x.prod_id=y.prod_id and y.cnt_nr=@cntnr where x.prod_id like @NAME +'%'
END
