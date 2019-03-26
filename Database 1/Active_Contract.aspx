<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Active_Contract.aspx.vb" Inherits="Database_1.Active_Contract" %>

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


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>

            <div style="text-align: left">
                <div>
                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px; text-align: left;">Expiring in 30 Days</p>

                    <asp:GridView ID="gd1" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" DataKeyNames="CNT_NR" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
                        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                        <Columns>
                            <asp:TemplateField>

                                <ItemTemplate>
                                    <asp:CheckBox ID="ckpop1" runat="server" AutoPostBack="true" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract #">
                                <ItemTemplate>
                                    <asp:Label ID="co" runat="server" Text='<%# Eval("CNT_NR") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Buyer Group">
                                <ItemTemplate>
                                    <asp:Label ID="BY_GR" runat="server" Text='<%# Eval("GRP_SHRT_NM") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract Type">
                                <ItemTemplate>
                                    <asp:Label ID="CO_TY" runat="server" Text='<%# Eval("CNT_TYP_CD") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tier Number">
                                <ItemTemplate>
                                    <asp:Label ID="TI_NO" runat="server" Text='<%# Eval("CNT_TIER_LVL") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Effective Date">
                                <ItemTemplate>
                                    <asp:Label ID="EF_DT" runat="server" Text='<%# Eval("CNT_EFF_DT") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Expiration Date">
                                <ItemTemplate>
                                    <asp:Label ID="EX_DT3" runat="server" Text='<%# Eval("CNT_EXP_DT") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>


                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" Width="500PX" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>
                    <asp:Label ID="visible1" runat="server" Visible="false"></asp:Label>

                    <br />
                    <br />


                </div>

                <div>
                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px; text-align: left;">Other Contracts</p>
                    <%--  <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;  color:#843C0C;font-size:24px;text-align:left;">Expiring in 60 Days</p> --%>

                    <asp:GridView ID="gd2" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" DataKeyNames="CNT_NR" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
                        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                        <Columns>
                            <asp:TemplateField>

                                <ItemTemplate>
                                    &nbsp;&nbsp;<asp:CheckBox ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" AutoPostBack="true" />
                                    <%--<asp:RadioButton ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract #">
                                <ItemTemplate>
                                    <asp:Label ID="co" runat="server" Text='<%# Eval("CNT_NR") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Buyer Group">
                                <ItemTemplate>
                                    <asp:Label ID="BY_GR" runat="server" Text='<%# Eval("GRP_SHRT_NM") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract Type">
                                <ItemTemplate>
                                    <asp:Label ID="CO_TY" runat="server" Text='<%# Eval("CNT_TYP_CD") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tier Number">
                                <ItemTemplate>
                                    <asp:Label ID="TI_NO" runat="server" Text='<%# Eval("CNT_TIER_LVL") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Effective Date">
                                <ItemTemplate>
                                    <asp:Label ID="EF_DT" runat="server" Text='<%# Eval("CNT_EFF_DT") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Expiration Date">
                                <ItemTemplate>
                                    <asp:Label ID="EX_DT3" runat="server" Text='<%# Eval("CNT_EXP_DT") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>


                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" Width="500PX" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>


                    <br />
                    <br />
                    <asp:Label ID="visible2" runat="server" Visible="false"></asp:Label>


                </div>
                <div style="text-align: right">






                    <asp:Button ID="Button3" runat="server" Text="Update" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                    &nbsp&nbsp&nbsp&nbsp&nbsp
            &nbsp&nbsp&nbsp&nbsp&nbsp
          <asp:Button ID="Button1" runat="server" Text="Create Alike" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
