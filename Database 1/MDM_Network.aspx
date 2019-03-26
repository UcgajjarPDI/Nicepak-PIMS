<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="MDM_Network.aspx.vb" Inherits="Database_1.MDM_Network" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <%-- <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/img/Back.PNG"   Width="50px" ToolTip="Back To MDM Search"/><br />--%>
    <table class="ui-accordion">
        <tr>
            <td style="width: 70%; vertical-align: top;">
                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">Company</p>
                <asp:GridView ID="gd_company" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <%--<asp:Label ID="Address" runat="server" Text='<%# Eval("CMPNY_ADDR_1") %>+'","'+<%# Eval("CMPNY_CITY") %>+'","'+<%# Eval("CMPNY_ST") %>+'"-"'+<%# Eval("CMPNY_ZIP ") %>'></asp:Label>--%>
                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">IDN</p>
                <asp:GridView ID="gd_IDN" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">


                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <%--<asp:Label ID="Address" runat="server" Text='<%# Eval("CMPNY_ADDR_1") %>+'","'+<%# Eval("CMPNY_CITY") %>+'","'+<%# Eval("CMPNY_ST") %>+'"-"'+<%# Eval("CMPNY_ZIP ") %>'></asp:Label>--%>
                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%--<asp:TemplateField  HeaderText="Relation">
            <ItemTemplate>
                <asp:Label ID="Zip" runat="server" Text='<%# Eval("relation") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>   --%>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>


                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">Org. Parent</p>
                <asp:GridView ID="gd_parent" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">


                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <%--<asp:Label ID="Address" runat="server" Text='<%# Eval("CMPNY_ADDR_1") %>+'","'+<%# Eval("CMPNY_CITY") %>+'","'+<%# Eval("CMPNY_ST") %>+'"-"'+<%# Eval("CMPNY_ZIP ") %>'></asp:Label>--%>
                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- <asp:TemplateField  HeaderText="Relation">
            <ItemTemplate>
                <asp:Label ID="Zip" runat="server" Text='<%# Eval("relation") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>   --%>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>
                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">Subsidiaries</p>
                <asp:GridView ID="gd_child" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">


                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>

                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- <asp:TemplateField  HeaderText="Relation">
            <ItemTemplate>
                <asp:Label ID="Zip" runat="server" Text='<%# Eval("relation") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>  --%>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>
                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">In Network</p>
                <asp:GridView ID="gd_network" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">


                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <%--<asp:Label ID="Address" runat="server" Text='<%# Eval("CMPNY_ADDR_1") %>+'","'+<%# Eval("CMPNY_CITY") %>+'","'+<%# Eval("CMPNY_ST") %>+'"-"'+<%# Eval("CMPNY_ZIP ") %>'></asp:Label>--%>
                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- <asp:TemplateField  HeaderText="Relation">
            <ItemTemplate>
                <asp:Label ID="Zip" runat="server" Text='<%# Eval("relation") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>    --%>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>


                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 20px; text-align: left;">Affiliation</p>
                <asp:GridView ID="gd_aff" EmptyDataText="No records Found" EnableViewState="true" runat="server" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">


                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:HiddenField ID="CMPNY_ID" runat="Server" Value='<%# Eval("CMPNY_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Width="200px" Text='<%# Eval("CMPNY_NM") %>'></asp:Label><br />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>

                                <asp:Label ID="Address" runat="server" Width="200px" Text='<%#String.Concat(Eval("CMPNY_ADDR_1"), ", ", Eval("CMPNY_CITY"), ", ", Eval("CMPNY_ST"), "-", Eval("CMPNY_ZIP ")) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label ID="indicator" runat="server" Text='<%# Eval("PDI_CUSTOMER") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="12 Month Sales">
                            <ItemTemplate>
                                <asp:Label ID="sales" runat="server" Text='<%# Eval("SALES_AMT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="search" runat="server" BorderWidth="0" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Sales Details">
                                    <asp:ImageButton ID="search1" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="search" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- <asp:TemplateField  HeaderText="Relation">
            <ItemTemplate>
                <asp:Label ID="Zip" runat="server" Text='<%# Eval("relation") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>   --%>
                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>
            </td>
            <td style="width: 30%; vertical-align: top; padding-left: 5px">
                <div style="text-align: right">
                    <input type="button" value="Back" style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #A40000;" onclick="window.location = 'MDM_Search.aspx'" />
                </div>
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
    <br />
    <br />
</asp:Content>
