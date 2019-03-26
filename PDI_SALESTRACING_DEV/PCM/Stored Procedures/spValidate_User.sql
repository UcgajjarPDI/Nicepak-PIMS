CREATE PROCEDURE [PCM].[spValidate_User] 
  @UNM varchar(20), @PWD varchar(20), @Msg varchar(96) OUTPUT,
  @Greet_NM varchar(20) output, @Role varchar(20) OUTPUT, @UID INT OUTPUT 
WITH EXEC AS CALLER
AS
BEGIN
  DECLARE @RecCNT INT

  SELECT @RecCnt = count(*) FROM PCM.PCM_USER
  WHERE USR_LOGIN_NM  = @UNM AND PWD = @PWD ;
  
  IF @RecCnt = 1
    BEGIN    
      SET @Msg = 'Valid';
      SELECT @UID = USR_ID, @Greet_NM = GREET_NM,  @Role = PCM_ROLE 
      FROM PCM.PCM_USER
      WHERE USR_LOGIN_NM = @UNM AND PWD = @PWD;
    END
  ELSE IF @RecCnt = 0
    BEGIN
      SET @Msg = 'Invalid User Informatation';
    END
  ELSE IF @RecCnt >1
    BEGIN
      SET @Msg= 'Invalid user data. Please contact system administrator';
    END


END