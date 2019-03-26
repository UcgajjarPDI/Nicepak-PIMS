<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="MDM_Search.aspx.vb" Inherits="Database_1.MDM_Search" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/main.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <table style="width: 100%;">
        <tr>
            <td>
                <div style="text-align: right">
                    <input type="button" value="Verify" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #A40000;" onclick="window.location = 'Master_Data.aspx'" />
                    <input id="3" type="button" value="Find Match" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #A40000;" onclick="window.location = 'Master_Data_Find.aspx'" />
                    <input id="4" type="button" value="MDM Search" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080;" onclick="window.location = 'MDM_Search.aspx'" />
                </div>
            </td>
        </tr>
    </table>

    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 24px; text-align: left;">Match for:</p>
    <br />
    <table style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">
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
    <asp:Label ID="ERR" runat="server" Style="background-color: #A40000; border: none; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: white; font: bold;" Visible="false">asd</asp:Label>
    <br />

    <br />

    <br />
    <table style="width: 100%;">
        <tr>
            <td style="width: 70%; vertical-align: top;">

                <asp:GridView ID="gd1" EnableViewState="true" runat="server" PageSize="10" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">

                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:Image ID="img_eb" runat="server" Visible='<%# IIf(Eval("BI").Equals("Y"), "True", "False") %>'
                                    ClientIDMode="Static" ImageUrl="~/img/buyer_icon.PNG"
                                    Width="20px" Height="20px" />

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

                        <asp:TemplateField HeaderText="Sales Amt.">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="serch" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="network" runat="server" BorderWidth="0" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Network Details">
                                    <asp:ImageButton ID="network1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Network.PNG" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>


                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>


                <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>

            </td>
            <td style="width: 30%; vertical-align: top;">
                <br />
                <br />
                <table style="border-collapse: collapse; vertical-align: top;">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="sales_details" runat="server" Text="Sales Details" BackColor="#A40000" ForeColor="White" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="comapany_name" runat="server" Text="Company Name" />
                    </tr>
                    <tr>
                        <td style="width: 80%">Sani-Surface</td>
                        <td style="width: 20%">$<asp:Label ID="lblSani" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Prevantics</td>
                        <td style="width: 20%">$<asp:Label ID="lblPrevantics" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Baby-Wipes</td>
                        <td style="width: 20%">$<asp:Label ID="lblBabyWipes" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Other</td>
                        <td style="width: 20%">$<asp:Label ID="lblOthers" runat="server" Text="" /></td>
                    </tr>

                    <tr>
                        <td style="width: 80%">Specialty</td>
                        <td style="width: 20%">$<asp:Label ID="lblSpecial" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Sani Hands</td>
                        <td style="width: 20%">$<asp:Label ID="lblSaniHands" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Iodine</td>
                        <td style="width: 20%">$<asp:Label ID="lblIodine" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Hygea</td>
                        <td style="width: 20%">$<asp:Label ID="lblHygea" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Adult Wipes</td>
                        <td style="width: 20%">$<asp:Label ID="lblAdultWipes" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Compliance Accessories</td>
                        <td style="width: 20%">$<asp:Label ID="lblCompAcc" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 80%">Total</td>
                        <td style="width: 20%">$<asp:Label ID="lblTotal" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
