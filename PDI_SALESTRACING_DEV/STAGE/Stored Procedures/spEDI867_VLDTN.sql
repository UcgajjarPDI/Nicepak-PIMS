CREATE PROCEDURE [STAGE].[spEDI867_VLDTN]
WITH EXEC AS CALLER
AS
BEGIN

 
  DECLARE @DUP_CURRENT_1 INT
 
  
   SELECT @DUP_CURRENT_1 = COUNT(*) FROM     
    ( SELECT 
        H.HDRCUS, H.HST02, H.HISA06, H.HISA13, count(*) AS CNT
      FROM 
        PDI_SALESTRACING_DEV.STAGE.E867HDR H
      GROUP BY H.HDRCUS, H.HST02, H.HISA06, H.HISA13
      HAVING COUNT(*) > 1) D;
      
  IF @DUP_CURRENT_1 > 0
    BEGIN
      INSERT INTO [PDI_SALESTRACING_DEV].[STAGE].[E867_EXP]
      ([HDRCUS], [HST02], [HISA06],[HISA13],[NR_of_COPIES],[E867_EXP_TYPE_ID]) 
       SELECT 
        H.HDRCUS, H.HST02, H.HISA06, H.HISA13, count(*) AS CNT, 1
      FROM 
        PDI_SALESTRACING_DEV.STAGE.E867HDR H
      GROUP BY H.HDRCUS, H.HST02, H.HISA06, H.HISA13
      HAVING COUNT(*) > 1
    END;
  
  /*
 
  If @Var_1 = 0 and @Var_2 = 0 
    BEGIN 
      SET @Run_Indicator = 'Y';
      SET @Load_Indicator = 'Yes';
      END; 
    ELSE BEGIN 
      SET @Run_Indicator = 'N';
      SET @Load_Indicator = 'No';
      SET @Outcome = 'Varaince Exist. Need to examine data before loading.'
      SET @Reason = @Reason + ';' + 'Difference between SAF and FACT'
    END;
   
  
  EXEC REPORT.spFACT_SALES_TRACING_SUMMARY_FULL_LOAD_INVDATE;
  */
  
END