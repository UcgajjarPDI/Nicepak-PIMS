Imports System.Data.SqlClient

Public Class Tier_Complance
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim Page_name As Label = Master.FindControl("Page_name")
        Dim Main_Menu As Label = Master.FindControl("Main_Menu")
        Page_name.Text = "Tier Complance"
        Main_Menu.Text = "Contract Management"

        GetTIER_COMP_Data()

    End Sub

    Private Sub GetTIER_COMP_Data()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("select P.MFG_CNT_NR , GPO_NM, GPO_MBR_ID, 
                    A.COACCTSHIPNAME, A.COACCTSHIPADDR1, A.COACCTSHIPCITY, A.COACCTSHIPSTATE, A.COACCTSHIPZIP,
                    C.CNT_TIER_LVL, C.CNT_DESC AS TIER_DESC, A.SALES_AMT_CURR AS SALE, FORMAT(TRY_CONVERT(money,A.NTWRK_AMT_CURR),'C','en-US') as NETWORK_SALE
                    FROM STage.PRC_AUTH1 P
                    JOIN dbo.GPO_XREF X ON P.GPO_NM = X.[GPO Name] AND P.GPO_MBR_ID = X.[Facility Number]
                    JOIN CONT.CONTRACT C ON P.MFG_CNT_NR = C.CNT_NR 
                    JOIN STAGE.PRC_AUTH_TEST17 A ON X.PDI_UserID = A.COACCTID
                    ", conn1)
            cmd1.CommandType = CommandType.Text
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure


            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

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
        GetTIER_COMP_Data()
    End Sub
End Class