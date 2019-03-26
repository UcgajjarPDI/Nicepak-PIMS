Imports System.Data.SqlClient
Imports System
Imports System.Collections.Generic
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Data
Imports System.Web.Services
Imports System.Configuration
Imports System.Drawing

Public Class MDM_Search1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Lbl_name.Text = Session("fi_na").ToString
        'lbl_add1.Text = Session("fi_a1").ToString
        'lbl_add2.Text = Session("fi_a2").ToString
        'lbl_city.Text = Session("fi_ci").ToString
        'lbl_st.Text = Session("fi_st").ToString
        'lbl_zip.Text = Session("fi_zip").ToString

        ERR.Visible = False
        err2.Visible = False
        err3.Visible = False

        'Button2.Visible = False

        If Not IsPostBack Then
            ' Button2.Visible = False
            gd_un_show()
        End If


    End Sub
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_name(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_NM]from CMPNY.company where [CMPNY_NM] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_name_other(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_ALT_NM] from [CMPNY].[COMPANY] where [CMPNY_ALT_NM] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_add(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select [CMPNY_ADDR_1] from [CMPNY].[COMPANY] where [CMPNY_ADDR_1] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function
    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_city(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_CITY] from [CMPNY].[COMPANY] where [CMPNY_CITY] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_st(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_ST] from [CMPNY].[COMPANY] where [CMPNY_ST] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    <System.Web.Script.Services.ScriptMethod()>
    <System.Web.Services.WebMethod>
    Public Shared Function getco_zip(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Con2").ToString())
        con.Open()
        Dim cmd As SqlCommand = New SqlCommand("select distinct [CMPNY_ZIP] from [CMPNY].[COMPANY] where [CMPNY_ZIP] like @Name +'%'", con)
        cmd.Parameters.AddWithValue("@Name", prefixText)
        Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
        Dim dt As DataTable = New DataTable()
        da.Fill(dt)
        Dim CountryNames As List(Of String) = New List(Of String)

        For i As Integer = 0 To dt.Rows.Count - 1
            CountryNames.Add(dt.Rows(i)(0).ToString())
            If i >= 10 Then
                Exit For
            End If
        Next

        Return CountryNames
    End Function

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        gd1.Visible = False


        If String.IsNullOrEmpty(txt_name.Text) And String.IsNullOrEmpty(txt_add.Text.ToString) Then

            ERR.Visible = True
            ERR.Text = "At least name or alternate name or street address is needed to run a search"

        Else
            gd1.Visible = True
            gd1_show()
            gd2_show()
            Button2.Visible = True
            'gd_un_show()
        End If

    End Sub
    Public Sub gd1_show()

        gd1.DataSourceID = Nothing
        gd1.EditIndex = -1
        gd1.DataBind()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim x As String = String.Empty

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[CMPNY].[spSRCH_CMPNY]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            'define parameter -- the parameter name have to exactly how it is in the store dprocedure




            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_NM", txt_name.Text)
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ZIP ", Zip_txt.Text)
            Dim Param5 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ADDR ", txt_add.Text)
            Dim Param6 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_CITY ", txt_city.Text)
            Dim Param7 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ST ", txt_st.Text)


            'Dim output As SqlParameter = cmd1.Parameters.Add("@Msg", SqlDbType.VarChar, 200)
            'output.Direction = ParameterDirection.Output


            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Param5.Direction = ParameterDirection.Input
            Param6.Direction = ParameterDirection.Input
            Param7.Direction = ParameterDirection.Input

            Try
                'open connection
                conn1.Open()
                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)


                Dim ds As DataSet = New DataSet


                adapter.Fill(ds)







                gd1.DataSource = ds
                gd1.DataBind()
                ' Button2.Visible = True




            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    Public Sub gd2_show()

        gd1.DataSourceID = Nothing
        gd1.EditIndex = -1
        gd1.DataBind()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim x As String = String.Empty

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("[CMPNY].[spSRCH_CMS_CMPNY]", conn1)
            cmd1.CommandType = CommandType.StoredProcedure

            'define parameter -- the parameter name have to exactly how it is in the store dprocedure




            Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_NM", txt_name.Text)
            Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ZIP ", Zip_txt.Text)
            Dim Param5 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ADDR ", txt_add.Text)
            Dim Param6 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_CITY ", txt_city.Text)
            Dim Param7 As SqlParameter = cmd1.Parameters.AddWithValue("@CO_ST ", txt_st.Text)


            'Dim output As SqlParameter = cmd1.Parameters.Add("@Msg", SqlDbType.VarChar, 200)
            'output.Direction = ParameterDirection.Output


            Param3.Direction = ParameterDirection.Input
            Param4.Direction = ParameterDirection.Input
            Param5.Direction = ParameterDirection.Input
            Param6.Direction = ParameterDirection.Input
            Param7.Direction = ParameterDirection.Input

            Try
                'open connection
                conn1.Open()
                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)


                Dim ds As DataSet = New DataSet


                adapter.Fill(ds)







                gd2.DataSource = ds
                gd2.DataBind()
                ' Button2.Visible = True




            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub
    'Protected Sub btnShowPopUp54_Click(sender As Object, e As ImageClickEventArgs) Handles btnShowPopUp54.Click
    '    Response.Redirect("Master_Data_Find.aspx")
    'End Sub

    'Protected Sub btnShowPopUp23_Click(sender As Object, e As EventArgs) Handles btnShowPopUp23.Click
    '    Response.Redirect("Master_Data_Find.aspx")
    'End Sub



    Private Sub gd1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd1.PageIndexChanging
        gd1.PageIndex = e.NewPageIndex
        gd1_show()
        gd1.DataBind()

    End Sub





    Public Sub gd_un_show()

        gd_un.DataSourceID = Nothing
        gd_un.EditIndex = -1
        gd_un.DataBind()
        Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

        'SQL Conection
        Using conn1 As New SqlConnection(CS)
            Dim x As String = String.Empty

            'SQL Command - the name have to exactly the same as in SQL server database in Exec command
            Dim cmd1 As SqlCommand = New SqlCommand("select top 1000 TRC_ENDUSER_1_ID as COMPANY_ID , T.DISTCOID AS SRC_ID,
                                                        DISTID SOURCE_NM, DISTACCTID , DISTACCTSHIPNAME as CMPNY_NM, 
                                                        DISTACCTSHIPADDR1 as ADDR_1, DISTACCTSHIPCITY AS CITY, DISTACCTSHIPSTATE AS ST,
                                                        DISTACCTSHIPZIP AS ZIP ,
                                                        convert(varchar,cast(SALES_SUM as money),1) AS SALES_AMT,'YES' as  PDI_CUSTOMER
                                                        FROM STAGE.TRC_ENDUSER_3K T
                                                        LEFT JOIN MDM_STAGE.CMPNY_MATCH_XREF C ON T.TRC_ENDUSER_1_ID = C.SRC_DATA_ID 
                                                        WHERE
                                                        T.COMPANY_ID is NULL
                                                        AND C.SRC_DATA_ID IS NULL
                                                        ORDER BY SALES_SUM DESC", conn1)
            'cmd1.CommandType = CommandType.StoredProcedure
            'define parameter -- the parameter name have to exactly how it is in the store dprocedure






            'Dim output As SqlParameter = cmd1.Parameters.Add("@Msg", SqlDbType.VarChar, 200)
            'output.Direction = ParameterDirection.Output



            Try
                'open connection
                conn1.Open()
                'read the data
                Dim adapter As SqlDataAdapter = New SqlDataAdapter(cmd1)

                Dim ds As DataSet = New DataSet
                adapter.Fill(ds)







                gd_un.DataSource = ds
                gd_un.DataBind()


            Finally
                'close the connection
                If (Not conn1 Is Nothing) Then
                    conn1.Close()
                End If
            End Try


        End Using

    End Sub

    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        err3.Visible = False
        Dim srcids As String
        Dim distaccids As String
        Dim company_ids As Int64
        Dim sources As String
        Dim cmnpny_ids As Int64


        For Each row As GridViewRow In gd_un.Rows
            Dim isSelected As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isSelected Then
                srcids = row.Cells(1).Controls.OfType(Of HiddenField)().FirstOrDefault().Value
                distaccids = row.Cells(2).Controls.OfType(Of HiddenField)().FirstOrDefault().Value
                company_ids = Convert.ToInt64(row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)


            End If

        Next
        If srcids Is Nothing Then
            err3.Visible = True
            err3.Text = "Please Select Unmatched Record"
        End If
        For Each row As GridViewRow In gd1.Rows
            Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isChecked Then
                sources = row.Cells(7).Controls.OfType(Of Label)().FirstOrDefault().Text
                cmnpny_ids = Convert.ToInt64(row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)

                'Else
                '    err3.Visible = True
                '    err3.Text = "Please Checked Searched Record"
            End If

        Next
        For Each row As GridViewRow In gd2.Rows
            Dim isChecked As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isChecked Then
                sources = row.Cells(7).Controls.OfType(Of Label)().FirstOrDefault().Text
                cmnpny_ids = Convert.ToInt64(row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)

                'Else
                '    err3.Visible = True
                '    err3.Text = "Please Checked Searched Record"
            End If

        Next
        If sources Is Nothing Then
            err3.Visible = True
            err3.Text = "Please Select Searched Record"
        End If
        If err3.Visible = False Then
            Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

            'SQL Conection
            Using conn1 As New SqlConnection(CS)
                Dim cmd1 As SqlCommand = New SqlCommand("INSERT INTO [MDM_STAGE].[CMPNY_MATCH_XREF]
                                                           (
                                                           [SRC_ID]
                                                           ,[SRC_ACCT_ID]
                                                           ,[SRC_DATA_ID]
                                                           ,[MTCH_To_TYPE]
                                                           ,[MTCH_To_ID]
                                                           )
                                                        values(@src,@dist,@com,@sour,@cmp)", conn1)

                Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@src", srcids)
                Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@dist ", distaccids)
                Dim Param5 As SqlParameter = cmd1.Parameters.AddWithValue("@com ", company_ids)
                Dim Param6 As SqlParameter = cmd1.Parameters.AddWithValue("@sour ", sources)
                Dim Param7 As SqlParameter = cmd1.Parameters.AddWithValue("@cmp ", cmnpny_ids)
                Param3.Direction = ParameterDirection.Input
                Param4.Direction = ParameterDirection.Input
                Param5.Direction = ParameterDirection.Input
                Param6.Direction = ParameterDirection.Input
                Param7.Direction = ParameterDirection.Input

                Try
                    conn1.Open()
                    cmd1.ExecuteNonQuery()


                Finally
                    'close the connection
                    If (Not conn1 Is Nothing) Then
                        conn1.Close()
                    End If

                End Try

            End Using
            Response.Redirect(Request.RawUrl)

        End If
    End Sub

    Protected Sub Man_match_Click(sender As Object, e As EventArgs) Handles Man_match.Click
        Dim srcids As String
        Dim distaccids As String
        Dim company_ids As Int64
        For Each row As GridViewRow In gd_un.Rows
            Dim isSelected As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isSelected Then
                srcids = row.Cells(1).Controls.OfType(Of HiddenField)().FirstOrDefault().Value
                distaccids = row.Cells(2).Controls.OfType(Of HiddenField)().FirstOrDefault().Value
                company_ids = Convert.ToInt64(row.Cells(1).Controls.OfType(Of Label)().FirstOrDefault().Text)


            End If

        Next

        If srcids Is Nothing Then
            err2.Visible = True
            err2.Text = "Please Checked Unmatched Record"
        End If
        If err2.Visible = False Then
            Dim CS As String = ConfigurationManager.ConnectionStrings("Con2").ConnectionString

            'SQL Conection
            Using conn1 As New SqlConnection(CS)
                Dim cmd1 As SqlCommand = New SqlCommand("INSERT INTO [MDM_STAGE].[CMPNY_MATCH_XREF]
                                                           (
                                                           [SRC_ID]
                                                           ,[SRC_ACCT_ID]
                                                           ,[SRC_DATA_ID]
                                                           ,[MTCH_To_CMPNY_NM]
                                                           ,[MTCH_To_CMPNY_ADDR_1]
                                                           ,[MTCH_To_CMPNY_CITY]
                                                           ,[MTCH_To_CMPNY_STATE]
                                                           ,[MTCH_To_CMPNY_ZIP]
                                                           )
                                                        values(@src,@dist,@com,@nm,@add1,@city,@st,@zip)", conn1)
                Dim Param3 As SqlParameter = cmd1.Parameters.AddWithValue("@src", srcids)
                Dim Param4 As SqlParameter = cmd1.Parameters.AddWithValue("@dist ", distaccids)
                Dim Param5 As SqlParameter = cmd1.Parameters.AddWithValue("@com ", company_ids)
                Dim Param6 As SqlParameter = cmd1.Parameters.AddWithValue("@nm ", TextBox1.Text)
                Dim Param7 As SqlParameter = cmd1.Parameters.AddWithValue("@add1 ", TextBox2.Text)
                Dim Param8 As SqlParameter = cmd1.Parameters.AddWithValue("@city ", TextBox3.Text)
                Dim Param9 As SqlParameter = cmd1.Parameters.AddWithValue("@st ", TextBox4.Text)
                Dim Param10 As SqlParameter = cmd1.Parameters.AddWithValue("@zip ", TextBox5.Text)
                Param3.Direction = ParameterDirection.Input
                Param4.Direction = ParameterDirection.Input
                Param5.Direction = ParameterDirection.Input
                Param6.Direction = ParameterDirection.Input
                Param7.Direction = ParameterDirection.Input
                Param8.Direction = ParameterDirection.Input
                Param9.Direction = ParameterDirection.Input
                Param10.Direction = ParameterDirection.Input
                Try
                    conn1.Open()
                    cmd1.ExecuteNonQuery()


                Finally
                    'close the connection
                    If (Not conn1 Is Nothing) Then
                        conn1.Close()
                    End If

                End Try

            End Using

            Response.Redirect(Request.RawUrl)
        End If

    End Sub

    Protected Sub CheckBoxAll_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' Dim chk As CheckBox = CType(gd1.Rows.FindControl("chkAll"), CheckBox)
        For Each row As GridViewRow In gd1.Rows

            Dim isSelected As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isSelected Then
                '    row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked = False
                For Each row1 As GridViewRow In gd2.Rows
                    row1.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked = False
                Next
            End If
        Next

    End Sub

    Protected Sub CheckBoxAll1_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' Dim chk As CheckBox = CType(gd1.Rows.FindControl("chkAll"), CheckBox)
        For Each row As GridViewRow In gd2.Rows

            Dim isSelected As Boolean = row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked
            If isSelected Then
                '    row.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked = False
                For Each row1 As GridViewRow In gd1.Rows
                    row1.Cells(0).Controls.OfType(Of CheckBox)().FirstOrDefault().Checked = False
                Next
            End If
        Next

    End Sub
    Protected Sub gd1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd1.SelectedIndexChanged

    End Sub

    Protected Sub gd_un_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gd_un.SelectedIndexChanged


    End Sub

    Private Sub gd_un_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd_un.PageIndexChanging
        gd_un.PageIndex = e.NewPageIndex

        gd_un_show()
        gd_un.DataBind()
    End Sub

    Private Sub gd2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gd2.PageIndexChanging
        gd2.PageIndex = e.NewPageIndex
        gd2_show()
        gd2.DataBind()

        gd1_show()

    End Sub
End Class