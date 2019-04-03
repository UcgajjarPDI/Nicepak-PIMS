Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Web.Script.Services

Public Class Price_Authorization
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

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

    Private Sub GetPriceAuthorizationData(ByVal buyerId As Int16, Optional ByVal mfgCntNr As String = Nothing, Optional ByVal cntTierLvl As String = Nothing)
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGet_Price_Authorization", conn1)
                cmd.CommandType = CommandType.StoredProcedure
                Dim BuyerGrpId As SqlParameter = cmd.Parameters.AddWithValue("@buyerGroupId", buyerId)
                Dim MfgContractNr As SqlParameter = cmd.Parameters.AddWithValue("@mfgCntNr", IIf(IsNothing(mfgCntNr), DBNull.Value, mfgCntNr))
                Dim TierLvl As SqlParameter = cmd.Parameters.AddWithValue("@cntTierLvl", IIf(IsNothing(cntTierLvl), DBNull.Value, cntTierLvl))
                BuyerGrpId.Direction = ParameterDirection.Input
                MfgContractNr.Direction = ParameterDirection.Input
                TierLvl.Direction = ParameterDirection.Input
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
    Public Shared Function GetTiersInfo(ByVal buyerId As Int16) As DataTable
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Try

                Dim cmd As SqlCommand = New SqlCommand("CNT.spGetPriceAuthTiersByBuyerGrpid", conn1)
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
                                  IIf(ddlContractNumber.SelectedIndex > 0, ddlContractNumber.SelectedValue, Nothing),
                                  IIf(ddlTierLevel.SelectedIndex > 0, ddlTierLevel.SelectedValue, Nothing))
    End Sub

    Protected Sub ddlGPO_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlGPO.SelectedIndexChanged

        If ddlGPO.SelectedIndex >= 0 Then
            Dim dt As DataTable = GetContractsInfo(ddlGPO.SelectedValue)
            Dim R As DataRow = dt.NewRow
            R("MFG_CNT_NR") = "--Please Select--"
            dt.Rows.InsertAt(R, 0)
            ddlContractNumber.DataSource = dt
            ddlContractNumber.DataTextField = "MFG_CNT_NR"
            ddlContractNumber.DataValueField = "MFG_CNT_NR"
            ddlContractNumber.DataBind()

            dt = GetTiersInfo(ddlGPO.SelectedValue)
            R = dt.NewRow
            R("CNT_TIER_LVL") = "--Please Select--"
            dt.Rows.InsertAt(R, 0)
            ddlTierLevel.DataSource = dt
            ddlTierLevel.DataTextField = "CNT_TIER_LVL"
            ddlTierLevel.DataValueField = "CNT_TIER_LVL"
            ddlTierLevel.DataBind()
        End If

    End Sub

    Protected Sub btnSearch_ServerClick(sender As Object, e As EventArgs) Handles btnSearch.ServerClick
        GetPriceAuthorizationData(ddlGPO.SelectedValue,
                                  IIf(ddlContractNumber.SelectedIndex > 0, ddlContractNumber.SelectedValue, Nothing),
                                  IIf(ddlTierLevel.SelectedIndex > 0, ddlTierLevel.SelectedValue, Nothing))
    End Sub
End Class