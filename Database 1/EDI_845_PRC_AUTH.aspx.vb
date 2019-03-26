Imports System.Data.SqlClient



Public Class EDI_845_PRC_AUTH
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Label5.Visible = False
        If Not IsPostBack Then
            Get_prc_details()

        End If

    End Sub
    Private Sub Get_prc_details()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)




            Dim cmd1 As SqlCommand = New SqlCommand("[CNT].[spDSPLY_PND_PRC_AUTH]", conn1)


            cmd1.CommandType = CommandType.StoredProcedure

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
    Protected Sub btn_drop_Click(sender As Object, e As EventArgs) Handles btn_drop.Click
        EDI845_ftp()
    End Sub
    Public Sub EDI845_ftp()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("exec msdb.dbo.sp_help_job @job_name = N'EDI_845_OUTPUT_FTP' ;", conn1)
            Try
                conn1.Open()
                Dim dr As SqlDataReader = dbCmd.ExecuteReader()
                dr.Read()
                Dim status As Integer = Convert.ToInt32(dr("current_execution_status"))
                dr.Close()

                If status = 1 Then
                    Label5.Visible = True

                Else

                    startftpjob()


                End If
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If

            End Try
        End Using
    End Sub
    Public Sub startftpjob()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("EXEC msdb.dbo.sp_start_job N'EDI_845_OUTPUT_FTP' ;", conn1)



            Try
                conn1.Open()
                dbCmd.ExecuteNonQuery()
                'Label3.Visible = True
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



    End Sub

End Class