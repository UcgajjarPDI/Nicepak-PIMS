Imports System.Data.SqlClient

Public Class MDM_Search
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ERR.Visible = False
    End Sub
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_name(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_NM]from CMPNY.company where [CMPNY_NM] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_name_other(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_ALT_NM] from [CMPNY].[COMPANY] where [CMPNY_ALT_NM] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_add(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_ADDR_1] from [CMPNY].[COMPANY] where [CMPNY_ADDR_1] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_city(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_CITY] from [CMPNY].[COMPANY] where [CMPNY_CITY] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_st(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_ST] from [CMPNY].[COMPANY] where [CMPNY_ST] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_zip(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_ZIP] from [CMPNY].[COMPANY] where [CMPNY_ZIP] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        gd1.Visible = False


        If String.IsNullOrEmpty(txt_name.Text) And String.IsNullOrEmpty(txt_add.Text.ToString) Then

            ERR.Visible = True
            ERR.Text = "At least name or alternate name or street address is needed to run a search"

        Else
            gd1.Visible = True
            gd1_show()
        End If

    End Sub
    Public Sub gd1_show()

        gd1.DataSourceID = Nothing
        gd1.EditIndex = -1
        gd1.DataBind()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim x As String = String.Empty

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[CMPNY].[spSRCH_CMPNY]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_NM", txt_name.Text)
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ZIP ", Zip_txt.Text)
            Dim Param5 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ADDR ", txt_add.Text)
            Dim Param6 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_CITY ", txt_city.Text)
            Dim Param7 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ST ", txt_st.Text)
            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Param5.Direction = ParameterDirection.Input
            Param6.Direction = ParameterDirection.Input
            Param7.Direction = ParameterDirection.Input

            Try
                'open connection
                conn1.Open()
                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd1.DataSource = ds
                gd1.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try

        End Using

    End Sub

    Protected Sub txt_name_TextChanged(sender As Object, e As EventArgs) Handles txt_name.TextChanged

    End Sub

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        gd1_show()
    End Sub

    Private Sub gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd1.RowCommand
        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        If e.CommandName = "select" Then
            Dim pageSize As Integer = gd1.PageSize
            Dim pageIndex As Integer = gd1.PageIndex

            Dim newRowIndex As Integer = 0

            If pageIndex > 0 Then
                newRowIndex = pageIndex * pageSize
                rowIndex = rowIndex - newRowIndex
            End If

            'row.Cells(CellIndex).Text
            Dim CompanyID As String = CType(gd1.Rows(rowIndex).FindControl("COMPANY_ID"), Label).Text
            Response.Redirect("MDM_Network.aspx?id=" + CompanyID.ToString)
        ElseIf e.CommandName = "search" Then
            Dim CompanyID As String = CType(gd1.Rows(rowIndex).FindControl("COMPANY_ID"), Label).Text
            GetCompanySalesDetails(Integer.Parse(CompanyID))
        End If

    End Sub
    Private Sub GetCompanySalesDetails(ByVal cmpnyId As Integer)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_COMPANY_SALES_DETAILS", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim CompanyID As SqlParameter = cmd.Parameters.AddWithValue("@cmpnyId", cmpnyId)
            CompanyID.Direction = ParameterDirection.Input

            Try
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim dt As DataTable = ds.Tables(0)
                If dt.Rows.Count > 0 Then
                    lblSani.Text = dt.Rows(0)("SANI_SURFACE").ToString()
                    lblPrevantics.Text = dt.Rows(0)("Prevantics").ToString()
                    lblBabyWipes.Text = dt.Rows(0)("BABY_WIPES").ToString()
                    lblOthers.Text = dt.Rows(0)("OTHER").ToString()
                    lblTotal.Text = dt.Rows(0)("SALES_AMT").ToString()
                    lblAdultWipes.Text = dt.Rows(0)("ADULT_WIPES").ToString()
                    lblCompAcc.Text = dt.Rows(0)("Comp_Acc").ToString()
                    lblHygea.Text = dt.Rows(0)("Hygea").ToString()
                    lblIodine.Text = dt.Rows(0)("Iodine").ToString()
                    lblSaniHands.Text = dt.Rows(0)("SANI_HANDS").ToString()
                    lblSpecial.Text = dt.Rows(0)("Specialty").ToString()
                End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
End Class