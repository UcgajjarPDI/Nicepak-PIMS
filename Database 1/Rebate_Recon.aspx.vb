Imports System.Data.SqlClient


Public Class Rebate_Recon
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("sp_salesperiod") IsNot Nothing Then
            Dim Page_name As Label = Master.FindControl("Page_name")
            Dim Main_Menu As Label = Master.FindControl("Main_Menu")
            Page_name.Text = "Rebate Recon"
            Main_Menu.Text = "Sales Tracing"
            If Not IsPostBack Then
                getexp_cont()
                InvalidProductOnContract()
                UnknownProduct()
                ContractID()
                sales_period.Text = Session("sp_salesperiod_dis").ToString()

            End If
        Else
            Response.Write("Please select sales period in Current Month Sales page")

        End If
    End Sub


    Private Sub getexp_cont()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_ERR_EXC]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vSales_Period", Session("sp_salesperiod").ToString())


            Param3.Direction = ParameterDirection.Input
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

    Private Sub InvalidProductOnContract()

        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_ERR_PNC]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vSales_Period", Session("sp_salesperiod").ToString())


            Param3.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd2.DataSource = ds
                gd2.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub


    Private Sub UnknownProduct()

        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_ERR_UPI]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vSales_Period", Session("sp_salesperiod").ToString())


            Param3.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd3.DataSource = ds
                gd3.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    Private Sub ContractID()

        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_ERR_UCI]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vSales_Period", Session("sp_salesperiod").ToString())


            Param3.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd4.DataSource = ds
                gd4.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    Private Sub popup_exp_cont1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR_by_grp]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                pop1.DataSource = ds
                pop1.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub
    Private Sub popup_exp_cont2()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                pop2.DataSource = ds
                pop2.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub



    Private Sub gd2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd2.PageIndexChanging
        'InvalidProductOnContract()
        gd2.PageIndex = e.NewPageIndex
        InvalidProductOnContract()


    End Sub
    Private Sub gd3_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd3.PageIndexChanging
        'UnknownProduct()
        gd3.PageIndex = e.NewPageIndex
        UnknownProduct()


    End Sub

    Private Sub gd4_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd4.PageIndexChanging
        'ContractID()
        gd4.PageIndex = e.NewPageIndex
        ContractID()


    End Sub

    Protected Sub Gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd1.RowCommand

        Dim a As String = e.CommandArgument


        'If e.CommandName = "Select" Then
        'Determine the RowIndex of the Row whose Button was clicked.
        'Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        ' Dim As Integer = Int32.Parse(e.CommandArgument.ToString())
        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)

        'Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        'Reference the GridView Row.
        Dim row As GridViewRow = gd1.Rows(rowIndex)

        'row.Cells(CellIndex).Text
        Dim contractid As String = CType(row.FindControl("dis"), Label).Text
        Dim groupname As String = CType(row.FindControl("bu_gp"), Label).Text

        Dim productid As String = CType(row.FindControl("pr_id"), Label).Text
        Session("exp_con") = contractid.ToString()
        Session("exp_grp") = groupname.ToString()
        Session("exp_prod") = productid.ToString()


        Lb1.Text = CType(row.FindControl("bu_gp"), Label).Text 'Session("exp_grp") = groupname.ToString()
        Lb2.Text = Session("exp_prod").ToString()

        popup_exp_cont1()
        popup_exp_cont2()
        ModalPopupExtender1.Show()

        'End If

    End Sub
    Private Sub popup_exp_prod1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR_by_grp]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                prod_up_pop1.DataSource = ds
                prod_up_pop1.DataBind()

                If prod_up_pop1.Rows.Count <= 0 Then
                    hidgd3.Visible = True
                    hidgd3.Text = "Record is empty"
                    Button8.Visible = False
                Else
                    hidgd3.Visible = False
                    Button8.Visible = True
                End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub
    Private Sub popup_exp_prod2()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                prod_up_pop2.DataSource = ds
                prod_up_pop2.DataBind()
                If prod_up_pop2.Rows.Count = 0 Then
                    hidgd4.Visible = True
                    hidgd4.Text = "Record is empty"
                    Button9.Visible = False

                End If

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub
    Private Sub Gd2_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd2.RowCommand

        Dim a As String = e.CommandArgument


        'If e.CommandName = "Select" Then
        'Determine the RowIndex of the Row whose Button was clicked.
        'Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        ' Dim As Integer = Int32.Parse(e.CommandArgument.ToString())
        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)

        'Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)
        'Reference the GridView Row.
        Dim row As GridViewRow = gd2.Rows(rowIndex)

        'row.Cells(CellIndex).Text
        Dim contractid As String = CType(row.FindControl("dis"), Label).Text
        Dim groupname As String = CType(row.FindControl("bu_gp"), Label).Text

        Dim productid As String = CType(row.FindControl("con_ID"), Label).Text
        Session("exp_con") = contractid.ToString()
        Session("exp_grp") = groupname.ToString()
        Session("exp_prod") = productid.ToString()


        lb3.Text = CType(row.FindControl("bu_gp"), Label).Text 'Session("exp_grp") = groupname.ToString()
        lb4.Text = Session("exp_prod").ToString()

        popup_exp_prod1()
        popup_exp_prod2()
        ModalPopupExtender2.Show()

        'End If

    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        savepop1()
        getexp_cont()
        ModalPopupExtender1.Hide()
    End Sub
    Private Sub savepop1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("TRC.spTRC_SAVE_EXC_CORR", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In pop1.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

                    End If
                End If
            Next


            Try
                'open connection
                conn1.Open()


                cmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        savepop2()
    End Sub
    Private Sub savepop2()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("TRC.spTRC_SAVE_EXC_CORR", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In pop2.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

                    End If
                End If
            Next


            Try
                'open connection
                conn1.Open()


                cmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        save_popup_exp_prod1()
        InvalidProductOnContract()
        ModalPopupExtender2.Hide()


    End Sub

    Private Sub save_popup_exp_prod1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("TRC.spTRC_SAVE_EXC_CORR", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In prod_up_pop1.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

                    End If
                End If
            Next


            Try
                'open connection
                conn1.Open()


                cmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        save_popup_exp_prod2()
        InvalidProductOnContract()
        ModalPopupExtender2.Hide()
    End Sub

    Private Sub save_popup_exp_prod2()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("TRC.spTRC_SAVE_EXC_CORR", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In prod_up_pop2.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

                    End If
                End If
            Next


            Try
                'open connection
                conn1.Open()


                cmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        saveun_prod()
    End Sub
    Private Sub saveun_prod()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[TRC].[spTRC_SAVE_UPI_CORR]", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In gd3.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vDIST_NR", row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vDIST_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vTRC_PROD_ID", row.Cells(3).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vUPD_PROD_ID", row.Cells(4).Controls.OfType(Of TextBox)().FirstOrDefault().Text)

                    End If
                End If
            Next


            Try
                'open connection
                conn1.Open()


                cmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
                UnknownProduct()
            End Try
        End Using
    End Sub

    Protected Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        saveun_cont()
    End Sub
    Private Sub saveun_cont()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[TRC].[spTRC_SAVE_UCI_CORR]", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In gd4.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then
                        Dim c12we As String = row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text.ToString



                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(3).Controls.OfType(Of TextBox)().FirstOrDefault().Text)


                    End If

                End If

            Next

            Try
                conn1.Open()
                cmd.ExecuteNonQuery()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
                ContractID()
            End Try
        End Using
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        getexp_cont()
        ModalPopupExtender1.Hide()

    End Sub



    Private Sub Button10_Click(sender As Object, e As EventArgs) Handles Button10.Click
        InvalidProductOnContract()
        ModalPopupExtender2.Hide()
    End Sub

    Private Sub prod_up_pop1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles prod_up_pop1.PageIndexChanging
        prod_up_pop1.PageIndex = e.NewPageIndex
        popup_exp_prod1()
    End Sub

    Private Sub prod_up_pop2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles prod_up_pop2.PageIndexChanging
        prod_up_pop2.PageIndex = e.NewPageIndex
        popup_exp_prod2()
    End Sub

    Public Sub pop1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles pop1.PageIndexChanging
        pop1.PageIndex = e.NewPageIndex
        popup_exp_cont1()
    End Sub

    Public Sub pop2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles pop2.PageIndexChanging
        pop2.PageIndex = e.NewPageIndex
        popup_exp_cont2()

    End Sub

    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub
End Class