Public Class Site1
    Inherits MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("user") IsNot Nothing Then

            Label1.Visible = True
            Label1.Text = "Welcome " + Session("Greet").ToString()
        Else
        End If


    End Sub

End Class