Imports System.Data.SqlClient

Public Class WebForm3
    Inherits Page

    Private Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        'GetItemsData()
        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Sales Tracing Summary"
        Main_Menu.Text = "Sales Tracing"
        If Not IsPostBack Then
            getdropdowndata()
            DropDownExtender1_SelectedIndexChanged(vbNull, New EventArgs)


        End If

    End Sub

    Private Sub GetItemsData_first()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_CURR_MNTH]", conn1)

            Dim Param1 As SqlParameter = cmd1.Parameters.AddWithValue("@vSALES_PERIOD", DBNull.Value)
            Dim Param2 As SqlParameter = cmd1.Parameters.AddWithValue("@vSLS_PERIOD_TYP", "CURRENT")
            cmd1.CommandType = CommandType.StoredProcedure
            Param1.Direction = ParameterDirection.Input
            Param2.Direction = ParameterDirection.Input
            cmd1.Parameters.Add("@currSALES_PERIOD", SqlDbType.VarChar, 10)
            cmd1.Parameters("@currSALES_PERIOD").Direction = ParameterDirection.Output
            cmd1.Parameters.Add("@currDSPLY_NM", SqlDbType.VarChar, 20)
            cmd1.Parameters("@currDSPLY_NM").Direction = ParameterDirection.Output
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                'Dim adapter2 As SqlDataAdapter = New SqlDataAdapter(cmd2)
                Dim sales_table As New DataTable


                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                'adapter2.Fill(sales_table)

                gd1.DataSource = ds
                gd1.DataBind()

                Session("sp_salesperiod") = cmd1.Parameters("@currSALES_PERIOD").Value.ToString()
                Session("sp_salesperiod_dis") = cmd1.Parameters("@currDSPLY_NM").Value.ToString()
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub

    Private Sub GetItemsData_DropDown()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_CURR_MNTH]", conn1)

            Dim Param1 As SqlParameter = cmd1.Parameters.AddWithValue("@vSALES_PERIOD", Session("sp_salesperiod").ToString())
            Dim Param2 As SqlParameter = cmd1.Parameters.AddWithValue("@vSLS_PERIOD_TYP", Session("sp_salesperiod_typ").ToString())
            cmd1.CommandType = CommandType.StoredProcedure
            Param1.Direction = ParameterDirection.Input
            Param2.Direction = ParameterDirection.Input
            cmd1.Parameters.Add("@currSALES_PERIOD", SqlDbType.VarChar, 10)
            cmd1.Parameters("@currSALES_PERIOD").Direction = ParameterDirection.Output
            cmd1.Parameters.Add("@currDSPLY_NM", SqlDbType.VarChar, 20)
            cmd1.Parameters("@currDSPLY_NM").Direction = ParameterDirection.Output
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)
                'Dim adapter2 As SqlDataAdapter = New SqlDataAdapter(cmd2)
                Dim sales_table As New DataTable


                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                'adapter2.Fill(sales_table)

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
    Private Sub getdropdowndata()

        'DropDownExtender1.Items.Add(New ListItem("--Please Select Sales Period--", ""))
        'DropDownExtender1.AppendDataBoundItems = True
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        Dim strQuery As String = "SELECT SLS_PERIOD+'~'+SLS_PERIOD_TYP + '~' + SLS_PERIOD_DSPLY_NM as sp_value, 
                            * FROM TRC.SALES_PERIOD_ADMIN ORDER BY SLS_PERIOD DESC"
        Dim con As New SqlConnection(CS)
        Dim cmd As New SqlCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = strQuery
        cmd.Connection = con
        Try
            con.Open()
            DropDownExtender1.DataSource = cmd.ExecuteReader()
            DropDownExtender1.DataTextField = "SLS_PERIOD_DSPLY_NM"
            DropDownExtender1.DataValueField = "sp_value"
            DropDownExtender1.DataBind()

        Catch ex As Exception
            Throw ex
        Finally
            con.Close()
            con.Dispose()
        End Try

    End Sub

    Protected Sub DropDownExtender1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownExtender1.SelectedIndexChanged
        If DropDownExtender1.SelectedValue <> "" Then
            Dim Segments As String() = DropDownExtender1.SelectedValue.Split("~")
            ' Response.Write("You Selected: " & Segments(0) & ", " + Segments(1))
            Session("sp_salesperiod") = Segments(0).ToString
            Session("sp_salesperiod_typ") = Segments(1).ToString
            Session("sp_salesperiod_dis") = Segments(2).ToString
            GetItemsData_DropDown()
        Else
            GetItemsData_first()

        End If

    End Sub


    Protected Friend Sub gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd1.RowCommand
        Try
            If e.CommandName = "select" Then
                Dim pageSize As Integer = gd1.PageSize
                Dim pageIndex As Integer = gd1.PageIndex
                Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
                Dim newRowIndex As Integer = 0

                If pageIndex > 0 Then
                    newRowIndex = pageIndex * pageSize
                    rowIndex = rowIndex - newRowIndex
                End If

                'row.Cells(CellIndex).Text
                Dim distID As String = CType(gd1.Rows(rowIndex).FindControl("DIST_ID"), Label).Text
                Dim salesperiod_gd1 As String = CType(gd1.Rows(rowIndex).FindControl("sales_period_gd1"), Label).Text
                Dim distname As String = CType(gd1.Rows(rowIndex).FindControl("PROD"), Label).Text
                Session("Dist_ID_gd1") = distID.ToString
                Session("Sales_period_gd1") = salesperiod_gd1.ToString
                Session("dist_name") = distname.ToString
                graph()
                ModalPopupExtender1.Show()
            End If
        Catch ex As Exception

        End Try


    End Sub


    Private Sub graph()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_DIST_TREND]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vSALES_PERIOD", Session("Sales_period_gd1").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vDist_NR", Session("Dist_ID_gd1").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim dt As DataTable = New DataTable
                adapter.Fill(dt)
                Dim x As String() = New String(dt.Rows.Count - 1) {}
                Dim y As Decimal() = New Decimal(dt.Rows.Count - 1) {}
                For i As Integer = 0 To dt.Rows.Count - 1
                    x(i) = dt.Rows(i)(1).ToString()
                    y(i) = Convert.ToInt32(dt.Rows(i)(3))

                Next
                LineChart1.Series.Add(New AjaxControlToolkit.LineChartSeries() With {
                 .Name = "AVG OF 6 MONTHS    " + "    ",
                 .Data = y,
                 .LineColor = "#808080"
                })
                y = New Decimal(dt.Rows.Count - 1) {}
                For i As Integer = 0 To dt.Rows.Count - 1
                    x(i) = dt.Rows(i)(1).ToString()
                    y(i) = Convert.ToInt32(dt.Rows(i)(2))

                Next
                LineChart1.Series.Add(New AjaxControlToolkit.LineChartSeries() With {
                 .Name = Session("dist_name").ToString,
                 .Data = y,
                 .LineColor = "#A40000"
                })
                LineChart1.CategoriesAxis = String.Join(",", x)

                LineChart1.ChartTitle = Session("dist_name").ToString + " " + "Line Chart"
                LineChart1.ChartTitleColor = "#A40000"

                LineChart1.Visible = True
            Catch Ex As Exception
                Throw
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

End Class