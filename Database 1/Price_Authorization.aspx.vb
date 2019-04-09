Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Drawing
Imports System.Linq
Imports Microsoft.SqlServer.Server

Public Class Price_Authorization
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If String.IsNullOrEmpty(Session("user")) Then
            Response.Redirect("Login.aspx")
        End If

        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Price Authorization"

        Main_Menu.Text = "Contract Management"
        If Not IsPostBack Then
            GetBuyers()
            ddlGPO_SelectedIndexChanged(vbNull, New EventArgs)
        End If

    End Sub

    Private Sub GetBuyers()
        '
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGetPriceAuthBuyers", conn1)
                cmd.CommandType = CommandType.StoredProcedure

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Dim R As DataRow = ds.Tables.Item(0).NewRow
                R("gpoName") = "--Please Select--"
                ds.Tables.Item(0).Rows.InsertAt(R, 0)
                ddlGPO.DataSource = ds.Tables.Item(0)
                ddlGPO.DataTextField = "gpoName"
                ddlGPO.DataValueField = "buyerGrpId"
                ddlGPO.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using
    End Sub

    Private Sub GetPriceAuthorizationData(ByVal buyerId As Int16, Optional ByVal mfgCntNr As String = Nothing)
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGet_Price_Authorization", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim BuyerGrpId As SqlParameter = cmd.Parameters.AddWithValue("@buyerGroupId", buyerId)
                Dim MfgContractNr As SqlParameter = cmd.Parameters.AddWithValue("@mfgCntNr", IIf(IsNothing(mfgCntNr), DBNull.Value, mfgCntNr))
                BuyerGrpId.Direction = ParameterDirection.Input
                MfgContractNr.Direction = ParameterDirection.Input
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

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetContractsInfo(ByVal buyerId As Int16) As DataTable
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGetPriceAuthCntByBuyerGrpid", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim BuyerGrpId As SqlParameter = cmd.Parameters.AddWithValue("@buyerGroupId", buyerId)
                BuyerGrpId.Direction = ParameterDirection.Input

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Return ds.Tables.Item(0)

            Catch Ex As Exception
                Console.WriteLine(Ex.Message)
            End Try

        End Using
        Return New DataTable
    End Function

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetAllTiersInfo(ByVal buyerId As Int16) As DataTable
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGetTiersByBuyerGrpid", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim BuyerGrpId As SqlParameter = cmd.Parameters.AddWithValue("@buyerGroupId", buyerId)
                BuyerGrpId.Direction = ParameterDirection.Input

                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                Return ds.Tables.Item(0)

            Catch Ex As Exception
                Console.WriteLine(Ex.Message)
            End Try

        End Using
        Return New DataTable
    End Function

    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        GetPriceAuthorizationData(ddlGPO.SelectedValue,
                                  IIf(ddlContractNumber.SelectedIndex > 0, ddlContractNumber.SelectedValue, Nothing))
    End Sub

    Protected Sub ddlGPO_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlGPO.SelectedIndexChanged

        If ddlGPO.SelectedIndex > 0 Then
            Dim dt As DataTable = GetContractsInfo(ddlGPO.SelectedValue)
            Dim R As DataRow = dt.NewRow
            R("MFG_CNT_NR") = "--Please Select--"
            dt.Rows.InsertAt(R, 0)
            ddlContractNumber.DataSource = dt
            ddlContractNumber.DataTextField = "MFG_CNT_NR"
            ddlContractNumber.DataValueField = "MFG_CNT_NR"
            ddlContractNumber.DataBind()

            dt = GetAllTiersInfo(ddlGPO.SelectedValue)
            R = dt.NewRow
            R("TierId") = "--Please Select--"
            dt.Rows.InsertAt(R, 0)

            Dim tiersList = dt.Rows.Cast(Of DataRow).Select(Function(dr) dr("TierId").ToString)


            Session("ReqT") = tiersList.Distinct


        Else

            gd1.DataSource = Nothing
            gd1.DataBind()
            btnSumit.Visible = False
        End If

    End Sub

    Protected Sub btnSearch_ServerClick(sender As Object, e As EventArgs) Handles btnSearch.ServerClick
        If ddlGPO.SelectedIndex > 0 Then
            GetPriceAuthorizationData(ddlGPO.SelectedValue,
                                  IIf(ddlContractNumber.SelectedIndex > 0, ddlContractNumber.SelectedValue, Nothing))
            GetTierDetails(ddlGPO.SelectedValue)
            btnSumit.Visible = True

        End If
    End Sub

    Private Sub gd1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gd1.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then

            Dim ddlApprTier As DropDownList = CType(e.Row.FindControl("ddlApprTier"), DropDownList)
            ddlApprTier.DataSource = Session("ReqT")
            ddlApprTier.DataBind()

        End If
    End Sub

    Protected Sub btnSumit_ServerClick(sender As Object, e As EventArgs)

        Dim dtMemTier As DataTable = New DataTable("MemberTier")
        dtMemTier.Columns.Add("MemberNr", System.Type.GetType("System.String"))
        dtMemTier.Columns.Add("TierNr", System.Type.GetType("System.String"))

        For Each row As GridViewRow In gd1.Rows
            Dim ddlApprTier As DropDownList = CType(row.FindControl("ddlApprTier"), DropDownList)
            If ddlApprTier.SelectedIndex <> 0 Then
                Dim lblGPOMember As Label = CType(row.FindControl("GPO_MBR_ID"), Label)
                Dim nrown = dtMemTier.NewRow()
                Dim cntrNrSplt = ddlApprTier.SelectedValue.Split("-")
                nrown.Item("MemberNr") = lblGPOMember.Text

                nrown.Item("TierNr") = cntrNrSplt(0).Trim
                dtMemTier.Rows.Add(nrown)
            End If
        Next

        Dim CS As String = ConfigurationManager.ConnectionStrings("Con1").ConnectionString
        Using conn As New SqlConnection(CS)
            Using cmd As New SqlCommand("CNT.spUpdateBuyersGroupTiers", conn)
                cmd.CommandType = CommandType.StoredProcedure
                Dim CompanyIds As SqlParameter = New SqlParameter("@buyers", SqlDbType.Structured) With {.TypeName = "dbo.MemberTiers", .Value = dtMemTier}
                CompanyIds.Direction = ParameterDirection.Input
                cmd.Parameters.Add(CompanyIds)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

    End Sub

    Protected Sub ddlApprTier_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddlApprTier As DropDownList = sender
        Dim Row As GridViewRow = ddlApprTier.Parent.Parent
        Dim idx As Integer = Row.RowIndex
        If ddlApprTier.SelectedIndex <> 0 Then
            gd1.Rows.Item(idx).BackColor = Color.Red
        Else
            gd1.Rows.Item(idx).BackColor = IIf(idx Mod 2 = 0, Color.White, ColorTranslator.FromHtml("#E7E7E7"))
        End If

    End Sub

    Private Sub GetTierDetails(ByVal buyerId As Int16)
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGetTiersByBuyerGrpid", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim BuyerGrpId As SqlParameter = cmd.Parameters.AddWithValue("@buyerGroupId", buyerId)
                BuyerGrpId.Direction = ParameterDirection.Input
                conn1.Open()

                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                grdTierDesc.DataSource = ds
                grdTierDesc.DataBind()

            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
End Class
