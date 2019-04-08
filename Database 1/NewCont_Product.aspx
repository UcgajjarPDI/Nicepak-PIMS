<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="NewCont_Product.aspx.vb" Inherits="Database_1.NewCont_Product" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .completionList {
            border: solid 1px #444444;
            margin: 0px;
            padding: 2px;
            height: 100px;
            overflow: auto;
            background-color: #FFFFFF;
            z-index: 9999999999 !important;
        }

        .listItem {
            color: #1C1C1C;
        }

        .itemHighlighted {
            background-color: #ffc0c0;
        }

        .autocomplete_completionListElement {
            margin: 0px !important;
            background-color: inherit;
            color: windowtext;
            border: buttonshadow;
            border-width: 1px;
            border-style: solid;
            cursor: 'default';
            overflow: auto;
            height: auto;
            text-align: left;
            list-style-type: none;
        }

        #table1 {
            font-family: Helvetica;
            color: black;
            font-size: 14px;
            text-align: left;
        }

        .divTable {
            display: table;
            width: 70%;
        }

        .divTableRow {
            display: table-row;
        }

        .divTableHeading {
            display: table-header-group;
        }

        .divTableCell, .divTableHead {
            display: table-cell;
            padding: 1px 10px;
        }

        .divTableHeading {
            display: table-header-group;
            font-weight: bold;
        }

        .divTableFoot {
            display: table-footer-group;
            font-weight: bold;
        }

        .divTableBody {
            display: table-row-group;
        }

        .Pager span {
            color: #333;
            background-color: #F7F7F7;
            font-weight: bold;
            text-align: center;
            display: inline-block;
            width: auto;
            margin-right: 1px;
            line-height: 150%;
            border: 1px solid #ccc;
            padding: 0px 1px 0px 1px;
        }

        .Pager a {
            text-align: center;
            display: inline-block;
            width: auto;
            border: 1px solid #ccc;
            color: #fff;
            color: #333;
            margin-right: 1px;
            line-height: 150%;
            text-decoration: none;
            padding: 0px 1px 0px 1px;
        }

        .highlight {
            background-color: #ffc0c0;
        }

        .auto-style1 {
            margin-bottom: 0px;
        }

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
            width: 450px;
            height: 350px;
        }


        .pop_table td {
            padding: 3px 2px 3px 2px
        }

        .productTable {
            border-bottom: medium;
            border-bottom-color: Gray;
        }

        div.blueTable {
            width: 100%;
            text-align: center;
        }
    </style>

    <script type="text/javascript">

        function ExpandCollapse() {
            var collPanel = $find("CollapsiblePanelExtender2");
            //if (collPanel.get_Collapsed())
            collPanel.set_Collapsed(false);
            //else
            //    collPanel.set_Collapsed(true);
        }
        function Collapse() {
            var collPanel = $find("CollapsiblePanelExtender2");
            collPanel.set_Collapsed(true);

        }

    </script>
    <script type="text/javascript">
        function ItemSelected(sender, args) {
            __doPostBack(sender.get_element().name, "");
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


    <div class="blueTable" style="text-align: center; width: 100%;">
        <input type="button" value="General" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; background-color: #808080; color: white;" onclick="window.location = 'New_Contract.aspx'" />
        <input id="3" type="button" value="Product" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #A40000; color: white;" onclick="window.location = 'NewCont_Product.aspx'" />
        <input id="4" type="button" value="Eligible Buyers" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Eligible_Buyers.aspx'" />
        <input id="5" type="button" value="Comm" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Comm.aspx'" />
    </div>
    <table style="width: 100%" id="table1">
        <tr>
            <td style="width: 70%; border-right: solid; border-right-color: #808080; vertical-align: top;">
                <asp:Panel ID="Panel4" runat="server" Visible="true" Enabled="true">
                    <p style="text-align: right;">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/img/Plus.PNG" Height="20px" Width="20px" />
                    </p>
                </asp:Panel>
                <asp:Panel ID="Panel2" runat="server">
                    <table style="border-bottom: solid; border-bottom-color: #808080; vertical-align: top;">
                        <tr>
                            <td>
                                <div class="divTable">
                                    <div class="divTableBody">
                                        <div class="divTableRow">
                                            <div class="divTableCell">Product ID</div>
                                            <div class="divTableCell">Product Description</div>
                                        </div>
                                        <div class="divTableRow">
                                            <div class="divTableCell">
                                                <asp:TextBox ID="TextBox1" runat="server" Width="150px" AutoPostBack="true" OnTextChanged="TextBox1_TextChanged" ClientIDMode="Static" Enabled="true" ReadOnly="false"></asp:TextBox>
                                                <ajaxToolkit:AutoCompleteExtender ServiceMethod="New_cnt_product" MinimumPrefixLength="1"
                                                    CompletionInterval="0" EnableCaching="false" CompletionSetCount="20" TargetControlID="TextBox1"
                                                    ID="AutoCompleteExtender4" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                                    CompletionListHighlightedItemCssClass="itemHighlighted"
                                                    CompletionListItemCssClass="listItem" OnClientItemSelected="ItemSelected">
                                                </ajaxToolkit:AutoCompleteExtender>
                                                <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator3"
                                                    ControlToValidate="TextBox1"
                                                    Display="Static"
                                                    ErrorMessage="Product ID is required"
                                                    runat="server"
                                                    ForeColor="Red" />--%>
                                            </div>
                                            <div class="divTableCell">
                                                <asp:TextBox ID="TextBox2" runat="server" Width="350px" ClientIDMode="Static" AutoPostBack="true" OnTextChanged="TextBox2_TextChanged"></asp:TextBox>
                                                <ajaxToolkit:AutoCompleteExtender ServiceMethod="New_cnt_prod_DETAIL" MinimumPrefixLength="1"
                                                    CompletionInterval="0" EnableCaching="false" CompletionSetCount="20" TargetControlID="TextBox2"
                                                    ID="AutoCompleteExtender1" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                                    CompletionListHighlightedItemCssClass="itemHighlighted"
                                                    CompletionListItemCssClass="listItem">
                                                </ajaxToolkit:AutoCompleteExtender>
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator4"
                                                    ControlToValidate="TextBox2"
                                                    Display="Static"
                                                    ErrorMessage="Product Description is required"
                                                    runat="server"
                                                    ForeColor="Red" />--%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="divTable1">
                                    <div class="divTableBody">
                                        <div class="divTableRow">
                                            <div class="divTableCell">Eff Date</div>
                                            <div class="divTableCell">Exp Date</div>
                                            <div class="divTableCell">Price Request</div>
                                        </div>
                                        <div class="divTableRow">
                                            <div class="divTableCell">
                                                <asp:TextBox ID="txtEffDate" runat="server" Width="150px" AutoCompleteType="Disabled" ClientIDMode="Static"></asp:TextBox>
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                                    ControlToValidate="TextBox3"
                                                    Display="Static"
                                                    ErrorMessage="Eff Date is required"
                                                    runat="server"
                                                    ForeColor="Red" />--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender1" PopupButtonID="imgPopup" TargetControlID="txtEffDate" Format="yyyy-MM-dd" runat="server" />
                                            </div>
                                            <div class="divTableCell">
                                                <asp:TextBox ID="txtExpDate" runat="server" Width="150px" AutoCompleteType="Disabled" ClientIDMode="Static"></asp:TextBox>
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                                    ControlToValidate="TextBox4"
                                                    Display="Static"
                                                    ErrorMessage="Exp Date is required"
                                                    runat="server"
                                                    ForeColor="Red" />--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" PopupButtonID="imgPopup" TargetControlID="txtExpDate" Format="yyyy-MM-dd" runat="server" />
                                            </div>
                                            <div class="divTableCell">
                                                <asp:TextBox ID="TextBox5" runat="server" Width="175px" AutoCompleteType="Disabled" ClientIDMode="Static" MaxLength="10"></asp:TextBox>
                                                <ajaxToolkit:FilteredTextBoxExtender ID="ftbe" runat="server"
                                                    TargetControlID="TextBox5"
                                                    FilterType="Custom, Numbers"
                                                    ValidChars="." />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="divTable1">
                                    <div class="divTableBody">
                                        <div class="divTableRow">
                                            <div class="divTableCell">Rationale</div>
                                            <div class="divTableCell">&nbsp;</div>

                                        </div>
                                        <div class="divTableRow">
                                            <div class="divTableCell">
                                                <asp:TextBox ID="txtRationale" runat="server" CssClass="Curved" Width="350px" Height="50px" TextMode="MultiLine" MaxLength="500" AutoCompleteType="Disabled"></asp:TextBox>

                                            </div>
                                            <div class="divTableCell" style="vertical-align: top;">

                                                <asp:Button ID="Button5" runat="server" Style="font-family: Helvetica; padding: 3px 10px 3px 10px" Text="Other Mfg." BackColor="#808080" Font-Size="Medium" ForeColor="White" BorderColor="#808080" BorderStyle="None" Width="150px" Height="25px" />

                                                <asp:Button ID="Button2" runat="server" Style="font-family: Helvetica;" Text="Submit" BackColor="#A40000" Font-Size="Medium" ForeColor="White" BorderColor="#A40000" BorderStyle="None" Width="150px" Height="25px" />
                                                <asp:HiddenField ID="hfHidden" runat="server" />
                                                <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                                                    PopupControlID="Panel3" DropShadow="true"
                                                    BackgroundCssClass="modalBackground" CancelControlID="Button1">
                                                </ajaxToolkit:ModalPopupExtender>
                                                <asp:Panel ID="Panel3" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">
                                                    <p style="text-align: center; color: #A40000;">Competition</p>
                                                    <table class="pop_table" style="width: 70%; font-family: Helvetica; color: black; font-size: 14px;">
                                                        <tr>
                                                            <td colspan="2">Manufacturer
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:TextBox ID="mf_name" runat="server" Width="346px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Product Code</td>
                                                            <td>Product Description</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="pr_code" runat="server"></asp:TextBox></td>
                                                            <td>
                                                                <asp:TextBox ID="pr_desc" runat="server"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Offered CS Price</td>
                                                            <td>Offered Price (per unit)</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="off_cs_price" runat="server"></asp:TextBox></td>
                                                            <td>
                                                                <asp:TextBox ID="off_price" runat="server"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Pack-Out</td>
                                                            <td>Total # of Wipes</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="pac_out" runat="server"></asp:TextBox></td>
                                                            <td>
                                                                <asp:TextBox ID="tot_wipes" runat="server"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <p style="text-align: right; padding-right: 25px;">
                                                                    <asp:Button ID="next" runat="server" Style="font-family: Helvetica; height: 30px;" Text="NEXT" BackColor="#A40000" Font-Size="Medium" ForeColor="White" BorderColor="#A40000" BorderStyle="None" Width="150px" />
                                                                </p>
                                                            </td>
                                                        </tr>

                                                    </table>



                                                </asp:Panel>

                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>

                    </table>
                </asp:Panel>


                <%-- <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" ClientIDMode="Static" runat="server" Collapsed="true" CollapseControlID="Panel4" ExpandControlID="Panel4" CollapsedText="ADD" ExpandedText="Hide" ImageControlID="Image1" CollapsedImage="~/img/Plus.PNG"
                            ExpandedImage="~/img/minus.PNG" ExpandDirection="Vertical" TargetControlID="Panel2" ScrollContents="false" CollapsedSize="0">--%>

                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" ClientIDMode="Static" runat="server" Collapsed="true" CollapseControlID="Panel4" ExpandControlID="Panel4" CollapsedText="ADD" ExpandedText="Hide" ImageControlID="Image1" CollapsedImage="~/img/Plus.PNG"
                    ExpandedImage="~/img/minus.PNG" ExpandDirection="Vertical" TargetControlID="Panel2" ScrollContents="false" CollapsedSize="0" />
                

                <div style="text-align: center; color: #A40000;">LIST OF PRODUCTS</div>

                <asp:GridView ID="gd1" runat="server" AutoGenerateColumns="false" GridLines="None" CellPadding="3" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Label ID="GD_CNTPDID" runat="server" Text='<%# Eval("CNT_PROD_PK") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Product ID">
                            <ItemTemplate>
                                <asp:Label ID="GD_PDID" runat="server" Text='<%# Eval("PROD_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product Description">
                            <ItemTemplate>
                                <asp:Label ID="GD_PDDESC" runat="server" Text='<%# Eval("PRODUCT_DESC") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product Price">
                            <ItemTemplate>
                                <asp:Label ID="GD_PDprc" runat="server" Text='<%# Eval("PROD_PRC") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="update1" runat="server" BorderWidth="0" CommandName="update1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Update" OnClientClick="ExpandCollapse()">
                                    <asp:ImageButton ID="img_update" runat="server" ClientIDMode="Static" ImageUrl="~/img/edit1.png" CommandName="update1" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="view1" runat="server" BorderWidth="0" CommandName="view1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="View" ClientIDMode="Static" OnClientClick="Collapse()">
                                    <asp:ImageButton ID="img_view" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.PNG" CommandName="view" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" OnClientClick="Collapse()" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>

                                <asp:LinkButton ID="delete1" runat="server" BorderWidth="0" CommandName="delete1" CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Delete" OnClientClick="Collapse()">
                                    <asp:ImageButton ID="img_delete" runat="server" ClientIDMode="Static" ImageUrl="~/img/Cancle.PNG" CommandName="delete1" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" OnClientClick="Collapse()" />

                                </asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />

                    <RowStyle Font-Names="Helvetica" HorizontalAlign="left" VerticalAlign="Middle" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

            </td>

            <td style="width: 30%; vertical-align: top;">
                <table style="border-collapse: collapse; vertical-align: top;">
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td colspan="2">Price Detail</td>
                    </tr>
                    <tr class="productTable">
                        <td colspan="2">
                            <asp:Label ID="PRODUCT_ID" runat="server" Text="" />
                            - 
                                    <asp:Label ID="PRODUCT_DESCRIPTION" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: initial; border-bottom-color: Gray;">
                        <td style="width: 80%">Current Price</td>
                        <td style="width: 20%">
                            <asp:Label ID="cur_pri" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">List Price</td>
                        <td style="width: 20%">
                            <asp:Label ID="Li_pri" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Rolling 6-Month ASP</td>
                        <td style="width: 20%">
                            <asp:Label ID="ASP6" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Rolling 12-Month ASP</td>
                        <td style="width: 20%">
                            <asp:Label ID="ASP12" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Vizient Tier 1</td>
                        <td style="width: 20%">
                            <asp:Label ID="vt1" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Vizient Tier 2</td>
                        <td style="width: 20%">
                            <asp:Label ID="vt2" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Amerient Tier 1</td>
                        <td style="width: 20%">
                            <asp:Label ID="at1" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Amerient Tier 2</td>
                        <td style="width: 20%">
                            <asp:Label ID="at2" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">HPG</td>
                        <td style="width: 20%">
                            <asp:Label ID="HPG" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Premier</td>
                        <td style="width: 20%">
                            <asp:Label ID="Pre" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">MFG 1</td>
                        <td style="width: 20%">
                            <asp:Label ID="mfg1" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">MFG 2</td>
                        <td style="width: 20%">
                            <asp:Label ID="MFG2" runat="server" Text="" /></td>
                    </tr>
                    <tr>
                        <td>&nbsp</td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Volume Detail</td>
                        <td style="width: 20%">
                            <asp:Label ID="Vol_det" runat="server" Text="" />Case</td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Buyer</td>
                        <td style="width: 20%">
                            <asp:Label ID="Buyer" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Vizient</td>
                        <td style="width: 20%">
                            <asp:Label ID="viz" runat="server" Text="" /></td>
                    </tr>
                    <tr class="productTable">
                        <td style="width: 80%">Amerinet</td>
                        <td style="width: 20%">
                            <asp:Label ID="Amer" runat="server" Text="" /></td>


                </table>

            </td>




        </tr>

    </table>


</asp:Content>
