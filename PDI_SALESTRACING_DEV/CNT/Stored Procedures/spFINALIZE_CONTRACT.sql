﻿
CREATE PROCEDURE CNT.spFINALIZE_CONTRACT 
	  @name varchar(7)      
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [CNT_DEV].[CONTRACT] SET CNT_STAT_CD='A' WHERE CNT_NR =@name

END

--SELECT * FROM [CNT_DEV].[CONTRACT] WHERE CNT_NR='CNT6028'

