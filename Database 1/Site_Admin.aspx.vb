Imports System.Data.SqlClient

Public Class Site_Admin
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ERR.Visible = False
        ERR_ftp.Visible = False
        Label3.Visible = False
        get_sales_period()
    End Sub

    Protected Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        ERR.Visible = False
        Label3.Visible = False
        JobRunning()

    End Sub



    Private Sub JobRunning()



        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("exec msdb.dbo.sp_help_job @job_name = N'ETL_NON_EDI_FILES' ;", conn1)
            Try
                conn1.Open()
                Dim dr As SqlDataReader = dbCmd.ExecuteReader()
                dr.Read()
                Dim status As Integer = Convert.ToInt32(dr("current_execution_status"))
                dr.Close()

                If status = 1 Then
                    ERR.Visible = True
                Else
                    ERR.Visible = False
                    StartJob()


                End If
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If

            End Try







        End Using



    End Sub


    Private Sub StartJob()




        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("EXEC msdb.dbo.sp_start_job N'ETL_NON_EDI_FILES' ;", conn1)



            Try
                conn1.Open()
                dbCmd.ExecuteNonQuery()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Protected Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click

        ERR_ftp.Visible = False
        Label3.Visible = False
        EDI845_OUTPUT()


    End Sub

    Public Sub EDI845_OUTPUT()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("exec msdb.dbo.sp_help_job @job_name = N'EDI_845_OUTPUT_FTP_FULL' ;", conn1)
            Try
                conn1.Open()
                Dim dr As SqlDataReader = dbCmd.ExecuteReader()
                dr.Read()
                Dim status As Integer = Convert.ToInt32(dr("current_execution_status"))
                dr.Close()

                If status = 1 Then
                    ERR_ftp.Visible = True
                Else
                    ERR.Visible = False
                    Startftpjob()


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
            Dim dbCmd As SqlCommand = New SqlCommand("EXEC msdb.dbo.sp_start_job N'EDI_845_OUTPUT_FTP_FULL' ;", conn1)



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
    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Reset_sales_period()
        TextBox1.Text = ""


    End Sub

    Private Sub Reset_sales_period()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim Cmd1 As SqlCommand = New SqlCommand("exec [TRC].[spRESET_SALES_PERIOD] @vSales_Period = N'" & TextBox1.Text.ToString & "';", conn1)
            'dbCmd.CommandType = CommandType.StoredProcedure
            'Dim para1 As SqlParameter = Cmd1.Parameters.AddWithValue("@vSales_Period", TextBox1.Text.ToString)
            ' para1.Direction = ParameterDirection.Input

            Try
                conn1.Open()
                Cmd1.ExecuteNonQuery()
                get_sales_period()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Public Sub get_sales_period()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            'Dim Cmd1 As SqlCommand = New SqlCommand("SELECT DISTINCT SALES_PERIOD FROM [STAGE].[SALES_PERIOD] 
            'WHERE LOAD_IN = 'Y'", conn1)
            'Dim s As String = ""
            'Dim sql As String = "SELECT DISTINCT SALES_PERIOD FROM [STAGE].[SALES_PERIOD] WHERE LOAD_IN = 'Y'"


            Try
                conn1.Open()

                Dim myReader As SqlDataReader = Nothing
                Dim myCommand As SqlCommand = New SqlCommand("SELECT DISTINCT SALES_PERIOD FROM [STAGE].[SALES_PERIOD] WHERE LOAD_IN = 'Y'", conn1)
                myReader = myCommand.ExecuteReader()
                While myReader.Read()
                    Label1.Text = myReader(0).ToString()
                    Label2.Text = myReader(0).ToString()

                End While


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Protected Sub TextBox1_TextChanged(sender As Object, e As EventArgs) Handles TextBox1.TextChanged

    End Sub

    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Label4.Visible = False

        EDI845_IMPORT_CHANGE()


    End Sub

    Public Sub EDI845_IMPORT_CHANGE()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("exec msdb.dbo.sp_help_job @job_name = N'EDI_845_IMPORT_CHANGE' ;", conn1)
            Try
                conn1.Open()
                Dim dr As SqlDataReader = dbCmd.ExecuteReader()
                dr.Read()
                Dim status As Integer = Convert.ToInt32(dr("current_execution_status"))
                dr.Close()

                If status = 1 Then
                    Label4.Visible = True
                Else
                    ERR.Visible = False
                    startIMPORTjob()


                End If
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If

            End Try
        End Using
    End Sub
    Public Sub startIMPORTjob()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("EXEC msdb.dbo.sp_start_job N'EDI_845_IMPORT_CHANGE' ;", conn1)



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

    Protected Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Label5.Visible = False

        EDI845_IMPORT_PRC_AUTH_CHANGE()
    End Sub

    Public Sub EDI845_IMPORT_PRC_AUTH_CHANGE()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("exec msdb.dbo.sp_help_job @job_name = N'EDI_845_IMPORT_CHANGE_PRICE_AUTHORIZATION' ;", conn1)
            Try
                conn1.Open()
                Dim dr As SqlDataReader = dbCmd.ExecuteReader()
                dr.Read()
                Dim status As Integer = Convert.ToInt32(dr("current_execution_status"))
                dr.Close()

                If status = 1 Then
                    Label5.Visible = True
                Else
                    ERR.Visible = False
                    startIMPORTPRCAUTHjob()


                End If
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If

            End Try
        End Using

    End Sub
    Public Sub startIMPORTPRCAUTHjob()

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)
            Dim dbCmd As SqlCommand = New SqlCommand("EXEC msdb.dbo.sp_start_job N'EDI_845_IMPORT_CHANGE_PRICE_AUTHORIZATION' ;", conn1)



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
End Class