﻿CREATE PROCEDURE [STAGE].[spDATA_LOAD_HIST_SUMMARY]
@vSALES_PERIOD INT = NULL
WITH EXEC AS CALLER
AS
BEGIN
/*
    This is basically to calculate the rolling averages of quantity and sales amount
    We will calculate upto last month - going 18 months back.
    we need to go one month back to find the last month of average and then will it back.
    For example for jan 2019, we will calcualte average from June 18 to dec 18 and then will assign this
    average to jan 18 for that distributor.
*/


  DECLARE 
    @START_SALES_PERIOD AS VARCHAR(10), @END_SALES_PERIOD AS VARCHAR(10),
    @SALES_6MO AS FLOAT, @SALES_12MO AS FLOAT, @QTY_6MO AS FLOAT, @QTY_12MO AS FLOAT,
    @DIST_NR AS VARCHAR(20), @SALES_PRIOD_DT AS DATE;
  
  IF @vSALES_PERIOD IS NULL
    BEGIN
      SELECT @END_SALES_PERIOD = MAX(SALESPERIOD) 
      FROM [NJ-SALESDBDEV].[PDI_SALESTRACING].[STAGE].[DDS_PDI_SAF_EXTRACT];
    END
  ELSE
    BEGIN
     SET @END_SALES_PERIOD = @vSALES_PERIOD
    END
  
  ----------------------------------------------
  -- GET END SALES PERIOD TO LAST MONTH --
  ----------------------------------------------
  
  SET @END_SALES_PERIOD =
    YEAR(
      DATEADD(M,-1,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*10000
    +
    MONTH(
      DATEADD(M,-1,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*100
    +
    DAY(
      DATEADD(M,-1,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))
    
  ----------------------------------------------
  -- GET STARTING SALES PERIOD 18 MONTHS BACK --
  ----------------------------------------------
  SELECT @START_SALES_PERIOD = 
    YEAR(
      DATEADD(M,-18,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*10000
    +
    MONTH(
      DATEADD(M,-18,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*100
    +
    DAY(
      DATEADD(M,-18,
        CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))
        
  
  TRUNCATE TABLE STAGE.TEMP_DATA_LOAD_HIST_SUMMARY ;
 
  -----------------------------
  -- LOAD THE SUMMARY TABLE --
  -----------------------------
  
  INSERT INTO STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
    (SALESPERIOD, DIST_NR, DISTID, REC_CNT, CS_QTY, SALES_AMT)
  SELECT 
    SALESPERIOD, DISTCOID AS DIST_NR, DISTID, COUNT(*) AS REC_CNT, SUM(COQTYSOLD) AS CS_QTY, SUM(COTOTALSALESAMNT) AS SALES_AMT
  FROM [NJ-SALESDBDEV].[PDI_SALESTRACING].[STAGE].[DDS_PDI_SAF_EXTRACT]
  WHERE SALESPERIOD BETWEEN @START_SALES_PERIOD AND @END_SALES_PERIOD
  GROUP BY SALESPERIOD, DISTCOID, DISTID;
  
  UPDATE STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
  SET SALES_PERIOD_DT = 
      CONVERT(DATE,LEFT(SALESPERIOD,4)+'-'+SUBSTRING(SALESPERIOD,5,2)+'-'+SUBSTRING(SALESPERIOD,7,2));
 
  -----------------------------
  -- ROLLING AVERAGES --
  -----------------------------

  DECLARE iCur CURSOR FOR
    SELECT DISTINCT DIST_NR, SALES_PERIOD_DT
    FROM STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
    
  OPEN iCur;
    FETCH NEXT FROM iCur into @DIST_NR, @SALES_PRIOD_DT;

  WHILE @@FETCH_STATUS = 0
    BEGIN
      SELECT @SALES_6MO = AVG(SALES_AMT)  FROM STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
      WHERE DIST_NR = @DIST_NR 
      AND SALESPERIOD BETWEEN DATEADD(M,-5,@SALES_PRIOD_DT) AND @SALES_PRIOD_DT;
      
      SELECT @SALES_12MO = AVG(SALES_AMT)  FROM STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
      WHERE DIST_NR = @DIST_NR 
      AND SALESPERIOD BETWEEN DATEADD(M,-11,@SALES_PRIOD_DT) AND @SALES_PRIOD_DT;
      
      SELECT @QTY_6MO = AVG(CS_QTY)  FROM STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
      WHERE DIST_NR = @DIST_NR 
      AND SALESPERIOD BETWEEN DATEADD(M,-5,@SALES_PRIOD_DT) AND @SALES_PRIOD_DT;
      
      SELECT @QTY_12MO = AVG(CS_QTY)  FROM STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
      WHERE DIST_NR = @DIST_NR 
      AND SALESPERIOD BETWEEN DATEADD(M,-11,@SALES_PRIOD_DT) AND @SALES_PRIOD_DT;
      
      UPDATE STAGE.TEMP_DATA_LOAD_HIST_SUMMARY 
      SET CS_QTY_6MO_AVG = @QTY_6MO, 
          CS_QTY_12MO_AVG = @QTY_12MO, 
          SALES_AMT_6MO_AVG = @SALES_6MO, 
          SALES_AMT_12MO_AVG = @SALES_12MO,
          SALESPERIOD =     
            YEAR(
              DATEADD(M,1,
                CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*10000
            +
            MONTH(
              DATEADD(M,1,
                CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))*100
            +
            DAY(
              DATEADD(M,1,
                CONVERT(DATE,LEFT(@END_SALES_PERIOD,4)+'-'+SUBSTRING(@END_SALES_PERIOD,5,2)+'-'+SUBSTRING(@END_SALES_PERIOD,7,2))))
      WHERE DIST_NR = @DIST_NR AND SALES_PERIOD_DT = @SALES_PRIOD_DT;
        
    FETCH NEXT FROM iCur into 
    @DIST_NR, @SALES_PRIOD_DT;
    
    
    END;  
    
  CLOSE iCur; DEALLOCATE iCur;

END