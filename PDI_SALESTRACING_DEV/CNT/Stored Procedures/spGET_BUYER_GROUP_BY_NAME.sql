
CREATE PROCEDURE [CNT].[spGET_BUYER_GROUP_BY_NAME]
	@compTypeId varchar(30),
	  @name varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;
	IF(@compTypeId IS  NULL)
	BEGIN
		SELECT DISTINCT top 20 CMPNY_NM+' - '+STAGE.FNINIT(CMPNY_CITY)+', '+CMPNY_ST + '--' + CAST(CMPNY_ID AS varchar(20))   
			FROM CMPNY.COMPANY  WHERE CMPNY_NM like + @name +'%'
	END
	ELSE
	BEGIN 
	SELECT DISTINCT top 20  CMPNY_NM+' - '+STAGE.FNINIT(CMPNY_CITY)+', '+CMPNY_ST + '--' + CAST(CMPNY_ID AS varchar(20))      
		FROM CMPNY.COMPANY C WHERE CMPNY_TYP_ID = @compTypeId and CMPNY_NM like + @name +'%'
	END
	

END

	