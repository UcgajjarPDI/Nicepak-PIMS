CREATE PROCEDURE [STG0].[Getcompany_Pager]
       @SearchTerm VARCHAR(500) = ''
      ,@PageIndex INT = 1
      ,@PageSize INT = 10
      ,@RecordCount INT OUTPUT
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CMPNY_ID] ASC
      )AS RowNumber
      ,[CMPNY_ID], [CMPNY_NM],[CMPNY_ADDR_1],[CMPNY_CITY],[CMPNY_ST],[CMPNY_ZIP]
 
      INTO #Results
       FROM [CMPNY].[COMPANY]
      WHERE [CMPNY_NM] LIKE '%'+ @SearchTerm + '%' OR @SearchTerm = ''
      SELECT @RecordCount = COUNT(*)
      FROM #Results
          
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
    
      DROP TABLE #Results
END