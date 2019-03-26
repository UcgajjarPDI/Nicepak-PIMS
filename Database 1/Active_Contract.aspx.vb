Imports System.Data.SqlClient

Public Class Active_Contract
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetContractData30()
            GetContractData60()
            Dim Page_name As Label = Master.FindControl("Page_name")
            Dim Main_Menu As Label = Master.FindControl("Main_Menu")
            Page_name.Text = "Active Contracts"
            Main_Menu.Text = "Contract Management"
        End If

    End Sub

    Private Sub GetContractData30()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[PCM].[spPCM_Get_Contract_90]", conn)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@UNM", "") ' Session("user").ToString)
            Param1.Direction = ParameterDirection.Input

            Try
                'open connection
                conn.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                'bind the data
                'CntRepeater.DataSource = ds
                ' CntRepeater.DataBind()
                'GridView1.DataSource = ds
                ' GridView1.DataBind()

                gd1.DataSource = ds
                gd1.DataBind()


                ' msgLabel.Text = " Total Record found -" & Param1.Value
                If gd1.Rows.Count = 0 Then
                    gd1.Visible = False
                    visible1.Visible = True
                    visible1.Text = "No contract is Expiering in 90 days"


                End If

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Sub
    Private Sub GetContractData60()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[PCM].[spPCM_Get_Contract_60]", conn)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@UNM", "") ' Session("user").ToString)
            Param1.Direction = ParameterDirection.Input

            Try
                'open connection
                conn.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd2.DataSource = ds
                gd2.DataBind()


                ' msgLabel.Text = " Total Record found -" & Param1.Value
                If gd2.Rows.Count = 0 Then
                    gd2.Visible = False
                    visible2.Visible = True
                    visible2.Text = "No contract is Expiering in 60 days"


                End If

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Sub


    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Ct_like()

    End Sub

    Private Sub Ct_like()

        For Each row1 As GridViewRow In gd1.Rows
            If row1.RowType = DataControlRowType.DataRow Then
                Dim chkcheck As CheckBox = DirectCast(row1.FindControl("ckpop1"), CheckBox)
                Dim rd1 As String = row1.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text
                If chkcheck.Checked = True Then
                    Session("CNT") = rd1.ToString
                    Response.Redirect("Create_Alike.aspx")




                End If
            End If

        Next
        For Each row2 As GridViewRow In gd2.Rows
            If row2.RowType = DataControlRowType.DataRow Then
                Dim chkcheck1 As CheckBox = DirectCast(row2.FindControl("chkCheck"), CheckBox)
                Dim rd2 As String = row2.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text
                If chkcheck1.Checked = True Then


                    Session("CNT") = rd2.ToString

                    Response.Redirect("Create_Alike.aspx")

                End If
            End If

        Next

    End Sub



End Class