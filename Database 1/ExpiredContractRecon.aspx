<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ExpiredContractRecon.aspx.vb" Inherits="Database_1.ExpiredContractRecon" EnableEventValidation="false" ViewStateEncryptionMode="Never" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"> </script>

    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.1/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>

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
            width: 800px;
            height: 800px;
            font-family: Helvetica;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <div style="width: 100%;">
        <table>
            <tr>
                <td>
                    <p class="pTitleStyles">
                        Buyers Group:&nbsp  
                            <asp:DropDownList ID="ddlBuyersGrp" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C">
                            </asp:DropDownList>
                    </p>
                </td>
                <td>
                    <p class="pTitleStyles">
                        Contracts:&nbsp  
                            <asp:DropDownList ID="ddlContracts" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C" Width="150px">
                            </asp:DropDownList>
                    </p>
                </td>
            </tr>
        </table>

        <asp:UpdatePanel ID="up1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gd1" EnableViewState="true" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                    <Columns>
                        <asp:TemplateField HeaderText="Contract ID">
                            <ItemTemplate>
                                <asp:Label ID="dis" runat="server" Text='<%# Eval("UPD_CNT_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product ID">
                            <ItemTemplate>
                                <asp:Label ID="pr_id" runat="server" Text='<%# Eval("UPD_PROD_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Buyer Group">
                            <ItemTemplate>
                                <asp:Label ID="bu_gp" runat="server" Text='<%# Eval("GROUP_NAME") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expired Date">
                            <ItemTemplate>
                                <asp:Label ID="exp_dt" runat="server" Text='<%# Eval("cnt_exp_DT") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Days expired by">
                            <ItemTemplate>
                                <asp:Label ID="day_exp_by" runat="server" Text='<%# Eval("exp_days") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Updated CNT #" ItemStyle-Width="50px">
                            <ItemTemplate>
                                <asp:Label ID="replace_with" runat="server" Text='<%# Eval("Replacing_With") %>'></asp:Label>
                                &nbsp;&nbsp;
                                    <asp:ImageButton ID="imgErase" runat="server" ClientIDMode="Static"
                                        ImageUrl="~/img/Eraser.png" CommandName="Erase" CommandArgument='<%# Container.DataItemIndex %>'
                                        Width="20px" Height="20px" Visible='<%# IIf(Eval("Replacing_With").ToString <> "", "True", "False") %>'
                                        OnClientClick="return confirm('Are you sure you want to erase replaced contract?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="30px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnShowPopUp23" runat="server" BorderWidth="0" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>'>
                                    <asp:ImageButton ID="btnShowPopUp54" runat="server" ClientIDMode="Static" ImageUrl="~/img/Search.png" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Label ID="action" runat="server" Text='<%# Eval("ACTION") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
        <br />
        <div>
            <asp:Button ID="btnSubmit" runat="server" Text="Submit"
                Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer;"
                BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"
                Visible="false" OnClick="btnSubmit_Click" />
            <asp:HiddenField ID="hfHidden" runat="server" />
            <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                PopupControlID="Panel1" DropShadow="true"
                BackgroundCssClass="modalBackground" CancelControlID="btnCancel">
            </ajaxToolkit:ModalPopupExtender>

            <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="left" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">

                <div runat="server" style="width: 100%; float: left;">
                    <p style="font-family: Helvetica; color: #843C0C; font-size: 18px; float: left;">
                        Replacement for Contract #:  
                                    <asp:Label ID="lblCnt" runat="server"></asp:Label>
                        Product #:
                                    <asp:Label ID="lblProd" runat="server"></asp:Label>
                    </p>
                </div>

                <div runat="server" style="width: 100%; float: left; ">
                    <b>Action:</b>
                    &nbsp;&nbsp;<asp:RadioButton ID="rdoReplace" GroupName="Action" runat="server" Text="Replace" />
                    &nbsp;&nbsp;<asp:RadioButton ID="rdoReject" GroupName="Action" runat="server" Text="Reject" />
                    &nbsp;&nbsp;<asp:RadioButton ID="rdoPass" GroupName="Action" runat="server" Text="Pass" />
                </div>
                <div>&nbsp;&nbsp;</div>
                <div style="width: 100%; float: left;">
                    <b>Apply:</b>
                    &nbsp;&nbsp;<asp:RadioButton ID="rdoApplyToThis" GroupName="Apply" runat="server" Text="Apply to this product only" />
                    &nbsp;&nbsp;
                        <asp:RadioButton ID="rdoApplyToAll" GroupName="Apply" runat="server" Text="Apply to all product for this contract" />
                </div>
                <div>&nbsp;&nbsp;</div>
                <div runat="server" style="width: 100%; float: left;">
                    <asp:UpdatePanel ID="pop1gd1" runat="server" style="text-align: left">
                        <ContentTemplate>

                            <asp:GridView ID="pop1" EnableViewState="true" runat="server" ClientIDMode="Static"
                                AutoGenerateColumns="false" GridLines="Horizontal" OnRowCommand="pop1_RowCommand"
                                CellPadding="6" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 90%; grid-area: auto;">

                                <RowStyle BackColor="White" ForeColor="DarkBlue" />
                                <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                <Columns>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkFirst" runat="server" onclick="CheckOne(this)" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Group Name">
                                        <ItemTemplate>
                                            <asp:Label ID="dis" runat="server" Text='<%# Eval("GROUP_NAME") %>' Width="300px"></asp:Label>
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
                                        <ItemTemplate>
                                            <asp:Label ID="ti_le" runat="server" Text='<%#  Eval("TIER_LEVEL") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>

                                <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />

                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:UpdatePanel ID="UpdatePanel5" runat="server" style="text-align: left">
                        <ContentTemplate>
                            <p style="font-family: Helvetica; color: #843C0C; font-size: 18px;">Search All</p>
                            <asp:GridView ID="pop2" EnableViewState="true" runat="server"
                                ClientIDMode="Static" PageSize="5" AllowPaging="true"
                                OnPageIndexChanging="pop2_PageIndexChanging"
                                AutoGenerateColumns="false" GridLines="Horizontal"
                                CellPadding="6" BorderStyle="None" BorderWidth="1px"
                                Style="font-family: Helvetica; width: 90%; grid-area: auto;"
                                OnRowCommand="pop2_RowCommand">
                                <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                <Columns>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSecond" runat="server" onclick="CheckOne(this)" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Group Name">
                                        <ItemTemplate>
                                            <asp:Label ID="dis" runat="server" Text='<%# Eval("GROUP_NAME") %>' Width="300px"></asp:Label>
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
                                    <asp:TemplateField HeaderText="Tier ID">
                                        <ItemTemplate>
                                            <asp:Label ID="ti_le" runat="server" Text='<%#  Eval("TIER_LEVEL") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div>&nbsp;&nbsp;</div>
                <div style="width: 80%;float:left">
                    <asp:Button ID="btnCancel" runat="server" ClientIDMode="Static"
                        Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; float:right;padding-right:10px "
                        BackColor="#843c0c" ForeColor="White" BorderColor="#843C0C" Text="Cancel" />
                  
                    <asp:Button ID="btnSubmitModel" runat="server" ClientIDMode="Static"
                        Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; float:right"
                        BackColor="#843c0c" ForeColor="White" BorderColor="#843C0C" Text="Submit"
                        OnClick="btnSubmitModel_Click" />
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

