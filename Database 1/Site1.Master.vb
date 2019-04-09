Public Class Site1
    Inherits MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("user") IsNot Nothing Then

            lblUser.Visible = True
            lblUser.Text = "Welcome " + Session("Greet").ToString()
        End If

    End Sub

End Class