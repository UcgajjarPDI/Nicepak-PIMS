CREATE FUNCTION STAGE.fnGET_CNT_EXP
  (  @cnt_nr AS nvarchar(100)  )
  RETURNS nvarchar(100)
  AS
  BEGIN

    DECLARE
    @ret_exp_dt_nr int = NULL;
    
    if @cnt_nr IS NOT NULL
      BEGIN
        SELECT  @ret_exp_dt_nr = CNT_EXP_DT_NR
        FROM PDI_MDM.[CONTRACT] 
        WHERE REC_STAT_CD = 'A' 
        AND CNT_NR = @cnt_nr;
      END
      

    RETURN @ret_exp_dt_nr;

  END