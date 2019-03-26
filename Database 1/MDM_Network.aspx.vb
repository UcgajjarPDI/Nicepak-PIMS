Imports System.Data.SqlClient


Public Class MDM_Network
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim id As String
        Try
            id = Request.QueryString("id").ToString
            Session("compId") = id
        Catch ex As Exception
            Response.Redirect("MDM_Search.aspx")

        End Try

        If Not IsPostBack Then
            gd_company_load(id)
            gd_IDN_company_load(id)
            gd_parent_company_load(id)
            gd_network_company_load(id)
            gd_child_company_load(id)
            gd_aff_company_load(id)


        End If


    End Sub

    Public Sub gd_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("SELECT C.CMPNY_ID, 'SELF' as relation , C.CMPNY_NM,  C.CMPNY_ADDR_1, C.CMPNY_CITY, C.CMPNY_ST,
C.CMPNY_ZIP,C.BUYER_INDICATOR as  PDI_CUSTOMER 
,CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT
 from cmpny.company C  
 LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = c.CMPNY_ID 
                                                        WHERE C.CMPNY_ID =" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_company.DataSource = ds
                gd_company.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub gd_IDN_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("SELECT CI.CMPNY_ID, 'IDN', CI.CMPNY_NM,
                        CI.CMPNY_ADDR_1, CI.CMPNY_CITY, CI.CMPNY_ST, CI.CMPNY_ZIP,CI.BUYER_INDICATOR as  PDI_CUSTOMER
                        ,CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT
                        from cmpny.company C 
                        JOIN cmpny.company CI ON CI.CMPNY_ID = C.IDN_CMPNY_ID
                        LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = cI.CMPNY_ID 
                                                     WHERE C.CMPNY_ID =" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_IDN.DataSource = ds
                gd_IDN.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub

    Public Sub gd_parent_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("SELECT CP.CMPNY_ID, 'Org. Parent', CP.CMPNY_NM, 
                            CP.CMPNY_ADDR_1, CP.CMPNY_CITY, CP.CMPNY_ST, CP.CMPNY_ZIP,CP.BUYER_INDICATOR as  PDI_CUSTOMER
                            ,CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT
                            From cmpny.company C Join cmpny.company CP ON CP.CMPNY_ID = C.CMPNY_PRNT_ID
                            LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = cP.CMPNY_ID 
                            Where C.CMPNY_ID =" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_parent.DataSource = ds
                gd_parent.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub gd_network_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("Select CI.CMPNY_ID, 'IN NETWORK' as relation, CI.CMPNY_NM, 
                                            CI.CMPNY_ADDR_1, CI.CMPNY_CITY, CI.CMPNY_ST, CI.CMPNY_ZIP,CI.BUYER_INDICATOR as  PDI_CUSTOMER
                                            ,CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT 
                                            from cmpny.company C 
                                            JOIN cmpny.company CI ON CI.IDN_CMPNY_ID = C.IDN_CMPNY_ID
                                            LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = CI.CMPNY_ID  
                                                        WHERE C.CMPNY_ID = '" + id.ToString + "' AND CI.CMPNY_ID <>" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_network.DataSource = ds
                gd_network.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub gd_child_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand(" SELECT CC.CMPNY_ID, 'SUBSIDIARIES' as relation, CC.CMPNY_NM, CC.CMPNY_ADDR_1, CC.CMPNY_CITY, 
                        CC.CMPNY_ST, CC.CMPNY_ZIP,CC.BUYER_INDICATOR as  PDI_CUSTOMER
                             ,CONVERT(varchar, CAST( ROUND(cs.[TOTAL SALES PRIOR YEAR],0) AS money), 1) AS SALES_AMT
                             from cmpny.company CC 
                            LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = cc.CMPNY_ID  
                            WHERE CC.CMPNY_PRNT_ID =" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_child.DataSource = ds
                gd_child.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Public Sub gd_aff_company_load(ByVal id As String)

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("SELECT C.CMPNY_ID, 'SELF' as relation , C.CMPNY_NM, C.CMPNY_ADDR_1, C.CMPNY_CITY, C.CMPNY_ST, C.CMPNY_ZIP,'YES' as  PDI_CUSTOMER
                                            ,cs.[TOTAL SALES PRIOR YEAR] AS SALES_AMT 
                                                     from cmpny.company C 
                                            LEFT JOIN CMPNY.CMPNY_SALES cs ON cs.CMPNY_ID = c.CMPNY_ID 
                                            WHERE C.CMPNY_ID =" + id.ToString, conn1)

            Try
                'open connection
                conn1.Open()
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)


                gd_aff.DataSource = ds
                gd_aff.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub

    Private Sub gd_network_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd_network.PageIndexChanging
        gd_network_company_load(Session("compId"))
        gd_network.PageIndex = e.NewPageIndex
        gd_network.DataBind()

    End Sub

    Private Sub gd_child_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd_child.PageIndexChanging
        gd_child_company_load(Session("compId"))
        gd_child.PageIndex = e.NewPageIndex
        gd_child.DataBind()
    End Sub

    Private Sub gd_aff_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd_aff.PageIndexChanging
        gd_aff_company_load(Session("compId"))
        gd_aff.PageIndex = e.NewPageIndex
        gd_aff.DataBind()
    End Sub
    Private Sub gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd_aff.RowCommand, gd_child.RowCommand, gd_company.RowCommand, gd_IDN.RowCommand, gd_network.RowCommand, gd_parent.RowCommand

        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        Dim newRowIndex As Integer = 0
        Try

            If e.CommandName = "search" Then
                Dim CompanyId As String = CType(sender.Rows(rowIndex).FindControl("CMPNY_ID"), HiddenField).Value
                GetCompanySalesDetails(CompanyId)
            End If

        Catch ex As Exception

        End Try
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
    'Protected Sub ImageButton1_Click(sender As Object, e As ImageClickEventArgs) Handles ImageButton1.Click
    '    Response.Redirect("MDM_Search.aspx")


    'End Sub
End Class