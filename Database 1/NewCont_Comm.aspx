<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="NewCont_Comm.aspx.vb" Inherits="Database_1.NewCont_Comm" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #table1 {
            font-family: Trebuchet MS, Arial, Helvetica, sans-serif;
            color: black;
            font-size: 18px;
            text-align: left;
        }

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
            padding-left: 13px;
            width: 375px;
            height: 375px;
            font-family: Trebuchet MS, Arial, Helvetica, sans-serif;
        }

        #_ParentDiv {
            border-color: white;
        }

        div.blueTable {
            border: 1px solid #636063;
            width: 100%;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function ItemSelected(sender, args) {
            __doPostBack(sender.get_element().name, "");
        }
        function ShowModalPopup() {
            $find("mpe").show();
            return false;
        }
        function HideModalPopup() {
            $find("mpe").hide();
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div style="text-align: center; width: 100%;">
                <input type="button" value="General" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; background-color: #808080; color: white;" onclick="window.location = 'New_Contract.aspx'" />
                <input id="3" type="button" value="Product" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Product.aspx'" />
                <input id="4" type="button" value="Eligible Buyers" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" onclick="window.location = 'NewCont_Eligible_Buyers.aspx'" />
                <input id="5" type="button" value="Comm" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #A40000; color: white;" onclick="window.location = 'NewCont_Comm.aspx'" />
            </div>
            <table style="width: 100%" id="table1">
                <tr>
                    <td style="width: 70%; border-right: solid; border-right-color: #808080; vertical-align: top; padding-right: 5px;">
                        <div style="text-align: right;">
                            <asp:Button ID="feedback" runat="server" Text="Post Comment/Questions" BorderStyle="None" BackColor="white" Style="text-decoration: underline; cursor: pointer; color: #A40000;" />
                        </div>
                        <asp:HiddenField ID="hfHidden" runat="server" />
                        <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="HiddenField2"
                            PopupControlID="Panel1" DropShadow="true" BehaviorID="mpe"
                            BackgroundCssClass="modalBackground" CancelControlID="HiddenField1">
                        </ajaxToolkit:ModalPopupExtender>

                        <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Trebuchet MS, Arial, Helvetica, sans-serif;" ScrollBars="Auto">

                            <div>
                                <div style="text-align: left;">
                                    <asp:Label ID="Label1" runat="server" Text="Label" ForeColor="#A40000"></asp:Label>&nbsp;&nbsp;<asp:Label ID="Label3" runat="server" Text="Label" ForeColor="#A40000" Font-Size="Smaller" Visible="false"></asp:Label><br />
                                    <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label><br />
                                    <br />
                                    <asp:TextBox ID="user_input" runat="server" Text="" Width="550px" Height="200PX" maximunsize="350px" autosize="true" Style="width: 350px;" TextMode="MultiLine"></asp:TextBox><br />
                                    <table style="width: 100%">
                                        <tr>
                                            <td>Response Needed
                                            </td>
                                            <td>From
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="DropDownList1" runat="server" Width="170px">

                                                    <asp:ListItem Text="---Please Select---" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                                    <asp:ListItem Text="NO" Value="N"></asp:ListItem>


                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="userID" runat="server" Width="170px"></asp:TextBox>
                                                <ajaxToolkit:AutoCompleteExtender ServiceMethod="find_user" MinimumPrefixLength="1"
                                                    CompletionInterval="0" EnableCaching="false" CompletionSetCount="20" TargetControlID="userID"
                                                    ID="AutoCompleteExtender1" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                                    CompletionListHighlightedItemCssClass="itemHighlighted"
                                                    CompletionListItemCssClass="listItem" OnClientItemSelected="ItemSelected">
                                                </ajaxToolkit:AutoCompleteExtender>
                                            </td>
                                        </tr>

                                    </table>
                                    <br />

                                </div>
                                <div style="text-align: right; padding-right: 18px">
                                    <asp:Button ID="Button2" runat="server" Text="Cancel" Style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080; color: white;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Button1" runat="server" Text="Save" Style="width: 100px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #A40000; color: white;" />



                                </div>
                            </div>
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                            <asp:HiddenField ID="HiddenField2" runat="server" />

                        </asp:Panel>

                        <asp:GridView ID="gd2" Width="100%" runat="server" AllowPaging="true" PageSize="5" AutoGenerateColumns="false" GridLines="None" CellPadding="0" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; word-wrap: break-word; table-layout: fixed;"
                            OnRowDataBound="gd2_RowDataBound">
                            <Columns>

                                <asp:TemplateField>
                                    <ItemTemplate>

                                        <table style="width: 100%">

                                            <tr>
                                                <td>Post # 1 -
                                            <asp:Label ID="us1_name" runat="server" Text='<%# Eval("USR_FULL_NM") %>' />

                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:Label ID="us1_date" runat="server" Text='<%# Eval("COMM_DTTS") %>' />

                                                    <asp:HiddenField ID="US1_COMM_id" runat="server" Value='<%# Eval("COMM_ID") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:TextBox ID="re1_comm" runat="server" Text='<%# Eval("COMM") %>' Width="80%" autosize="true" Style="border: 0px" TextMode="MultiLine" Rows="2" ReadOnly="true"><br /></asp:TextBox>

                                                    <br />
                                                    <div style="text-align: right">
                                                        <asp:Button ID="Re_us_1" runat="server" Text="Respond" BorderStyle="None" BackColor="white" Style="text-decoration: underline; cursor: pointer; color: #A40000;" CommandName="Trace_main" CommandArgument='<%# Container.DataItemIndex %>' />
                                                    </div>

                                                </td>
                                            </tr>
                                        </table>

                                        <asp:GridView ID="gd3" Width="100%" runat="server" AutoGenerateColumns="false" GridLines="None" CellPadding="0" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; word-wrap: break-word; table-layout: fixed;">
                                            <Columns>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <table style="width: 100%">
                                                            <tr>
                                                                <td>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Response by
                                            <asp:Label ID="res1_user" runat="server" Text='<%# Eval("RESP_USER_ID") %>'></asp:Label>,
                                            <asp:Label ID="res1_date" runat="server" Text='<%# Eval("RESP_DTTS") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:TextBox ID="re1_comm" runat="server" Text='<%# Eval("RESP") %>' Width="80%" autosize="true" Style="border: 0px" TextMode="MultiLine" Rows="2" ReadOnly="true"><br /></asp:TextBox>
                                                                </td>
                                                            </tr>

                                                        </table>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                                        </asp:GridView>

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        </asp:GridView>

                    </td>
                    <td style="width: 30%; vertical-align: top; padding-left: 5px;">
                        <div>
                            Product ID Search:<br />
                            <asp:TextBox ID="TextBox1" runat="server" Width="150px" AutoPostBack="true" OnTextChanged="TextBox1_TextChanged" ClientIDMode="Static" Enabled="true" ReadOnly="false"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="New_cnt_product" MinimumPrefixLength="1"
                                CompletionInterval="0" EnableCaching="false" CompletionSetCount="20" TargetControlID="TextBox1"
                                ID="AutoCompleteExtender4" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem" OnClientItemSelected="ItemSelected">
                            </ajaxToolkit:AutoCompleteExtender>
                        </div>

                        <asp:GridView ID="gd1" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="1" GridLines="None" CellPadding="0" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <table style="border-collapse: collapse; vertical-align: top;">
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td colspan="2">Price Detail</td>

                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td colspan="2">
                                                    <asp:Label ID="PRODUCT_ID" runat="server" Text='<%# Eval("PROD_ID") %>' />
                                                    - 
                                    <asp:Label ID="PRODUCT_DESCRIPTION" runat="server" Text='<%# Eval("PRODUCT_DESC") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Current Price</td>
                                                <td style="width: 20%">$<asp:Label ID="cur_pri" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">List Price</td>
                                                <td style="width: 20%">$<asp:Label ID="Li_pri" runat="server" Text='<%# Eval("LIST_PRICE") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Rolling 6-Month ASP</td>
                                                <td style="width: 20%">$<asp:Label ID="ASP6" runat="server" Text='<%# Eval("ASP6") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Rolling 12-Month ASP</td>
                                                <td style="width: 20%">$<asp:Label ID="ASP12" runat="server" Text='<%# Eval("ASP12") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Vizient Tier 1</td>
                                                <td style="width: 20%">$<asp:Label ID="vt1" runat="server" Text='<%# Eval("VIZ_TIER_1") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Vizient Tier 2</td>
                                                <td style="width: 20%">$<asp:Label ID="vt2" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Amerient Tier 1</td>
                                                <td style="width: 20%">$<asp:Label ID="at1" runat="server" Text='<%# Eval("AMERI_TIER_1") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Amerient Tier 2</td>
                                                <td style="width: 20%">$<asp:Label ID="at2" runat="server" Text='<%# Eval("AMERI_TIER_2") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">HPG</td>
                                                <td style="width: 20%">$<asp:Label ID="HPG" runat="server" Text='<%# Eval("HPG_PRC") %>' /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Premier</td>
                                                <td style="width: 20%">$<asp:Label ID="Pre" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">MFG 1</td>
                                                <td style="width: 20%">$<asp:Label ID="mfg1" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">MFG 2</td>
                                                <td style="width: 20%">$<asp:Label ID="MFG2" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray; border-top: solid; border-top-color: Gray;">
                                                <td style="width: 80%">Volume Detail</td>
                                                <td style="width: 20%">(<asp:Label ID="Vol_det" runat="server" Text='<%# Eval("CURR_VOL") %>' />cs)</td>

                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Buyer</td>
                                                <td style="width: 20%">
                                                    <asp:Label ID="Buyer" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Vizient</td>
                                                <td style="width: 20%">
                                                    <asp:Label ID="viz" runat="server" Text="" /></td>
                                            </tr>
                                            <tr style="border-bottom: solid; border-bottom-color: Gray;">
                                                <td style="width: 80%">Amerinet</td>
                                                <td style="width: 20%">
                                                    <asp:Label ID="Amer" runat="server" Text="" /></td>


                                        </table>

                                        </td>




        </tr>

    </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>No Product Found</EmptyDataTemplate>
                            <PagerSettings Mode="NextPreviousFirstLast"
                                FirstPageText="First"
                                LastPageText="Last"
                                NextPageText="Next"
                                PreviousPageText="Prev"
                                Position="Top" />
                            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        </asp:GridView>

                    </td>
                </tr>

            </table>

        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: center;">
        <asp:Button ID="btnfinalize" runat="server" Text="Approve" BorderStyle="None" BackColor="white" Style="text-decoration: underline; cursor: pointer; color: #A40000; font-size: 18px" />
    </div>
</asp:Content>
