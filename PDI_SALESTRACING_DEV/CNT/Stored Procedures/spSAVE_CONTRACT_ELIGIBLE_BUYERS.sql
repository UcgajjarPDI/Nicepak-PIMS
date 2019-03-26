CREATE PROCEDURE CNT.spSAVE_CONTRACT_ELIGIBLE_BUYERS @cnt_Nr VARCHAR(7), 
                                                    @cmpIds COMPANYIDS READONLY
AS
    BEGIN
        SET NOCOUNT ON;
        --DECLARE @IDN_ID INT= 7018299;
        --SELECT CMPNY_NM, 
        --       CMPNY_ADDR_1, 
        --       CMPNY_CITY, 
        --       CMPNY_ST, 
        --       CMPNY_ZIP
        --FROM CMPNY.COMPANY
        --WHERE IDN_CMPNY_ID = @IDN_ID
        --UNION ALL
        --SELECT CMPNY_NM, 
        --       CMPNY_ADDR_1, 
        --       CMPNY_CITY, 
        --       CMPNY_ST, 
        --       CMPNY_ZIP
        --FROM CMPNY.COMPANY C
        --     JOIN
        --(
        --    SELECT DISTINCT 
        --           CMPNY_ID
        --    FROM CMPNY.COMPANY
        --    WHERE IDN_CMPNY_ID = @IDN_ID
        --) I ON C.CMPNY_PRNT_ID = I.CMPNY_ID;


        INSERT INTO [CNT_DEV].[CNT_EB]
        ([CNT_NR], 
         [CMPNY_ID], 
         [REC_EFF_DT], 
         [REC_EXP_DT], 
         [REC_STAT_CD]
        )
               SELECT @cnt_Nr, 
                      c.ID, 
                      CONVERT(DATE, GETDATE()) AS REC_EFF_DT, 
                      CONVERT(DATE, '9999-12-31') AS PROD_EXP_DT_NR, 
                      'A'
               FROM @cmpIds AS c;

    END;

        --declare @p2 dbo.CompanyIDs
        --insert into @p2 values(7010022)
        --insert into @p2 values(7010068)
        --insert into @p2 values(7010111)
        --insert into @p2 values(7010120)
        --insert into @p2 values(7010140)
        --exec CNT.spSAVE_CONTRACT_ELIGIBLE_BUYERS @cnt_Nr=N'TST2672',@cmpIds=@p2

        --SELECT *
        --FROM [CNT_DEV].[CNT_EB];
        --SELECT *
        --FROM [CONT].[CNT_PROD];