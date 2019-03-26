Imports System.Data.SqlClient

Public Class Master_Data
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Btn_Gd1_Save.Visible = False
        If Not IsPostBack Then
            'GetMasterData()
            Dim Page_name As Label = Master.FindControl("Page_name")
            Dim Main_Menu As Label = Master.FindControl("Main_Menu")
            Page_name.Text = "Master Data"
            Main_Menu.Text = "Sales Tracing"
            Getdropdown_terr()
        End If

    End Sub
    Private Sub GetMasterData()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[MDM].[spTRC_GET_CO_USR_FEEDBK]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@TERR_ID", drop_ter.SelectedValue.ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@RSTATUS", drp_Filter.SelectedValue.ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd1.DataSource = ds
                gd1.DataBind()
                Btn_Gd1_Save.Visible = True

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub

    Private Sub Getdropdown_terr()
        drop_ter.Items.Add(New ListItem("--Select--", ""))
        drop_ter.AppendDataBoundItems = True
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString



        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[MDM].[spDISPLAY_TERR]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            cmd1.Connection = conn1

            Try
                'open connection
                conn1.Open()

                drop_ter.DataSource = cmd1.ExecuteReader()
                drop_ter.DataTextField = "TERRITORY_NAME"
                drop_ter.DataValueField = "TERRITORY_ID"
                drop_ter.DataBind()



            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    Private Sub save_gd1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)



            ''SQL Command - the name have to exactly the same as in SQL server database in Exec command
            'cmd As SqlCommand = New SqlCommand("MDM.spTRC_SAVE_CO_USR_FEEDBK", conn1)
            '    cmd.CommandType = CommandType.StoredProcedure
            Dim para1 As New SqlParameter
            Dim para2 As New SqlParameter
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            For Each row As GridViewRow In gd1.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    Dim rd1 As Boolean = row.Cells(5).Controls.OfType(Of RadioButton)().FirstOrDefault().Checked
                    Dim rd2 As Boolean = row.Cells(6).Controls.OfType(Of RadioButton)().FirstOrDefault().Checked



                    If isChecked Then



                        If rd1 Then
                            Using cmd As SqlCommand = New SqlCommand("MDM.spTRC_SAVE_CO_USR_FEEDBK", conn1)
                                cmd.CommandType = CommandType.StoredProcedure
                                para1 = cmd.Parameters.AddWithValue("@FEEDBK_ID", row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)
                                para2 = cmd.Parameters.AddWithValue("@FEEDBK", "A")
                                para1.Direction = ParameterDirection.Input
                                para2.Direction = ParameterDirection.Input
                                conn1.Open()


                                cmd.ExecuteNonQuery()
                                conn1.Close()
                            End Using


                        ElseIf rd2 Then
                            Using cmd As SqlCommand = New SqlCommand("MDM.spTRC_SAVE_CO_USR_FEEDBK", conn1)
                                cmd.CommandType = CommandType.StoredProcedure
                                para1 = cmd.Parameters.AddWithValue("@FEEDBK_ID", row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)
                                para2 = cmd.Parameters.AddWithValue("@FEEDBK", "R")
                                para1.Direction = ParameterDirection.Input
                                para2.Direction = ParameterDirection.Input
                                conn1.Open()


                                cmd.ExecuteNonQuery()
                                conn1.Close()
                            End Using

                        Else
                            Lbl_Error.EnableViewState = True
                            Lbl_Error.Text = "Please Accept or Reject"
                        End If

                    End If
                End If

            Next


            Try
                'open connection


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try

        End Using

    End Sub
    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        GetMasterData()
    End Sub

    Protected Sub btn_drop_Click(sender As Object, e As EventArgs) Handles btn_drop.Click
        If drop_ter.SelectedValue = "" Then
            Lbl_Error.EnableViewState = True
            Lbl_Error.Text = "Please Select Territory and Filter"
            gd1.Visible = False
            Btn_Gd1_Save.Visible = False
        ElseIf drp_Filter.SelectedValue = "" Then
            Lbl_Error.EnableViewState = True
            Lbl_Error.Text = "Please Select Territory and Filter"
            gd1.Visible = False
            Btn_Gd1_Save.Visible = False
        Else

            Lbl_Error.EnableViewState = False
            GetMasterData()
            gd1.Visible = True
            Btn_Gd1_Save.Visible = True
        End If
    End Sub

    Protected Sub Btn_Gd1_Save_Click(sender As Object, e As EventArgs) Handles Btn_Gd1_Save.Click
        save_gd1()
        GetMasterData()
    End Sub

    Protected Sub drp_Filter_SelectedIndexChanged(sender As Object, e As EventArgs) Handles drp_Filter.SelectedIndexChanged

    End Sub

    Protected Sub drop_ter_SelectedIndexChanged(sender As Object, e As EventArgs) Handles drop_ter.SelectedIndexChanged

    End Sub
End Class