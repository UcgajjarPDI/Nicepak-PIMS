Imports System.Data.SqlClient

Public Class New_Contract
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Initiate Contract"
        Main_Menu.Text = "Contract Management"
        'CntNr=CNT6030

        If Not (Request.QueryString("CntNr") Is Nothing) Then
            If Request.QueryString("CntNr").ToString() <> "" Then
                Session("new_contract") = Request.QueryString("CntNr").ToString()
                Page_name.Text = "Contract update for " + Session("new_contract").ToString
            End If
        Else
            Session("new_contract") = vbNull
        End If

        If Not IsPostBack Then
            Getdropdown_CONT()
            If (String.IsNullOrEmpty(Session("new_contract"))) Then
                GetNewContractNumber()
            Else
                GetContractInfo(Session("new_contract"))
            End If

            lstContractType_SelectedIndexChanged(vbNull, New EventArgs)
            lstReplIndicator_SelectedIndexChanged(vbNull, New EventArgs)
        End If
        Session("x1") = DBNull.Value
    End Sub

    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
    Public Shared Function cnt_cnt(ByVal prefixText As String) As List(Of String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_CONTRACT_BY_NUMBER", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@name", prefixText)
            Param1.Direction = ParameterDirection.Input

            Try
                conn.Open()
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim dt As DataTable = New DataTable()
                da.Fill(dt)
                Dim CountryNames As List(Of String) = New List(Of String)

                For i As Integer = 0 To dt.Rows.Count - 1
                    CountryNames.Add(dt.Rows(i)(0).ToString())

                Next
                Return CountryNames

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Function

    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
    Public Shared Function old_cnt(ByVal prefixText As String) As List(Of String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_CONTRACT_BY_NUMBER", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@name", prefixText)
            Param1.Direction = ParameterDirection.Input

            Try
                conn.Open()
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim dt As DataTable = New DataTable()
                da.Fill(dt)
                Dim CountryNames As List(Of String) = New List(Of String)

                For i As Integer = 0 To dt.Rows.Count - 1
                    CountryNames.Add(dt.Rows(i)(0).ToString())

                Next
                Return CountryNames

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Function

    <Script.Services.ScriptMethod()>
    <Services.WebMethod(EnableSession:=True)>
    Public Shared Function cnt_byerGrp(ByVal prefixText As String) As List(Of String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_BUYER_GROUP_BY_NAME", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim NamePar As SqlParameter = cmd.Parameters.AddWithValue("@name", prefixText)
            Dim CompTypeIds As SqlParameter = cmd.Parameters.AddWithValue("@compTypeId", HttpContext.Current.Session("x1"))
            NamePar.Direction = ParameterDirection.Input
            CompTypeIds.Direction = ParameterDirection.Input

            Try
                conn.Open()
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim dt As DataTable = New DataTable()
                da.Fill(dt)
                Dim CountryNames As List(Of String) = New List(Of String)

                For i As Integer = 0 To dt.Rows.Count - 1
                    CountryNames.Add(dt.Rows(i)(0).ToString())
                Next
                Return CountryNames

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using

    End Function

    Private Sub Getdropdown_CONT()
        'lstContractType.Items.Add(New ListItem("--Please Select--", ""))
        'lstContractType.AppendDataBoundItems = True
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[CMPNY].[GET_SP_COMPANY_TYPE_DROPDOWN]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            cmd1.Connection = conn1

            Try
                'open connection
                conn1.Open()

                lstContractType.DataSource = cmd1.ExecuteReader()
                lstContractType.DataTextField = "CMPNY_TYP_NM"
                lstContractType.DataValueField = "CMPNY_TYP_ID"
                lstContractType.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub

    Protected Sub lstContractType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lstContractType.SelectedIndexChanged
        If (lstContractType.SelectedIndex = 2) Then
            txtTierDesc.Enabled = True
            lsttierLevelId.Enabled = True
        Else
            txtTierDesc.Enabled = False
            lsttierLevelId.Enabled = False
        End If

        Session("x1") = lstContractType.SelectedValue.ToString
        Session("x1") = Session("x1")
    End Sub
    Protected Sub lstReplIndicator_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lstReplIndicator.SelectedIndexChanged
        If (lstReplIndicator.SelectedIndex = 0) Then
            txtReplacingContractNr.Enabled = True
        Else
            txtReplacingContractNr.Enabled = False
        End If

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        'If (Not ValidatePage()) Then
        '    Return
        'End If
        submit()
    End Sub

    Private Function ValidatePage() As Boolean
        If (DateTime.Parse(txtEffDate.Text) < Now.Date) Then
            Lbl_Error.Text = "Effective date should be present or future date."
            Return False
        End If
        If (DateTime.Parse(txtExpDate.Text) < DateTime.Parse(txtEffDate.Text)) Then
            Lbl_Error.Text = "Expiration date should be greater than effective date."
            Return False
        End If
        Lbl_Error.Text = ""
        Return True
    End Function

    Private Sub submit()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)

            Dim companyId = Split(txtBuyerGroup.Text, "--")


            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("[CNT].[spSAVE_NEW_CONTRACT]", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@CNT_NR", txtContractNr.Text.Trim())
                cmd.Parameters.AddWithValue("@CNT_TYP_CD", lstContractType.SelectedItem.Text)
                cmd.Parameters.AddWithValue("@RENEW_IN", lstReplIndicator.SelectedValue.ToString())
                cmd.Parameters.AddWithValue("@CNT_EFF_DT", txtEffDate.Text)
                cmd.Parameters.AddWithValue("@CNT_EXP_DT", txtExpDate.Text)
                cmd.Parameters.AddWithValue("@REPLCNG_CNT_NR", IIf(lstReplIndicator.SelectedValue.ToString() = "Y", txtReplacingContractNr.Text, DBNull.Value))
                cmd.Parameters.AddWithValue("@BUYER_GRP_CNT_NR", txtBuyerContractNr.Text)
                cmd.Parameters.AddWithValue("@BUYE_GRP_CMPNY_ID", Integer.Parse(companyId(1)))
                cmd.Parameters.AddWithValue("@TIER_ID", IIf(lstContractType.SelectedItem.Text = "GPO", lsttierLevelId.SelectedItem.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@TIER_DESC", IIf(lstContractType.SelectedItem.Text = "GPO", txtTierDesc.Text, DBNull.Value))
                cmd.Parameters.AddWithValue("@CNT_DESC", txtContractDesc.Text)
                cmd.Parameters.AddWithValue("@USER_ID", Session("userId"))

                cmd.Parameters.Add("@duplicarion", SqlDbType.Char, 1)
                cmd.Parameters("@duplicarion").Direction = ParameterDirection.Output

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()

                If cmd.Parameters("@duplicarion").Value.ToString = "Y" Then

                    Lbl_Error.EnableViewState = True
                    Lbl_Error.Text = "Please Add Valid Contract"
                Else
                    Session("new_contract") = txtContractNr.Text.ToString()
                    Response.Redirect("NewCont_Product.aspx")

                End If

            End Using
        End Using
    End Sub

    Private Sub GetNewContractNumber()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        Using conn As New SqlConnection(CS)
            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_NEW_CONTRACT_NUMBER", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Try
                conn.Open()
                Dim reader = cmd.ExecuteReader()
                If (reader.HasRows) Then
                    While reader.Read()
                        txtContractNr.Text = reader("NEW_CNT_NR").ToString()
                    End While
                End If
                reader.Close()

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub GetContractInfo(ByVal CntNr As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_CONTRACT_DETAILS_BY_NUMBER", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ContNr As SqlParameter = cmd.Parameters.AddWithValue("@name", CntNr)
                ContNr.Direction = ParameterDirection.Input

                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim dt As DataTable = ds.Tables(0)
                If dt.Rows.Count > 0 Then
                    txtContractNr.Text = dt.Rows(0)("CntNr").ToString()
                    lstContractType.Text = dt.Rows(0)("CNT_TYP_CD").ToString()
                    lstReplIndicator.Text = dt.Rows(0)("RENEW_IN").ToString()
                    txtEffDate.Text = dt.Rows(0)("CntEffDate").ToString()
                    txtExpDate.Text = dt.Rows(0)("CntExpDate").ToString()
                    txtBuyerContractNr.Text = dt.Rows(0)("BUYER_GRP_CNT_NR").ToString()
                    txtContractDesc.Text = dt.Rows(0)("CNT_DESC").ToString()
                    txtBuyerGroup.Text = dt.Rows(0)("CMPNY_NM").ToString()
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