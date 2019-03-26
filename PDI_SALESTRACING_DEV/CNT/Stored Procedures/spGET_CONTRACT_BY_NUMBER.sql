
CREATE PROCEDURE [CNT].[spGET_CONTRACT_BY_NUMBER] 
	  @name varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;
	select TOP 10 cnt_nr FROM [CNT_DEV].[CONTRACT] where cnt_nr like '%' +@name +'%'

END

	