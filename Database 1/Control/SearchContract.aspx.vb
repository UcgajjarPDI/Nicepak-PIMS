Imports System.Data.SqlClient


Public Class SearchContract
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub


    Private Sub popup_exp_cont1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR_by_grp]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                pop1.DataSource = ds
                pop1.DataBind()

            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub popup_exp_cont2()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_EXC_CORR]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@vCNT_ID", Session("exp_con").ToString())
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Try
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                pop2.DataSource = ds
                pop2.DataBind()

            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Private Sub savepop1()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        Using conn1 As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("TRC.spTRC_SAVE_EXC_CORR", conn1)
            cmd.CommandType = CommandType.StoredProcedure
            For Each row As GridViewRow In pop1.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then

                        cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
                        cmd.Parameters.AddWithValue("@vUPD_CNT_ID", row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text)
                        cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

                    End If
                End If
            Next

            Try
                conn1.Open()
                cmd.ExecuteNonQuery()

            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using
    End Sub

    Public Sub pop2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles pop2.PageIndexChanging
        pop2.PageIndex = e.NewPageIndex
        popup_exp_cont2()

    End Sub

    Protected Sub pop1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles pop1.RowCommand
        Try
            If e.CommandName = "select" Then
                Dim contractID As String = Convert.ToString(e.CommandArgument)
                Dim newRowIndex As Integer = 0

                'Dim contractID As String = CType(pop1.Rows(rowIndex).FindControl("CONTRACT_NO"), Label).Text

                Session("Dist_ID_gd1") = contractID.ToString
                ClientScript.RegisterStartupScript(Me.GetType(), "winclose", "window.parent.close();", True)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Session("exp_con")) Then
            Lb1.Text = Session("exp_grp").ToString
            Lb2.Text = Session("exp_prod").ToString
            popup_exp_cont1()
            popup_exp_cont2()
        End If
    End Sub

    Protected Sub pop2_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles pop2.RowCommand
        Try
            If e.CommandName = "select" Then
                Dim contractID As String = Convert.ToString(e.CommandArgument)
                Dim newRowIndex As Integer = 0

                'Dim contractID As String = CType(pop1.Rows(rowIndex).FindControl("CONTRACT_NO"), Label).Text

                Session("Dist_ID_gd1") = contractID.ToString
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
End Class
