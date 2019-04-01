<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Master_Data_Find.aspx.vb" Inherits="Database_1.MDM_Search1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        }


    </script>
    <link href="Styles/main.css" rel="stylesheet" media="screen" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>

    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>

            <div id="popup" style="width: 85%">
                <p runat="server" id="Un_label" style="font-family: Helvetica; color: red; font-size: 20px; text-align: left;">Unmatched Company</p>

                <asp:GridView ID="gd_un" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:CheckBox ID="Check_unmachted" runat="server" onclick="CheckOne(this)" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="ID">
                            <ItemTemplate>
                                <asp:Label ID="COMPANY_ID" runat="server" Text='<%# Eval("COMPANY_ID") %>'></asp:Label>
                                <asp:HiddenField ID="src_id" runat="server" Value='<%# Eval("SRC_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name_1" runat="server" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />
                                <asp:HiddenField ID="DISTACCTID" runat="server" Value='<%# Eval("DISTACCTID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="Address" runat="server" Text='<%# Eval("ADDR_1") %>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City">
                            <ItemTemplate>
                                <asp:Label ID="City" runat="server" Text='<%# Eval("CITY") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="State">
                            <ItemTemplate>
                                <asp:Label ID="State" runat="server" Text='<%# Eval("ST") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Zip">
                            <ItemTemplate>
                                <asp:Label ID="Zip" runat="server" Text='<%# Eval("ZIP") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="view1" runat="server" BorderWidth="0" CommandName="view1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" ClientIDMode="Static" OnClientClick="Collapse()">
                                    <asp:ImageButton ID="img_view" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="view" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" OnClientClick="Collapse()" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

                <p style="font-family: Helvetica; color: red; font-size: 20px; text-align: left;">Search For:</p>

                <table style="font-family: Helvetica;">
                    <tr>
                        <td>Company name</td>
                        <td>Address</td>
                        <td>City</td>
                        <td>State</td>
                        <td>Zip Code</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txt_name" runat="server" Width="250px" ClientIDMode="Static"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="getco_name" MinimumPrefixLength="2"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="txt_name"
                                ID="AutoCompleteExtender1" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>

                        </td>
                        <td>
                            <asp:TextBox ID="txt_add" runat="server" Width="250px"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="getco_add" MinimumPrefixLength="2"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="txt_add"
                                ID="AutoCompleteExtender3" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txt_city" runat="server"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="getco_city" MinimumPrefixLength="2"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="txt_city"
                                ID="AutoCompleteExtender4" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>

                        </td>
                        <td>
                            <asp:TextBox ID="txt_st" runat="server"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="getco_st" MinimumPrefixLength="1"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="txt_st"
                                ID="AutoCompleteExtender5" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="Zip_txt" runat="server" Width="142px"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="getco_zip" MinimumPrefixLength="1"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="Zip_txt"
                                ID="AutoCompleteExtender2" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <asp:Button ID="Button1" runat="server" Text="Search" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Height="25px" Width="150px" />
                        </td>

                    </tr>
                </table>
                <br />
                <asp:Label ID="ERR" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">asd</asp:Label>
                <br />



                <%-- <p style="font-family: Helvetica; color: red; font-size: 24px; text-align: left;">Search For:</p>--%>

                <asp:GridView ID="gd1" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" AutoPostBack="true" ClientIDMode="Static" onclick="CheckOne(this)" ID="chkAll" OnCheckedChanged="CheckBoxAll_CheckedChanged" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="ID">
                            <ItemTemplate>
                                <asp:Label ID="COMPANY_ID" runat="server" Text='<%# Eval("COMPANY_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name_1" runat="server" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />
                                <asp:Label ID="Name_2" runat="server" Text='<%# IIf(Eval("CMPNY_ALT_NM") & "" <> "", "A.K.A  " + Eval("CMPNY_ALT_NM"), "") %>' Visible='<%# IIf(Eval("CMPNY_ALT_NM") & "" <> "", "True", "False") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- <asp:TemplateField HeaderText="Alter Name">
            <ItemTemplate>
                <asp:Label ID="Name_2" runat="server" Text='<%# Eval("COMPANY_ALT_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="Address" runat="server" Text='<%# Eval("ADDR_1") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City">
                            <ItemTemplate>
                                <asp:Label ID="City" runat="server" Text='<%# Eval("CITY") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="State">
                            <ItemTemplate>
                                <asp:Label ID="State" runat="server" Text='<%# Eval("ST") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Zip">
                            <ItemTemplate>
                                <asp:Label ID="Zip" runat="server" Text='<%# Eval("ZIP") %>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source">
                            <ItemTemplate>
                                <asp:Label ID="Source1" runat="server" Text='<%# Eval("source") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="view1" runat="server" BorderWidth="0" CommandName="view1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" ClientIDMode="Static" OnClientClick="Collapse()">
                                    <asp:ImageButton ID="img_view" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="view" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" OnClientClick="Collapse()" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>
                <asp:GridView ID="gd2" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" AutoPostBack="true" ClientIDMode="Static" onclick="CheckOne(this)" ID="chkAll1" OnCheckedChanged="CheckBoxAll1_CheckedChanged" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="ID">
                            <ItemTemplate>
                                <asp:Label ID="COMPANY_ID" runat="server" Text='<%# Eval("COMPANY_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name_1" runat="server" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />
                                <asp:Label ID="Name_2" runat="server" Text='<%# IIf(Eval("CMPNY_ALT_NM") & "" <> "", "A.K.A  " + Eval("CMPNY_ALT_NM"), "") %>' Visible='<%# IIf(Eval("CMPNY_ALT_NM") & "" <> "", "True", "False") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- <asp:TemplateField HeaderText="Alter Name">
            <ItemTemplate>
                <asp:Label ID="Name_2" runat="server" Text='<%# Eval("COMPANY_ALT_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="Address" runat="server" Text='<%# Eval("ADDR_1") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City">
                            <ItemTemplate>
                                <asp:Label ID="City" runat="server" Text='<%# Eval("CITY") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="State">
                            <ItemTemplate>
                                <asp:Label ID="State" runat="server" Text='<%# Eval("ST") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Zip">
                            <ItemTemplate>
                                <asp:Label ID="Zip" runat="server" Text='<%# Eval("ZIP") %>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source">
                            <ItemTemplate>
                                <asp:Label ID="Source1" runat="server" Text='<%# Eval("source") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="view1" runat="server" BorderWidth="0" CommandName="view1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" ClientIDMode="Static" OnClientClick="Collapse()">
                                    <asp:ImageButton ID="img_view" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="view" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" OnClientClick="Collapse()" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>


                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

                <div style="font-family: Helvetica; color: red; font-size: 24px;">
                    <asp:Label ID="err3" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false"></asp:Label>
                    <div style="text-align: right;">
                        <asp:Button ID="Button2" Visible="false" runat="server" Text="Match" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Height="25px" Width="150px" />
                    </div>
                </div>

                <p runat="server" id="manual_label" style="font-family: Helvetica; color: red; font-size: 20px; text-align: left;">Manual Input</p>

                <table runat="server" id="manual_tabel" style="font-family: Helvetica;">
                    <tr>
                        <td>Company name</td>
                        <td>Address</td>
                        <td>City</td>
                        <td>State</td>
                        <td>Zip Code</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="TextBox1" runat="server" Width="250px" MaxLength="150"></asp:TextBox>

                        </td>
                        <td>
                            <asp:TextBox ID="TextBox2" runat="server" Width="250px" MaxLength="150"></asp:TextBox>

                        </td>
                        <td>
                            <asp:TextBox ID="TextBox3" runat="server" MaxLength="100"></asp:TextBox>

                        </td>
                        <td>
                            <asp:TextBox ID="TextBox4" runat="server" MaxLength="2"></asp:TextBox>

                        </td>
                        <td>
                            <asp:TextBox ID="TextBox5" runat="server" Width="142px" MaxLength="10"></asp:TextBox>

                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <asp:Button ID="Man_match" runat="server" Text="Match" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Height="25px" Width="150px" />
                        </td>

                    </tr>
                </table>
                <br />
                <asp:Label ID="err2" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false"></asp:Label>


                <br />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
