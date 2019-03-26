
CREATE PROCEDURE CNT.spDELETE_EB --'CNT6030'
	  @cntNr varchar(7),
	  @companyId int      
AS
BEGIN
	
	SET NOCOUNT ON;

DELETE FROM cnt_DEV.CNT_EB WHERE CNT_NR = @cntNr AND CMPNY_ID =@companyId

END
