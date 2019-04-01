
Imports System.Data.SqlClient

Public Class WebForm2
    Inherits Page

    Public Sub New()

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        btnLogIn.Attributes.Add("class", "static")
        btnLogIn.Attributes.Add("onMouseOver", "this.className='hoverbutton'")
        btnLogIn.Attributes.Add("onMouseOut", "this.className='static'")
        Dim navigation As Control = Master.FindControl("navigation")
        navigation.Visible = False
        ''Page_name. = "Login Page"
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Main_Menu.Text = "Login Page"


    End Sub

    Private Sub Validate_User()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        '' Dim userid As String = Session("user").ToString
        Using conn As New SqlConnection(CS)
            'Dim cmd As SqlCommand = New SqlCommand("[PCM].[spValidate_User]", conn)
            Using cmd As New SqlCommand("[PCM].spValidate_User", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@UNM", txtUNM.Text.Trim())
                cmd.Parameters.AddWithValue("@PWD", txtPWD.Text.Trim())

                cmd.Parameters.Add("@Msg", SqlDbType.VarChar, 96)
                cmd.Parameters("@Msg").Direction = ParameterDirection.Output

                cmd.Parameters.Add("@UID", SqlDbType.SmallInt)
                cmd.Parameters("@UID").Direction = ParameterDirection.Output
                cmd.Parameters.Add("@Greet_NM", SqlDbType.VarChar, 40)
                cmd.Parameters("@Greet_NM").Direction = ParameterDirection.Output
                cmd.Parameters.Add("@Role", SqlDbType.VarChar, 20)
                cmd.Parameters("@Role").Direction = ParameterDirection.Output

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()

                If cmd.Parameters("@Msg").Value.ToString() = "Valid" Then
                    Session("userId") = cmd.Parameters("@UID").Value.ToString()
                    Session("user") = cmd.Parameters("@UNM").Value.ToString()
                    Session("Greet") = cmd.Parameters("@Greet_NM").Value.ToString()

                    Response.Redirect("CurrentMonthSales.aspx")

                Else
                    lblMsg.Text = cmd.Parameters("@Msg").Value.ToString()
                    'Response.Redirect("LogIn.aspx")
                End If
                Try

                Catch ex As Exception
                Finally

                    conn.Close()
                End Try

            End Using
        End Using

    End Sub



    Private Sub btnLogIn_Click(sender As Object, e As EventArgs) Handles btnLogIn.Click

        Validate_User()

    End Sub

    Protected Sub txtUNM_TextChanged(sender As Object, e As EventArgs) Handles txtUNM.TextChanged

    End Sub
End Class