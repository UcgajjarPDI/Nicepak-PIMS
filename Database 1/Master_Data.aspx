<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Master_Data.aspx.vb" Inherits="Database_1.Master_Data" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"> </script>

    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.1/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript"> 

        function CheckOne(obj) {
            var grid = obj.parentNode.parentNode.parentNode;
            var inputs = grid.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type == "checkbox") {
                    if (obj.checked && inputs[i] != obj && inputs[i].checked) {
                        inputs[i].checked = false;
                    }
                }
            }
            function CompareConfirm() {
                var str1 = "abc";
                var str2 = "def";

                if (str1 === str2) {
                    // your logic here
                    return false;
                } else {
                    // your logic here
                    return confirm("Confirm?");
                }
            }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <table style="width: 100%;">
                <tr>
                    <td>
                        <div style="text-align: right">
                            <input type="button" value="Verify" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; background-color: #A40000; color: WHITE;" onclick="window.location = 'Master_Data.aspx'" />
                            <input id="3" type="button" value="Find Match" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: #FFFFFF; background-color: #808080;" onclick="window.location = 'Master_Data_Find.aspx';" />
                            <input id="4" type="button" value="MDM Search" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080;" onclick="window.location = 'MDM_Search.aspx'" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table style="width=40%;">
                            <tr>
                                <td>
                                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Territory:&nbsp
                                        <asp:DropDownList ID="drop_ter" runat="server" AutoPostBack="true" Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" Font-Size="20px" ForeColor="#843C0C"></asp:DropDownList>&nbsp </p>
                                </td>
                                <td>
                                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">
                                        Filter:
                  <asp:DropDownList ID="drp_Filter" runat="server" Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" Font-Size="20px" ForeColor="#843C0C">
                      <asp:ListItem Text="--Select--" Value="" Selected="true"></asp:ListItem>
                      <asp:ListItem Text="Matched" Value="Correct"></asp:ListItem>
                      <asp:ListItem Text="Corrected" Value="Corrected"></asp:ListItem>
                      <asp:ListItem Text="Suggested" Value="Auto suggest"></asp:ListItem>

                  </asp:DropDownList>
                                    </p>
                                </td>
                                <td>
                                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; font-size: 24px;">
                                        <asp:Button ID="btn_drop" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="100px" Height="26px" /></p>
                                </td>
                    </td>
                </tr>
            </table>
            </tr>
            <tr>
                <td>
                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 24px;">
                        <asp:Label ID="Lbl_Error" runat="server" EnableViewState="false"></asp:Label>
                    </p>
                </td>
            </tr>
            <tr>
                <td>

                    <asp:GridView ID="gd1" runat="server" AutoGenerateColumns="false" PageSize="10" AllowPaging="true" GridLines="Horizontal" CellPadding="5" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
                        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                        <Columns>
                            <asp:TemplateField>

                                <ItemTemplate>
                                    <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID">
                                <ItemTemplate>
                                    <asp:Label ID="In_ID" runat="server" Text='<%# Eval("USER_FEEDBK_CO_ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Incoming">
                                <ItemTemplate>
                                    <asp:Label ID="Inco_Name" runat="server" Text='<%# Eval("COACCTSHIPNAME_Source") %>'></asp:Label><br />
                                    <asp:Label ID="Inco_ADD1" runat="server" Text='<%# Eval("COACCTSHIPADDR1_Source") %>'></asp:Label>&nbsp;<asp:Label ID="Inco_ADD2" runat="server" Text='<%# Eval("COACCTSHIPADDR2_Source") %>'></asp:Label><br />
                                    <asp:Label ID="Inco_City" runat="server" Text='<%# Eval("COACCTSHIPCITY_Source") %>'></asp:Label>&nbsp;<asp:Label ID="Inco_St" runat="server" Text='<%# Eval("COACCTSHIPSTATE_Source") %>'></asp:Label>&nbsp;<asp:Label ID="Inco_Zip" runat="server" Text='<%# Eval("COACCTSHIPZIP_Source") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="" ControlStyle-BorderStyle="None" ControlStyle-BackColor="White" HeaderStyle-BackColor="White" HeaderStyle-BorderStyle="none" HeaderStyle-BorderColor="White" ItemStyle-BorderColor="White">
                                <ItemTemplate>
                                    &nbsp;&nbsp;
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Matched with">
                                <ItemTemplate>
                                    <asp:Label ID="Mat_Name" runat="server" Text='<%# Eval("COACCTSHIPNAME_Output") %>'></asp:Label><br />
                                    <asp:Label ID="Mat_ADD1" runat="server" Text='<%# Eval("COACCTSHIPADDR1_Output") %>'></asp:Label>&nbsp;<asp:Label ID="Mat_ADD2" runat="server" Text='<%# Eval("COACCTSHIPADDR2_Output") %>'></asp:Label><br />
                                    <asp:Label ID="Mat_City" runat="server" Text='<%# Eval("COACCTSHIPCITY_Output") %>'></asp:Label>&nbsp;<asp:Label ID="Mat_St" runat="server" Text='<%# Eval("COACCTSHIPSTATE_Output") %>'></asp:Label>&nbsp;<asp:Label ID="Mat_Zip" runat="server" Text='<%# Eval("COACCTSHIPZIP_Output") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Accept">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Accept" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="text-align: center" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;" />
                                </ItemTemplate>
                            </asp:TemplateField>



                        </Columns>


                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />


                    </asp:GridView>
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <div style="text-align: right;">
                        <asp:Button ID="Btn_Gd1_Save" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" Visible="false" OnClientClick="return confirm('Please confirm');" />
                    </div>
                </td>
            </tr>
            </table>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
