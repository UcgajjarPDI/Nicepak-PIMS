<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" ValidateRequest="false" EnableEventValidation="false" CodeBehind="NewCont_Eligible_Buyers.aspx.vb" Inherits="Database_1.NewCont_Eligible_Buyers" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/main.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="blueTable" style="text-align: center; width: 100%;">
        <input type="button" value="General" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; background-color: #808080; color: white;" onclick="window.location = 'New_Contract.aspx'" />
        <input id="3" type="button" value="Product" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Product.aspx'" />
        <input id="4" type="button" value="Eligible Buyers" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #A40000; color: white;" onclick="window.location = 'NewCont_Eligible_Buyers.aspx'" />
        <input id="5" type="button" value="Comm" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Comm.aspx'" />
    </div>

    <br />

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
        <tr></tr>
        <tr></tr>
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

    <asp:Label ID="ERR" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">asd</asp:Label>

    <asp:GridView
        ID="gd1"
        EnableViewState="true"
        runat="server"
        PageSize="10"
        AllowPaging="true"
        AutoGenerateColumns="false"
        GridLines="Horizontal"
        CellPadding="8"
        BorderStyle="None"
        BorderWidth="1px"
        Style="font-family: Helvetica; width: 1025px; grid-area: auto;">
        <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
        <Columns>
            <asp:TemplateField>

                <ItemTemplate>
                    <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="ID">
                <ItemTemplate>
                    <asp:Label ID="COMPANY_ID" runat="server" Text='<%# Eval("COMPANY_ID") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Name">
                <ItemTemplate>
                    <asp:Label ID="Name_1" runat="server" Text='<%# Eval("CMPNY_NM") %>'></asp:Label>
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

        </Columns>

        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
    </asp:GridView>
    <div style="text-align: right; width: 1025px;">
        <asp:Button ID="btnSubmit" runat="server" Text="Add" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Height="25px" Width="150px" />
    </div>
    <br />
    <asp:GridView
        ID="grdCurrentEB"
        EnableViewState="true"
        runat="server"
        PageSize="20"
        AllowPaging="true"
        AutoGenerateColumns="false"
        GridLines="Horizontal"
        CellPadding="8"
        BorderStyle="None"
        BorderWidth="1px"
        Caption=" <p style='background: white; color: Red;font-size: 18px; font-weight: bold;'> Current eligible Buyers </p>"
        Style="font-family: Helvetica; width: 1025px; grid-area: auto;">
        <RowStyle BackColor="White" ForeColor="DarkBlue" />
        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
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
                    <asp:Label ID="Name_1" runat="server" Text='<%# Eval("COMPANY_NM") %>'></asp:Label>
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
            <asp:TemplateField HeaderText="Sales Amount">
                <ItemTemplate>
                    <asp:Label ID="lblSalesAmount" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="delete1" runat="server" BorderWidth="0"
                        CommandName="delete1" CommandArgument='<%# Container.DataItemIndex %>'
                        ToolTip="Delete" OnClientClick="Collapse()">
                        <asp:ImageButton ID="img_delete" runat="server"
                            ClientIDMode="Static" ImageUrl="~/img/Cancle.PNG"
                            CommandName="delete1" CommandArgument='<%# Container.DataItemIndex %>'
                            Width="20px" Height="20px" OnClientClick="Collapse()" />

                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
        <RowStyle Font-Names="Helvetica" Font-Size="14px" />
        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
    </asp:GridView>

</asp:Content>
