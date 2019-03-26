Imports System.Data.SqlClient
Public Class WebForm4
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            'Fetch Contract data
            GetRequestData()
        End If

    End Sub

    Private Sub GetRequestData()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[PCM].[spPCM_Prod_Pricing]", conn)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim Param As SqlParameter = cmd.Parameters.AddWithValue("@CNT_NR", Session("CNT").ToString)
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@UNM", Session("user").ToString)

            cmd.Parameters.Add("@Initiator", SqlDbType.VarChar, 50)
            cmd.Parameters("@Initiator").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@Org_Role", SqlDbType.VarChar, 50)
            cmd.Parameters("@Org_Role").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@Region", SqlDbType.VarChar, 50)
            cmd.Parameters("@Region").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@RD", SqlDbType.VarChar, 50)
            cmd.Parameters("@RD").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@BG_NM", SqlDbType.VarChar, 150)
            cmd.Parameters("@BG_NM").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@BG_Addr", SqlDbType.VarChar, 150)
            cmd.Parameters("@BG_Addr").Direction = ParameterDirection.Output

            cmd.Parameters.Add("@BG_CITY_ST", SqlDbType.VarChar, 150)
            cmd.Parameters("@BG_CITY_ST").Direction = ParameterDirection.Output

            Param1.Direction = ParameterDirection.Input
            Param.Direction = ParameterDirection.Input
            Try
                'open connection
                conn.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
                If ds.Tables(0).Rows.Count > 0 Then
                    Initiator.Text = cmd.Parameters("@Initiator").Value.ToString()
                    Org_Role.Text = cmd.Parameters("@Org_Role").Value.ToString
                    Region.Text = cmd.Parameters("@Region").Value.ToString()
                    RD.Text = cmd.Parameters("@RD").Value.ToString()
                    BG_NM.Text = cmd.Parameters("@BG_NM").Value.ToString()
                    BG_ADDR1.Text = cmd.Parameters("@BG_Addr").Value.ToString()
                    BG_CITY_ST_ZIP.Text = cmd.Parameters("@BG_CITY_ST").Value.ToString()

                    gd1.DataSource = ds
                    gd1.DataBind()

                End If

            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using

    End Sub
    Private Sub SubmitRequestData()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[PCM].[spSubmit_Request]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim Param2 As SqlParameter = cmd1.Parameters.AddWithValue("@CNT_NR", Session("CNT").ToString)
            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@UNM", Session("user").ToString)
            Param2.Direction = ParameterDirection.Input
            Param3.Direction = ParameterDirection.Input
            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)
            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try
        End Using

    End Sub
    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        SubmitRequestData()
        Response.Redirect("~/ContractData.aspx", False)

    End Sub

End Class