<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ExpiredContract.aspx.vb" Inherits="Database_1.ExpiredContract" EnableEventValidation="false" ViewStateEncryptionMode="Never" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"> </script>

    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.1/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript">

        function OpenWin(id) {
            window.open('Control/SearchContract.aspx' + id, 'MoreBikeInfo', 'height=600,width=500,top=50,left=50,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=yes,status=no');
            return false;
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
            width: 900px;
            height: 600px;
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
                        Sales Period:&nbsp  
                            <asp:DropDownList ID="ddlSalesPeriod" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C">
                            </asp:DropDownList>
                    </p>
                </td>
                <td>
                    <div id="buyersGrpDiv">
                        <p class="pTitleStyles">
                            Buyers Group:&nbsp  
                            <asp:DropDownList ID="ddlBuyersGrp" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C">
                            </asp:DropDownList>
                        </p>
                    </div>
                </td>
                <td>
                    <div id="contractsDiv">
                        <p class="pTitleStyles">
                            Contracts:&nbsp  
                            <asp:DropDownList ID="ddlContracts" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C">
                            </asp:DropDownList>
                        </p>
                    </div>
                </td>
            </tr>
        </table>


        <div id="ImgDetails1" <%--style="display: none;"--%>>
            <asp:UpdatePanel ID="up1" runat="server">
                <ContentTemplate>

                    <asp:GridView ID="gd1" EnableViewState="true" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
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
                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Accept">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Accept" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="text-align: center" />
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
                        <RowStyle Font-Names="Helvetica" Font-Size="14px" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
            <br />
            <div style="text-align: right;">
                <asp:Button ID="Button5" runat="server" Text="Submit"
                    Style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer;"
                    BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" />
                <asp:HiddenField ID="hfHidden" runat="server" />
                <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                    PopupControlID="pnlContract" DropShadow="true"
                    BackgroundCssClass="modalBackground" CancelControlID="Button1">
                </ajaxToolkit:ModalPopupExtender>
                <asp:Panel ID="pnlContract" runat="server" CssClass="Popup" align="center" Style="display: none; background-color: white; height: 800px; width: 900px; border: none">
                    <p style="text-align: right;">
                        <asp:ImageButton ID="Button1" runat="server" Height="15px" Width="15px" BorderStyle="None" ImageUrl="~/img/Cancle.Png" />
                    </p>
                    <iframe style="width: 900px; height: 800px; border: none" id="irm1" src="../Control/SearchContract.aspx" runat="server"></iframe>
                </asp:Panel>

            </div>
        </div>

    </div>
</asp:Content>

