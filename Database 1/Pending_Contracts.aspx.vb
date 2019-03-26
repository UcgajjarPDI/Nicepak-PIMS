Imports System.Data.SqlClient

Public Class Pending_Contracts
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        GetItemsData()

        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Pending Contracts"
        Main_Menu.Text = "Contract Management"
    End Sub

    Private Sub GetItemsData()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGET_PENDING_CONTRACTS", conn1)

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

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

End Class