Imports System.Data.SqlClient


Public Class Price_Authorization
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Price Authorization"

        Main_Menu.Text = "Contract Management"
        GetPRC_AUTH_Data()


    End Sub

    Private Sub GetPRC_AUTH_Data()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGet_Price_Authorization", conn1)
                cmd.CommandType = CommandType.StoredProcedure

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

    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        GetPRC_AUTH_Data()
    End Sub
End Class