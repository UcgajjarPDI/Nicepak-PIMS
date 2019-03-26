Imports System.Data.SqlClient


Public Class NewCont_Product
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If (String.IsNullOrEmpty(Session("new_contract"))) Then
            Session("new_contract") = "CNT6046"
        End If

        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Initiate Contract:- Product update for " + Session("new_contract").ToString

        Main_Menu.Text = "Contract Management"

        If Not IsPostBack Then
            GETLIST()
            GetContractDetails(Session("new_contract"))
            txtEffDate.Text = CDate(Session("EffDate")).ToString("yyyy-MM-dd")
            txtExpDate.Text = CDate(Session("ExpDate")).ToString("yyyy-MM-dd")
        End If
    End Sub


    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If Button2.Text = "Submit" Then
            Dim res = ValidatePage()

            in_prodid()
        End If
        If Button2.Text = "Update" Then

            up_prodid()

        End If

    End Sub

    Protected Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        ModalPopupExtender1.Show()
    End Sub
    Protected Sub TextBox2_TextChanged(sender As Object, e As EventArgs) Handles TextBox2.TextChanged
        Dim x() As String

        x = TextBox2.Text.Split("~")
        TextBox1.Text = x(0)
        Dim i As Integer = 0
        'If i = 0 Then
        TextBox1_TextChanged(sender, e)
        '    i = +1
        'End If
        'i = 0

    End Sub
    Protected Sub TextBox1_TextChanged(sender As Object, e As EventArgs) Handles TextBox1.TextChanged
        GetProductDetail(TextBox1.Text.Trim())


    End Sub
    Public Sub in_prodid()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)
            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("CONT.INSERT_CONT_PRODID", conn)
                Try
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@CNT_NR", Session("new_contract").ToString())
                    cmd.Parameters.AddWithValue("@PROD_EFF_DT", txtEffDate.Text.Trim())
                    cmd.Parameters.AddWithValue("@PROD_EXP_DT", txtExpDate.Text.Trim())
                    cmd.Parameters.AddWithValue("@prod_prc", TextBox5.Text.Trim())
                    cmd.Parameters.AddWithValue("@prod_ID", TextBox1.Text.Trim())
                    cmd.Parameters.AddWithValue("@rationale", txtRationale.Text.Trim())
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                    ClearFields()

                Catch ex As Exception
                    Dim x As String = ex.ToString()

                Finally
                    If (Not conn Is Nothing) Then
                        conn.Close()
                    End If
                End Try

            End Using
        End Using
        GETLIST()
    End Sub

    Public Sub up_prodid()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)
            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("CONT.UPDATE_CONT_PRODID", conn)
                Try

                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@CNT_NR", Session("new_contract").ToString())
                    cmd.Parameters.AddWithValue("@PROD_EFF_DT", txtEffDate.Text.Trim())
                    cmd.Parameters.AddWithValue("@PROD_EXP_DT", txtExpDate.Text.Trim())
                    cmd.Parameters.AddWithValue("@prod_prc", TextBox5.Text.Trim())
                    cmd.Parameters.AddWithValue("@prod_ID", TextBox1.Text.Trim())

                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()

                    ClearFields()
                Catch ex As Exception

                Finally
                    If (Not conn Is Nothing) Then
                        conn.Close()
                    End If
                End Try

            End Using
        End Using
        Button2.Text = "Submit"
        GETLIST()
    End Sub

    <Script.Services.ScriptMethod()>
    <Services.WebMethod>
    Public Shared Function New_cnt_product(ByVal prefixText As String) As List(Of String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        'SQL Conection
        Using conn As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PRODUCT_BY_ID", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim NamePar As SqlParameter = cmd.Parameters.AddWithValue("@name", prefixText)
            NamePar.Direction = ParameterDirection.Input

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
    Public Shared Function New_cnt_prod_DETAIL(ByVal prefixText As String) As List(Of String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        'SQL Conection
        Using conn As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PRODUCT_BY_Name", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim NamePar As SqlParameter = cmd.Parameters.AddWithValue("@name", prefixText)
            NamePar.Direction = ParameterDirection.Input

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

    Public Sub updatetxt(ByVal ProductID As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PRODUCT_DETAILS", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim ContNr As SqlParameter = cmd.Parameters.AddWithValue("@cntNr", HttpContext.Current.Session("new_contract"))
            Dim ProdID As SqlParameter = cmd.Parameters.AddWithValue("@prodId", ProductID)
            ContNr.Direction = ParameterDirection.Input
            ProdID.Direction = ParameterDirection.Input

            Try
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim dt As DataTable = ds.Tables(0)
                If dt.Rows.Count > 0 Then

                    TextBox1.Text = dt.Rows(0)("PROD_ID").ToString()
                    TextBox2.Text = dt.Rows(0)("PRODUCT_DESC").ToString()
                    txtEffDate.Text = CDate(dt.Rows(0)("PROD_EFF_DT").ToString()).ToString("yyyy-MM-dd")
                    txtExpDate.Text = CDate(dt.Rows(0)("PROD_EXP_DT").ToString()).ToString("yyyy-MM-dd")
                    TextBox5.Text = dt.Rows(0)("PROD_PRC").ToString()
                    txtRationale.Text = dt.Rows(0)("RATIONALE").ToString()

                    Button2.Text = "Update"
                    GetProductDetail(TextBox1.Text.Trim())

                End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub

    Public Sub GetProductDetail(ByVal ProductID As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PRODUCT_PRICE_VOLUME_DETAILS_BY_ID", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ProdId As SqlParameter = cmd.Parameters.AddWithValue("@productId", ProductID)
                ProdId.Direction = ParameterDirection.Input

                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim dt As DataTable = ds.Tables(0)
                If dt.Rows.Count > 0 Then
                    PRODUCT_ID.Text = dt.Rows(0)("PROD_ID").ToString()
                    PRODUCT_DESCRIPTION.Text = dt.Rows(0)("PRODUCT_DESC").ToString()
                    If TextBox1.Text = "" Then

                    Else
                        TextBox2.Text = dt.Rows(0)("PRODUCT_DESC").ToString()
                    End If
                    Li_pri.Text = "$" + dt.Rows(0)("LIST_PRICE").ToString()
                    ASP12.Text = "$" + dt.Rows(0)("ASP12").ToString()
                    ASP6.Text = "$" + dt.Rows(0)("ASP6").ToString()
                    vt1.Text = "$" + dt.Rows(0)("VIZ_TIER_1").ToString()
                    at1.Text = "$" + dt.Rows(0)("AMERI_TIER_1").ToString()
                    at2.Text = "$" + dt.Rows(0)("AMERI_TIER_2").ToString()
                    HPG.Text = "$" + dt.Rows(0)("HPG_PRC").ToString()
                    Vol_det.Text = dt.Rows(0)("CURR_VOL").ToString()

                End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub

    Private Sub GETLIST()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PRODUCTS_BY_CNT", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ContractId As SqlParameter = cmd.Parameters.AddWithValue("@cntNr", HttpContext.Current.Session("new_contract").ToString)
                ContractId.Direction = ParameterDirection.Input

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

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

    Private Sub gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd1.RowCommand

        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        Dim newRowIndex As Integer = 0
        Try

            If e.CommandName = "update1" Then
                Dim PRODID As String = CType(gd1.Rows(rowIndex).FindControl("GD_PDID"), Label).Text
                updatetxt(PRODID.Trim())
            End If
            If e.CommandName = "view" Then
                Dim PRODID As String = CType(gd1.Rows(rowIndex).FindControl("GD_PDID"), Label).Text
                GetProductDetail(PRODID.Trim())
            End If
            If e.CommandName = "delete1" Then
                Dim CNTPRODID As String = CType(gd1.Rows(rowIndex).FindControl("GD_CNTPDID"), Label).Text
                delete_proid(CNTPRODID.Trim())
            End If
        Catch ex As Exception

        End Try
    End Sub

    Public Sub delete_proid(ByVal ConProdId As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spDELETE_CONTRACT_PRODUCT", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ContractId As SqlParameter = cmd.Parameters.AddWithValue("@cntNr", ConProdId)
                ContractId.Direction = ParameterDirection.Input

                conn1.Open()
                cmd.ExecuteNonQuery()
                GETLIST()
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub GetContractDetails(ByVal contractNr As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_CONTRACT_DETAILS_BY_NUMBER", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim ContractId As SqlParameter = cmd.Parameters.AddWithValue("@name", contractNr)
                ContractId.Direction = ParameterDirection.Input

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim dt As DataTable = ds.Tables(0)
                If dt.Rows.Count > 0 Then
                    Session("EffDate") = Date.Parse(dt.Rows(0)("CntEffDate").ToString()).ToShortDateString()
                    Session("ExpDate") = Date.Parse(dt.Rows(0)("CntExpDate").ToString()).ToShortDateString()
                End If
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Function ValidatePage() As Boolean

        Return True
    End Function

    Public Sub ClearFields()
        TextBox1.Text = ""
        TextBox2.Text = ""
        txtEffDate.Text = CDate(Session("EffDate")).ToString("yyyy-MM-dd")
        txtExpDate.Text = CDate(Session("ExpDate")).ToString("yyyy-MM-dd")
        TextBox5.Text = ""
        txtRationale.Text = ""
    End Sub

End Class