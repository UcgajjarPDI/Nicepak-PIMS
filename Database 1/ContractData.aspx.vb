Imports System.Data.SqlClient

Public Class WebForm1
    Inherits Page

    Public Property GridView1 As Object

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            'Fetch Contract data
            GetContractData()


            GetItemsData()
            ac_it.Visible = True


        End If

    End Sub

    ''' <summary>
    ''' testing retreiving data from sql server using stored procedure
    ''' </summary>
    ''' 
    Private Sub GetItemsData()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("SELECT CNT_NR, G.GRP_SHRT_NM, INIT_USR_NM, CNT_INIT_DT, convert(varchar,CNT_RVW_DL_DT,101) as CNT_RVW_DL_DT,'Post Feedback' as CNT_TYP_CD, CNT_STAT_CD, PDI_GROUP_ID FROM PCM.PCM_CONT_PND C JOIN PCM.PCM_GROUP G ON C.PDI_GROUP_ID = G.PDI_GRP_ID", conn1)
            cmd1.CommandType = CommandType.Text
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure


            Try
                'open connection
                conn1.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                gd2.DataSource = ds
                gd2.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    Private Sub GetContractData()
        'Connection String
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn As New SqlConnection(CS)

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd As SqlCommand = New SqlCommand("[PCM].[spPCM_Get_Contract]", conn)
            cmd.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure
            Dim Param1 As SqlParameter = cmd.Parameters.AddWithValue("@UNM", Session("user").ToString)
            Param1.Direction = ParameterDirection.Input




            Try
                'open connection
                conn.Open()

                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)

                'bind the data
                'CntRepeater.DataSource = ds
                ' CntRepeater.DataBind()
                'GridView1.DataSource = ds
                ' GridView1.DataBind()

                gd1.DataSource = ds
                gd1.DataBind()


                ' msgLabel.Text = " Total Record found -" & Param1.Value


            Finally
                'close the connection
                If (Not conn Is Nothing) Then
                    conn.Close()
                End If
            End Try
        End Using
    End Sub





    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click


        Dim Selected As String = ""

        For Each gr As GridViewRow In gd1.Rows
            Dim cb As CheckBox = CType(gr.FindControl("chkCheck"), CheckBox)
            Dim lblName As Label = CType(gr.FindControl("co"), Label)

            If cb IsNot Nothing AndAlso cb.Checked Then
                Dim StdID As String = gd1.DataKeys(gr.DataItemIndex).Values("CNT_NR").ToString()
                Selected = lblName.Text.Trim()
            End If
        Next
        'Label1.Text = Selected
        Session("CNT") = Selected.ToString()
        Response.Redirect("~/Create_Alike.aspx", False)



    End Sub

    Protected Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Protected Sub gd2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd2.SelectedIndexChanged

    End Sub
End Class