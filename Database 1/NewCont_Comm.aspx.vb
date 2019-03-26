Imports System.Data.SqlClient

Public Class NewCont_Comm
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        'If Page.IsPostBack Then
        '    ModalPopupExtender1.Show()
        'End If
        ModalPopupExtender1.Hide()
        If (String.IsNullOrEmpty(Session("new_contract"))) Then
            Session("new_contract") = "TST2672"
        End If
        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Communication:- Contract " + Session("new_contract").ToString + " Details"
        Label3.Visible = False
        Main_Menu.Text = "Contract Management"
        If Not IsPostBack Then
            GetProductDetail_main()
            GET_COMM()
        End If
    End Sub

    Protected Sub TextBox1_TextChanged(sender As Object, e As EventArgs) Handles TextBox1.TextChanged
        GetProductDetail(TextBox1.Text.Trim())
        ModalPopupExtender1.Hide()
        If TextBox1.Text = "" Then
            GetProductDetail_main()
        End If
    End Sub


    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
    Public Shared Function New_cnt_product(ByVal prefixText As String) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select a.[PROD_ID] from [PROD].[PRODUCT] a  join [CONT].[CNT_PROD] b on a.[PROD_ID]=b.[PROD_ID]
where b.CNT_NR='" + HttpContext.Current.Session("new_contract") + "' and b.prod_id like @NAME +'%'", con)
        'cmd.CommandType = CommandType.StoredProcedure
        ' cmd.Parameters.AddWithValue("@cntnr", HttpContext.Current.Session("new_contract"))
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
    Public Shared Function find_user(ByVal prefixText As String) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [USR_FULL_NM] from [PCM].[PCM_USER] where [USR_FULL_NM] like +'%'+ @NAME +'%'", con)
        'cmd.CommandType = CommandType.StoredProcedure
        ' cmd.Parameters.AddWithValue("@cntnr", HttpContext.Current.Session("new_contract"))
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
    Public Sub GetProductDetail(ByVal ProductID As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)




            Dim cmd1 As SqlCommand = New SqlCommand(" SELECT  a.[PROD_ID],a.[PRODUCT_DESC],a.[LIST_PRICE],a.[ASP6],a.[ASP12],a.[VIZ_TIER_1],a.[AMERI_TIER_1],a.[AMERI_TIER_2],a.[HPG_PRC],a.[CURR_VOL] 
FROM [PROD].[PROD_PRC_COMPARISON] a
join [CONT].[CNT_PROD] b on a.[PROD_ID]=b.[PROD_ID]
where b.CNT_NR='" + Session("new_contract").ToString + "' and b.[PROD_ID] like '" + ProductID + "' +'%'", conn1)

            Try

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet

                adapter.Fill(ds)
                gd1.DataSource = ds
                gd1.DataBind()




                'End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub GetProductDetail_main()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)




            Dim cmd1 As SqlCommand = New SqlCommand("SELECT  a.[PROD_ID],a.[PRODUCT_DESC],a.[LIST_PRICE],a.[ASP6],a.[ASP12],a.[VIZ_TIER_1],a.[AMERI_TIER_1],a.[AMERI_TIER_2],a.[HPG_PRC],a.[CURR_VOL] 
FROM [PROD].[PROD_PRC_COMPARISON] a
join [CONT].[CNT_PROD] b on a.[PROD_ID]=b.[PROD_ID]
where b.CNT_NR='" + Session("new_contract").ToString + "'", conn1)

            Try

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet

                adapter.Fill(ds)
                gd1.DataSource = ds
                gd1.DataBind()




                'End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub GET_COMM()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim cmd1 As SqlCommand = New SqlCommand("SELECT a.COMM_ID,a.COMM,b.USR_FULL_NM, convert(varchar(11),COMM_DTTS,106) as COMM_DTTS 
  FROM [PDI_SALESTRACING_DEV].[CONT].[COMMUNICATION] a
  join pcm.PCM_USER b  on a.COMM_BY_USR_ID_FK=b.USR_ID
  where CNTXT='" + Session("new_contract") + "'", conn1)


            Try

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet

                adapter.Fill(ds)
                gd2.DataSource = ds
                gd2.DataBind()




                'End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try



        End Using



    End Sub

    Protected Sub feedback_Click(sender As Object, e As EventArgs) Handles feedback.Click
        Label1.Text = "Post Comment/Questions"
        Label2.Text = Session("new_contract").ToString
        ModalPopupExtender1.Show()
    End Sub

    Private Sub gd2_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd2.RowCommand
        Try
            If e.CommandName = "Trace_main" Then
                Dim pageSize As Integer = gd2.PageSize
                Dim pageIndex As Integer = gd2.PageIndex
                Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
                Dim newRowIndex As Integer = 0

                If pageIndex > 0 Then
                    newRowIndex = pageIndex * pageSize
                    rowIndex = rowIndex - newRowIndex
                End If
                Label1.Text = "Respond"
                Label2.Text = Session("new_contract").ToString
                Dim commid As String = CType(gd2.Rows(rowIndex).FindControl("US1_COMM_id"), HiddenField).Value.ToString.Trim()
                HiddenField1.Value = commid
                'user_input.Text = commid
                ModalPopupExtender1.Show()

            End If



        Catch ex As Exception
            Dim x As String
            x = ex.ToString
            Response.Write(x)
        End Try
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If DropDownList1.SelectedValue = "0" Then
            Label3.Visible = True
            Label3.Text = "**Please Select Option Response**"
            ModalPopupExtender1.Show()

        Else


            If Label1.Text = "Post Comment/Questions" Then
                Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

                'SQL Conection
                Using conn1 As New SqlConnection(CS)
                    Dim cmd1 As SqlCommand = New SqlCommand("INSERT INTO [CONT].[COMMUNICATION]
           ([COMM_BY_USR_ID_FK]
           ,[CNTXT]
           ,[COMM_USR_ID]
           ,[COMM]
           ,[COMM_TYP_CD]
           ,[RESP_NEED_IN]
           ,[RESP_REQ_USR_ID]
           ,[COMM_DTTS])
select (select usr_id from pcm.PCM_USER where usr_login_nm ='" + Session("user") + "'),'" + Session("new_contract") + "',(select USR_LOGIN_NM from pcm.PCM_USER where usr_login_nm ='" + Session("user") + "'),'" + user_input.Text.Trim() + "','','" + DropDownList1.SelectedValue.ToString + "',(select USR_LOGIN_NM from pcm.PCM_USER where USR_FULL_NM='" + userID.Text.Trim() + "'),(select getdate())", conn1)


                    Try

                        conn1.Open()

                        cmd1.ExecuteNonQuery()

                        'End If

                    Finally
                        'close the connection
                        If (Not conn1 Is Nothing) Then
                            conn1.Close()
                        End If
                    End Try


                    Label3.Visible = False
                    GET_COMM()
                End Using



            End If
            If Label1.Text = "Respond" Then
                Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

                'SQL Conection
                Using conn1 As New SqlConnection(CS)
                    Dim cmd1 As SqlCommand = New SqlCommand("INSERT INTO [CONT].[COMM_RESP]
           ([COMM_ID_FK]
           ,[RESP]
           ,[RESP_DTTS]
           ,[RESP_USER_ID_FK]
           ,[RESP_USER_ID]
           ,[RESP_BY_USER_ID])
     select ('" + HiddenField1.Value.ToString.Trim() + "' ),('" + user_input.Text + "' ), (select getdate()),(select usr_id from pcm.PCM_USER where USR_FULL_NM like'%" + userID.Text.Trim() + "%'),(select USR_LOGIN_NM from pcm.PCM_USER where USR_FULL_NM like'%" + userID.Text.Trim() + "%'),(select USR_LOGIN_NM from pcm.PCM_USER where usr_login_nm ='" + Session("user") + "')", conn1)


                    Try

                        conn1.Open()

                        cmd1.ExecuteNonQuery()



                        'End If

                    Finally
                        'close the connection
                        If (Not conn1 Is Nothing) Then
                            conn1.Close()
                        End If
                    End Try
                    user_input.Text = ""
                    DropDownList1.SelectedValue = "0"

                    Label3.Visible = False
                    GET_COMM()
                End Using



            End If
        End If
        'Label1.Text = "FEEDBACK"
        'Label2.Text = Session("new_contract").ToString
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Label1.Text = "Post Comment/Questions"
        Label2.Text = Session("new_contract").ToString
        ModalPopupExtender1.Hide()

    End Sub

    Protected Sub gd2_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
            Using conn1 As New SqlConnection(CS)
                Dim gv As GridView = DirectCast(e.Row.FindControl("gd3"), GridView)

                Dim commID As String = DirectCast(e.Row.FindControl("US1_COMM_id"), HiddenField).Value.ToString


                Dim cmd1 As SqlCommand = New SqlCommand("SELECT b.USR_FULL_NM as RESP_USER_ID ,convert(varchar(11),a.RESP_DTTS) as RESP_DTTS,RESP 
  From [CONT].[COMM_RESP] a
  join PCM.PCM_USER b on a.RESP_by_USER_ID=b.USR_LOGIN_NM
  where [COMM_ID_FK]='" + commID + "'", conn1)


                Try

                    conn1.Open()

                    Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                    Dim ds As DataSet = New DataSet

                    adapter.Fill(ds)
                    gv.DataSource = ds
                    gv.DataBind()




                    'End If

                Finally
                    'close the connection
                    If (Not conn1 Is Nothing) Then
                        conn1.Close()
                    End If
                End Try
                ModalPopupExtender1.Hide()
            End Using

        End If
    End Sub

    Private Sub gd2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd2.PageIndexChanging
        gd2.PageIndex = e.NewPageIndex
        GET_COMM()
        ModalPopupExtender1.Hide()

    End Sub

    Private Sub userID_TextChanged(sender As Object, e As EventArgs) Handles userID.TextChanged
        ModalPopupExtender1.Show()
    End Sub

    Protected Sub gd2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd2.SelectedIndexChanged

    End Sub

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        If TextBox1.Text = "" Then
            GetProductDetail_main()
        Else
            GetProductDetail(TextBox1.Text)
        End If

    End Sub

    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Private Sub btnfinalize_Click(sender As Object, e As EventArgs) Handles btnfinalize.Click
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)

            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("CNT.spFINALIZE_CONTRACT", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@name", Session("new_contract"))

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()

                Session("new_contract") = ""
                Response.Redirect("Active_Contract.aspx")

            End Using
        End Using
    End Sub

End Class