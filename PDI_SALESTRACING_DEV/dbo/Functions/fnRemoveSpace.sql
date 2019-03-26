CREATE FUNCTION dbo.fnRemoveSpace
(
@str AS nvarchar(255)
)
RETURNS nvarchar(200)
AS
BEGIN

DECLARE
@ret_str AS varchar(200)

  SELECT @ret_str =
        REPLACE(
           REPLACE(
              REPLACE(
                   LTRIM(RTRIM(@str))
               ,'  ',' '+CHAR(7))
           ,CHAR(7)+' ','')
       ,CHAR(7),'');

RETURN @ret_str

END