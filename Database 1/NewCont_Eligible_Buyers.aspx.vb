Imports System.Data.SqlClient

Public Class NewCont_Eligible_Buyers
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If (String.IsNullOrEmpty(Session("new_contract"))) Then
                Session("new_contract") = "CNT6046"
            End If
            Dim Page_name As Label = Master.FindControl("Page_name")
            Dim Main_Menu As Label = Master.FindControl("Main_Menu")
            Page_name.Text = "Eligible Buyers:- Contract " + Session("new_contract").ToString + " Details"
            Main_Menu.Text = "Contract Management"
            btnSubmit.Visible = False

            LoadEligibleBuyers()
        End If

    End Sub
    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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
    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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
    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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
    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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

    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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

    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
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
            ERR.Text = "At least company name or or address is needed to run a search."

        Else
            ERR.Visible = False
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
                btnSubmit.Visible = True
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        gd1_show()
    End Sub

    Private Sub Save()

        Dim dt As DataTable = New DataTable()
        dt.Columns.Add("ID", GetType(Integer))

        For Each row As GridViewRow In gd1.Rows

            Dim result As Boolean = DirectCast(row.FindControl("ckpop1"), CheckBox).Checked
            If result = True Then
                Dim rd1 As String = row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text
                dt.Rows.Add(Integer.Parse(rd1))
            End If

        Next

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)
            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("CNT.spSAVE_CONTRACT_ELIGIBLE_BUYERS", conn)
                cmd.CommandType = CommandType.StoredProcedure
                Dim CompanyIds As SqlParameter = New SqlParameter("@cmpIds", SqlDbType.Structured) With {.TypeName = "dbo.CompanyIDs", .Value = dt}
                cmd.Parameters.AddWithValue("@cnt_Nr", Session("new_contract"))
                cmd.Parameters.Add(CompanyIds)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

    End Sub

    Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Save()
        LoadEligibleBuyers()
        ClearFields()
        gd1.DataSource = Nothing
        gd1.DataSourceID = Nothing
        gd1.DataBind()
        btnSubmit.Visible = False
    End Sub

    Private Sub LoadEligibleBuyers()
        grdCurrentEB.DataSourceID = Nothing
        grdCurrentEB.EditIndex = -1
        grdCurrentEB.DataBind()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim x As String = String.Empty

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("CNT.spGET_CONTRACT_EB", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            Dim ContractNr As SqlParameter = cmd1.Parameters.AddWithValue("@cntNr", Session("new_contract"))

            ContractNr.Direction = ParameterDirection.Input

            Try
                'open connection
                conn1.Open()
                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                grdCurrentEB.DataSource = ds
                grdCurrentEB.DataBind()
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try

        End Using
    End Sub
    Private Sub grdCurrentEB_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles grdCurrentEB.PageIndexChanging
        grdCurrentEB.PageIndex = e.NewPageIndex
        LoadEligibleBuyers()
    End Sub

    Private Sub DeleteBuyer(ByVal cmpnyId As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spDELETE_EB", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ContractId As SqlParameter = cmd.Parameters.AddWithValue("@cntNr", Session("new_contract"))
                Dim CompanyId As SqlParameter = cmd.Parameters.AddWithValue("@companyId", Integer.Parse(cmpnyId))
                ContractId.Direction = ParameterDirection.Input
                CompanyId.Direction = ParameterDirection.Input

                conn1.Open()
                cmd.ExecuteNonQuery()
                LoadEligibleBuyers()
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub grdCurrentEB_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles grdCurrentEB.RowCommand

        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        Try

            If e.CommandName = "delete1" Then
                Dim CompanyID As String = CType(grdCurrentEB.Rows(rowIndex).FindControl("COMPANY_ID"), Label).Text
                DeleteBuyer(CompanyID)
            End If

        Catch ex As Exception

        End Try
    End Sub
    Private Sub ClearFields()
        txt_name.Text = ""
        txt_add.Text = ""
        txt_st.Text = ""
        txt_city.Text = ""
        Zip_txt.Text = ""
    End Sub
End Class