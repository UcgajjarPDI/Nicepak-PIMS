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


        <div id="ImgDetails1" <%--style="display: none;"--%>>
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
                            <asp:TemplateField HeaderText="Replace with">
                                <ItemTemplate>
                                    <asp:Label ID="replace_with" runat="server" Text='<%# Eval("Replacing_With") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Erase">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgErase" runat="server" ClientIDMode="Static"
                                        ImageUrl="~/img/edit1.png" CommandName="Erase" CommandArgument='<%# Container.DataItemIndex %>'
                                        Width="20px" Height="20px" Visible='<%# IIf(Eval("Replacing_With").ToString <> "", "True", "False") %>'
                                        OnClientClick="return confirm('Are you sure you want to erase replaced contract?');"
                                        />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Reject" runat="server"
                                        GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;"
                                        Enabled='<%# IIf(Eval("Replacing_With").ToString <> "", "False", "True") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Accept">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Accept" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);"
                                        Style="text-align: center"
                                        Enabled='<%# IIf(Eval("Replacing_With").ToString <> "", "False", "True") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnShowPopUp23" runat="server" BorderWidth="0" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>'>
                                        <asp:ImageButton ID="btnShowPopUp54" runat="server" ClientIDMode="Static" ImageUrl="~/img/edit1.png" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                    </asp:LinkButton>

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>


                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
            <br />
            <div style="text-align: right;">

                <asp:Button ID="btnSubmit" runat="server" Text="Submit"
                    Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer;"
                    BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"
                    Visible="false" />
                <asp:HiddenField ID="hfHidden" runat="server" />
                <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                    PopupControlID="Panel1" DropShadow="true"
                    BackgroundCssClass="modalBackground" CancelControlID="btnCancel">
                </ajaxToolkit:ModalPopupExtender>


                <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">
                    <div id="popup">

                        <asp:UpdatePanel ID="pop1gd1" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <p style="font-family: Helvetica; color: #843C0C; font-size: 18px;">
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

                        <asp:UpdatePanel ID="UpdatePanel5" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <p style="font-family: Helvetica; color: #843C0C; font-size: 18px;">Search All</p>
                                <asp:GridView ID="pop2" EnableViewState="true" runat="server"
                                    ClientIDMode="Static" PageSize="5" AllowPaging="true"
                                    OnPageIndexChanging="pop2_PageIndexChanging"
                                    AutoGenerateColumns="false" GridLines="Horizontal"
                                    CellPadding="8" BorderStyle="None" BorderWidth="1px"
                                    Style="font-family: Helvetica; width: 90%; grid-area: auto;"
                                    OnRowCommand="pop2_RowCommand">
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
                                        <asp:TemplateField HeaderText="Tier ID">
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
                    <br />
                    <asp:Button ID="btnCancel" runat="server" ClientIDMode="Static"
                        Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer;"
                        BackColor="#843c0c" ForeColor="White" BorderColor="#843C0C" Text="Cancel" />
                </asp:Panel>


            </div>
        </div>

    </div>


</asp:Content>

