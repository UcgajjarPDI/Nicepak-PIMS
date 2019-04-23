<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="SearchContract.aspx.vb" Inherits="Database_1.SearchContract" EnableEventValidation="false" ViewStateEncryptionMode="Never" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function closeWin() {
            window.close();
        }
    </script>
    <style>
        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 950px;
            height: 700px;
            font-family: Helvetica;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
        </asp:ScriptManager>
        <div style="width: 100%;">
            <asp:Button ID="btnLoad" runat="server" ClientIDMode="Static"
                BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C"
                BorderStyle="None" Width="150px" Height="25px" Text="Load" OnClick="btnLoad_Click" />

            <br />
            <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server"
                CssClass="modalPopup" align="center" Style="font-family: Helvetica; border: none" ScrollBars="Auto">
                <div id="popup">

                    <asp:UpdatePanel ID="pop1gd1" runat="server" style="text-align: left">
                        <ContentTemplate>
                            <p class="pTitleStyles">
                                Contract for 
                                    <asp:Label ID="Lb1" runat="server" Text="Label"></asp:Label>
                                with Item
                                    <asp:Label ID="Lb2" runat="server" Text="Label"></asp:Label>
                            </p>

                            <asp:GridView ID="pop1" EnableViewState="true" runat="server" ClientIDMode="Static"
                                AutoGenerateColumns="false" GridLines="Horizontal" OnRowCommand="pop1_RowCommand"
                                CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 90%; grid-area: auto;">
                                <RowStyle BackColor="White" ForeColor="DarkBlue" />
                                <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                <Columns>
                                    <asp:TemplateField HeaderText="Group Name">
                                        <ItemTemplate>
                                            <asp:Label ID="dis" runat="server" Text='<%# Eval("GROUP_NAME") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Contract ID">
                                        <ItemTemplate>
                                            <asp:Label ID="pr_id" runat="server" Text='<%# Eval("CONTRACT_NO") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exp Date">
                                        <ItemTemplate>
                                            <asp:Label ID="bu_gp" runat="server" Text='<%# Eval("EXP_DT") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tier ID">
                                        <ItemTemplate >
                                            <asp:Label ID="ti_le" runat="server" Text='<%#  Eval("TIER_LEVEL") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkSelectContr" runat="server" CommandName="select" CommandArgument='<%# Eval("CONTRACT_NO") %>'>Select</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>

                                <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                    <asp:UpdatePanel ID="UpdatePanel5" runat="server" style="text-align: left">
                        <ContentTemplate>

                            <p class="pTitleStyles">Seacrh All</p>
                            <asp:GridView ID="pop2" EnableViewState="true" runat="server"
                                ClientIDMode="Static" PageSize="5" AllowPaging="true"
                                OnPageIndexChanging="pop2_PageIndexChanging"
                                AutoGenerateColumns="false" GridLines="Horizontal"
                                CellPadding="8" BorderStyle="None" BorderWidth="1px"
                                Style="font-family: Helvetica; width: 90%; grid-area: auto;"
                                OnRowCommand="pop2_RowCommand">
                                <RowStyle BackColor="White" ForeColor="DarkBlue" />
                                <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                <Columns>

                                    <asp:TemplateField HeaderText="Group Name">
                                        <ItemTemplate>
                                            <asp:Label ID="dis" runat="server" Text='<%# Eval("GROUP_NAME") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Contract ID">
                                        <ItemTemplate>
                                            <asp:Label ID="pr_id" runat="server" Text='<%# Eval("CONTRACT_NO") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exp Date">
                                        <ItemTemplate>
                                            <asp:Label ID="bu_gp" runat="server" Text='<%#  Eval("EXP_DT") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tier ID" >
                                        <ItemTemplate>
                                            <asp:Label ID="ti_le" runat="server" Text='<%#  Eval("TIER_LEVEL") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkSelectContr" runat="server" CommandName="select" CommandArgument='<%# Eval("CONTRACT_NO") %>'>Select</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>

                                <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />

                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>

            </asp:Panel>
        </div>
    </form>
</body>
</html>


