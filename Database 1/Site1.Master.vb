Public Class Site1
    Inherits MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("user") IsNot Nothing Then

            Label1.Visible = True
            Label1.Text = "Welcome " + Session("Greet").ToString()
        Else
        End If


    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click

        Response.Redirect("CurrentMonthSales.aspx")

    End Sub

    Protected Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click

    End Sub

    Protected Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Response.Redirect("Pending_Contracts.aspx")
    End Sub

    Protected Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Response.Redirect("Active_Contract.aspx")
    End Sub

    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Response.Redirect("Rebate_Recon.aspx")
    End Sub

    Protected Sub Button14_Click(sender As Object, e As EventArgs) Handles Button14.Click
        Response.Redirect("Exception_Recon.aspx")
        If Session("sp_salesperiod") IsNot Nothing Then
            Response.Redirect("Exception_Recon.aspx")
        Else

            'Page.ClientScript.RegisterStartupScript(Me.[GetType](), "Window", "window.alert('Please select sales period in curent month sales period','');", True)
            Response.Redirect("CurrentMonthSales.aspx")
            Page.ClientScript.RegisterStartupScript(Me.[GetType](), "Window", "window.alert('Please select sales period in curent month sales period','');", True)
        End If

    End Sub

    Protected Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Response.Redirect("Master_Data.aspx")
    End Sub


    Protected Sub Button10_Click(sender As Object, e As EventArgs) Handles Button10.Click
        Response.Redirect("Price_Authorization.aspx")
    End Sub

    Protected Sub Button11_Click(sender As Object, e As EventArgs) Handles Button11.Click
        Response.Redirect("Tier_Complance.aspx")
    End Sub

    Protected Sub Button13_Click(sender As Object, e As EventArgs) Handles Button13.Click

    End Sub

    Protected Sub Button15_Click(sender As Object, e As EventArgs) Handles Button15.Click
        Response.Redirect("Site_Admin.aspx")
    End Sub

    Protected Sub btnInitiateContract_Click(sender As Object, e As EventArgs) Handles btnInitiateContract.Click
        Response.Redirect("New_Contract.aspx")
    End Sub

    Protected Sub Button17_Click(sender As Object, e As EventArgs) Handles Button17.Click
        Response.Redirect("EDI_845_CONTRACT.aspx")
    End Sub
End Class