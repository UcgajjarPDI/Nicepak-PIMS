﻿Imports System.Data.SqlClient


Public Class ExpiredContractRecon
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Dim Page_name As Label = Master.FindControl("Page_name")
            Dim Main_Menu As Label = Master.FindControl("Main_Menu")
            Page_name.Text = "Expired Contract "
            Main_Menu.Text = "Sales Tracing"
            getExpiredBuyersGroups()
            getExpiredContracts()
            getexp_cont()
        End If

        If (Session("exp_con") <> Nothing) Then

            rdoApplyToAll.Text = String.Format("Apply to Product {0} only", Session("exp_prod"))
            rdoApplyToThis.Text = String.Format("Apply to all Products in Contract {0}.", Session("exp_con"))
        End If
    End Sub

    Private Sub getexp_cont()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("[TRC].[spTRC_GET_ERR_EXC]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            If (ddlBuyersGrp.SelectedValue <> "") Then
                Dim BuyGrp As SqlParameter = cmd1.Parameters.AddWithValue("@buyerGrp", ddlBuyersGrp.SelectedValue)
                BuyGrp.Direction = ParameterDirection.Input
            End If
            If (ddlContracts.SelectedValue <> "") Then
                Dim contractId As SqlParameter = cmd1.Parameters.AddWithValue("@contractId", ddlContracts.SelectedValue)
                contractId.Direction = ParameterDirection.Input
            End If

            Try
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd1.DataSource = ds
                gd1.DataBind()
                btnSubmit.Visible = IIf(ds.Tables.Item(0).Rows.Count > 0, True, False)

            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

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

    Protected Sub Gd1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gd1.RowCommand

        Dim a As String = e.CommandArgument
        Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)

        Dim row As GridViewRow = gd1.Rows(rowIndex)

        Dim contractid As String = CType(row.FindControl("dis"), Label).Text
        Dim groupname As String = CType(row.FindControl("bu_gp"), Label).Text

        Dim productid As String = CType(row.FindControl("pr_id"), Label).Text

        Session("exp_con") = contractid.ToString()
        Session("exp_grp") = groupname.ToString()
        Session("exp_prod") = productid.ToString()



        If e.CommandName = "select" Then
            popup_exp_cont1()
            popup_exp_cont2()

            ModalPopupExtender1.Show()

            lblCnt.Text = contractid.ToString()
            lblProd.Text = productid.ToString()
        ElseIf e.CommandName = "Erase" Then
            EraseReplacedContract()
            getexp_cont()
        End If


    End Sub

    Private Sub savepop1(ByVal contractID As String)
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("TRC.spReplaceExpiredContracts", conn1)
            cmd.CommandType = CommandType.StoredProcedure

            If (ddlBuyersGrp.SelectedValue <> "") Then
                Dim BuyGrp As SqlParameter = cmd.Parameters.AddWithValue("@buyerGrp", ddlBuyersGrp.SelectedValue)
                BuyGrp.Direction = ParameterDirection.Input
            End If
            cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
            cmd.Parameters.AddWithValue("@vUPD_CNT_ID", contractID)
            cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

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

    Private Sub EraseReplacedContract()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        Using conn1 As New SqlConnection(CS)

            Dim cmd As SqlCommand = New SqlCommand("TRC.spEraseReplacedContract", conn1)
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@vTRC_CNT_ID", Session("exp_con").ToString())
            cmd.Parameters.AddWithValue("@vPROD_ID", Session("exp_prod").ToString())

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

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        getexp_cont()
        ModalPopupExtender1.Hide()
    End Sub

    Public Sub pop1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles pop1.PageIndexChanging
        pop1.PageIndex = e.NewPageIndex
        popup_exp_cont1()
    End Sub

    Public Sub pop2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles pop2.PageIndexChanging
        pop2.PageIndex = e.NewPageIndex
        popup_exp_cont2()
    End Sub

    Private Sub getExpiredContracts(Optional ByVal buyersGrp As String = "")
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        ddlContracts.Items.Clear()

        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("TRC.spTRC_GET_ERR_EXC_CONTRACTS", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            If (Not String.IsNullOrEmpty(buyersGrp)) Then
                Dim BuyGrp As SqlParameter = cmd1.Parameters.AddWithValue("@buyersNm", buyersGrp)
                BuyGrp.Direction = ParameterDirection.Input
            End If

            Try
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                ddlContracts.Items.Add(New ListItem("--All--", ""))
                ddlContracts.AppendDataBoundItems = True
                ddlContracts.DataSource = ds.Tables.Item(0)
                ddlContracts.DataTextField = "UPD_CNT_ID"
                ddlContracts.DataValueField = "UPD_CNT_ID"
                ddlContracts.DataBind()
            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub

    Private Sub getExpiredBuyersGroups()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString
        ddlBuyersGrp.Items.Clear()

        Using conn1 As New SqlConnection(CS)

            Dim cmd1 As SqlCommand = New SqlCommand("TRC.spTRC_GET_ERR_EXC_BUYERS", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            Try
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                ddlBuyersGrp.Items.Add(New ListItem("--All--", ""))
                ddlBuyersGrp.AppendDataBoundItems = True
                ddlBuyersGrp.DataSource = ds.Tables.Item(0)
                ddlBuyersGrp.DataTextField = "GROUP_NAME"
                ddlBuyersGrp.DataValueField = "GROUP_NAME"
                ddlBuyersGrp.DataBind()
            Finally
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try

        End Using

    End Sub

    Protected Sub ddlBuyersGrp_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlBuyersGrp.SelectedIndexChanged
        getExpiredContracts(ddlBuyersGrp.SelectedValue)
        getexp_cont()
    End Sub

    Protected Sub ddlContracts_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlContracts.SelectedIndexChanged
        getexp_cont()
    End Sub

    Protected Sub pop1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Try
            If e.CommandName = "select" Then
                Dim contractID As String = Convert.ToString(e.CommandArgument)
                Dim newRowIndex As Integer = 0
                savepop1(contractID)
                getexp_cont()
                ModalPopupExtender1.Hide()

                Session("Dist_ID_gd1") = contractID.ToString
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub pop2_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Try
            Dim contractID As String = Convert.ToString(e.CommandArgument)
            Dim newRowIndex As Integer = 0
            savepop1(contractID)
            getexp_cont()
            ModalPopupExtender1.Hide()

            Session("Dist_ID_gd1") = contractID.ToString
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub SaveAllChanges()
        Dim dtReconStat As DataTable = New DataTable()
        dtReconStat.Columns.Add("UPD_CNT_ID", GetType(String))
        dtReconStat.Columns.Add("UPD_PROD_ID", GetType(String))
        dtReconStat.Columns.Add("ReconStat", GetType(String))

        For Each row As GridViewRow In gd1.Rows
            Dim UPD_CNT_ID As String = row.Cells(0).Controls.OfType(Of Label)().FirstOrDefault().Text
            Dim UPD_PROD_ID As String = row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text
            Dim ActionVal As String = row.Cells(7).Controls.OfType(Of Label)().FirstOrDefault().Text

            Dim nrown = dtReconStat.NewRow()
            nrown.Item("UPD_CNT_ID") = UPD_CNT_ID
            nrown.Item("UPD_PROD_ID") = UPD_PROD_ID
            nrown.Item("ReconStat") = ""

            If Not String.IsNullOrEmpty(ActionVal) Then
                dtReconStat.Rows.Add(nrown)
            End If
        Next
        If dtReconStat.Rows.Count > 0 Then
            Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
            Using conn As New SqlConnection(CS)
                Using cmd As New SqlCommand("TRC.spUpdateContractReconStat", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    Dim CompanyIds As SqlParameter = New SqlParameter("@reconStat", SqlDbType.Structured) With {.TypeName = "TRC.ContractReconStat", .Value = dtReconStat}
                    CompanyIds.Direction = ParameterDirection.Input
                    Dim UserId As SqlParameter = cmd.Parameters.AddWithValue("@UserID", Session("userId").ToString)
                    UserId.Direction = ParameterDirection.Input
                    cmd.Parameters.Add(CompanyIds)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
        End If
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        SaveAllChanges()
    End Sub

    Private Sub SaveTempChanges()
        Dim ContractID = Session("exp_con").ToString()
        Dim ProdId = Session("exp_prod").ToString()
        Dim ApplyVal As Integer
        Dim ActionVal As String
        Dim ReplaceCNT As String = ""
        ActionVal = IIf(rdoReplace.Checked, "REPLACE", IIf(rdoReject.Checked, "REJECT", "PASS"))
        ApplyVal = IIf(rdoApplyToAll.Checked, 0, 1)
        If (ActionVal = "REPLACE") Then
            For Each row As GridViewRow In pop1.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                    If isChecked Then
                        ReplaceCNT = row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text
                    End If
                End If
            Next
            If (ReplaceCNT = "") Then
                For Each row As GridViewRow In pop2.Rows
                    If row.RowType = DataControlRowType.DataRow Then
                        Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
                        If isChecked Then
                            ReplaceCNT = row.Cells(2).Controls.OfType(Of Label)().FirstOrDefault().Text
                        End If
                    End If
                Next
            End If
        End If

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        Using conn As New SqlConnection(CS)
            Using cmd As New SqlCommand("TRC.spTEMP_UPDATE_CONT_EXCPTN", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@CNT_NR", ContractID)
                cmd.Parameters.AddWithValue("@prod_ID", ProdId)
                cmd.Parameters.AddWithValue("@RECON_ACTN", ActionVal)
                cmd.Parameters.AddWithValue("@REPL_CNT", ReplaceCNT)
                cmd.Parameters.AddWithValue("@Recon_Apply", ApplyVal)

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using
    End Sub

    Protected Sub btnSubmitModel_Click(sender As Object, e As EventArgs) Handles btnSubmitModel.Click
        SaveTempChanges()
        getexp_cont()
    End Sub
End Class
