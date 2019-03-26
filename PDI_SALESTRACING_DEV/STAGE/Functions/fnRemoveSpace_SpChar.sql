CREATE FUNCTION [STAGE].[fnRemoveSpace_SpChar]
(@str nvarchar(255))
RETURNS nvarchar(200)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE
@ret_str AS varchar(200)
  
  SET @str = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(@str
                        ,CHAR(13),'')
                      ,CHAR(10),'')
                    ,'''',' ')
                  ,'/',' ')
                ,'$',' ')
              ,'%',' ')
            ,'@',' ')
          ,',',' ')
        ,'.',' ')
      ,'?',' ')
    ,'*',' ');
  
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