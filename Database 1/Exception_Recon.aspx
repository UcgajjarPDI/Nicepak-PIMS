﻿<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Exception_Recon.aspx.vb" Inherits="Database_1.Exception_Recon" EnableEventValidation="false" ViewStateEncryptionMode="Never" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"> </script>

    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.1/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>

    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript">
        $(function () {
            $('input:button.my-button').click(function () {
                var id = this.id;
                var inp = document.getElementById(this.id);
                var currentDiv = $('div[id=ImgDetails' + id + ']');
                var curDiv = document.getElementById('ImgDetails' + id);
                $('div[id*=ImgDetails]').hide();
                currentDiv.show();
                if (id == "1")
                {
                    $('div[id=buyersGrpDiv]').show();
                    $('div[id=contractsDiv]').show();
                }
                else
                {
                    $('div[id=buyersGrpDiv]').hide();
                    $('div[id=contractsDiv]').hide();
                }
                //if (curDiv.style.display === "none") {
                //    inp.style.backgroundColor = "#A40000";
                //} else {
                //    inp.style.backgroundColor = "#808080";
                //}
              
            });

        });

        function setColor(e) {
            console.log('The time is: ' + e.target.id);
            $( ".my-button" ).css( "backgroundColor", "#808080" );
            var inp = document.getElementById(e.target.id);
            inp.style.backgroundColor = "#A40000";
        }

    </script>
    <style>
        INPUT {
            padding: 0;
            border: none;
            font: inherit;
            color: inherit;
            background-color: transparent;
            cursor: pointer;
            font-family: Helvetica;
        }


        .my-button {
            display: inline-block;
            text-align: center;
            text-decoration: none;
            font-family: Helvetica;
            margin: 2px 0;
            padding: 0.5em 1em;
            color: #FFFFFF;
            background-color: #808080;
            width: 100%;
        }

            .my-button:active {
                transform: translateY(1px);
                filter: saturate(150%);
            }

            .my-button:hover,
            .my-button:focus {
                color: WHITE;
                border-color: currentColor;
                background-color: #A40000;
                font-weight: bold;
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


        <table style="width: 100%">
            <tr>
                <td style="width: 25%">

                    <input id="1" type="button" class="my-button" value="Expired Contract "
                        onclick="setColor(event)" />

                <td style="width: 25%">
                    <input id="2" type="button" class="my-button" value="Product Not In Contract"
                        onclick="setColor(event)" />
                </td>
                <td style="width: 25%">
                    <input id="3" type="button" class="my-button" value="Unknown Product"
                        onclick="setColor(event)" />

                </td>
                <td style="width: 25%">
                    <input id="4" type="button" class="my-button" value="Unknown Contract"
                        onclick="setColor(event)" />

                </td>
            </tr>
        </table>
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
                        style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer;" 
                        BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"  />
                <asp:HiddenField ID="hfHidden" runat="server" />
                <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                    PopupControlID="Panel1" DropShadow="true"
                    BackgroundCssClass="modalBackground" CancelControlID="btnCancel">
                </ajaxToolkit:ModalPopupExtender>


                <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">
                    <div id="popup">

                        <asp:UpdatePanel ID="pop1gd1" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <p style="font-family: Helvetica; color: #843C0C; font-size: 24px;">
                                    Contract for 
                                    <asp:Label ID="Lb1" runat="server" Text="Label"></asp:Label>
                                    with Item
                                    <asp:Label ID="Lb2" runat="server" Text="Label"></asp:Label>
                                </p>


                                <br />

                                <asp:GridView ID="pop1" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" OnPageIndexChanging="pop1_PageIndexChanging" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%; grid-area: auto;">
                                    <RowStyle BackColor="White" ForeColor="DarkBlue" />
                                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                    <Columns>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

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
                                        <asp:TemplateField HeaderText="Price">
                                            <ItemTemplate>
                                                <asp:Label ID="exp_dt" runat="server" Text=""></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Description">
                                            <ItemTemplate>
                                                <asp:Label ID="day_exp_by" runat="server" Text='<%# Eval("CNT_DES") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>



                                    </Columns>


                                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <br />
                        <div style="text-align: right; padding-right: 10%;">





                            <asp:Button ID="Button4" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                        </div>
                        <br />
                        <asp:UpdatePanel ID="UpdatePanel5" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <br />
                                <p style="font-family: Helvetica; color: #843C0C; font-size: 24px;">Seacrh All</p>
                                <asp:GridView ID="pop2" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" OnPageIndexChanging="pop2_PageIndexChanging" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%; grid-area: auto;">
                                    <RowStyle BackColor="White" ForeColor="DarkBlue" />
                                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                                    <Columns>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

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
                                        <asp:TemplateField HeaderText="Price">
                                            <ItemTemplate>
                                                <asp:Label ID="exp_dt" runat="server" Text=""></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Description">
                                            <ItemTemplate>
                                                <asp:Label ID="day_exp_by" runat="server" Text='<%# Eval("CNT_DES") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>



                                    </Columns>


                                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                                </asp:GridView>
                                <br />
                                <div style="text-align: right; padding-right: 10%;">





                                    <asp:Button ID="Button6" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>


                    </div>
                    <br />
                    <asp:Button ID="btnCancel" runat="server" ClientIDMode="Static" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" Text="Done" />
                </asp:Panel>


                <br />
                <br />


            </div>
        </div>

        <div id="ImgDetails2" style="display: none;">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gd2" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
                        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    &nbsp;&nbsp; <%--<asp:CheckBox ID="chkCheckAll1" runat="server" onclick=""  />--%>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    &nbsp;&nbsp;<asp:CheckBox ID="chkCheck2" runat="server" onclick="j" />
                                    <%--<asp:RadioButton ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract ID">
                                <ItemTemplate>
                                    <asp:Label ID="dis" runat="server" Text='<%# Eval("CNT_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Product ID">
                                <ItemTemplate>
                                    <asp:Label ID="con_ID" runat="server" Text='<%# Eval("prod_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Buyer Group">
                                <ItemTemplate>
                                    <asp:Label ID="bu_gp" runat="server" Text='<%# Eval("Buyer_Group") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Replace with">
                                <ItemTemplate>
                                    <asp:Label ID="rep_wt" runat="server" Text='<%# Eval("Replacing_With") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Comment">
                                <ItemTemplate>
                                    <asp:Label ID="INV_comment" runat="server" Text='<%# Eval("Err_Desc") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnShowPopUp23" runat="server" BorderWidth="0">
                                        <asp:ImageButton ID="btnShowPopUp54" runat="server" ImageUrl="~/img/edit1.png" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' Width="20px" Height="20px" />

                                    </asp:LinkButton>

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>

                </ContentTemplate>
            </asp:UpdatePanel>

            <br />
            <div style="text-align: right;">
                <asp:Button ID="Button1" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"  />
            </div>

        </div>

        <asp:HiddenField ID="HiddenField1" runat="server" />
        <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender2" runat="server" TargetControlID="HiddenField1"
            PopupControlID="Panel2" DropShadow="true"
            BackgroundCssClass="modalBackground" CancelControlID="Button7">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="Panel2" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">
            <div id="popup2">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server" style="text-align: left">
                    <ContentTemplate>

                        <p style="font-family: Helvetica; color: #843C0C; font-size: 24px;">
                            Contract for 
                            <asp:Label ID="lb3" ClientIDMode="Static" runat="server"></asp:Label>
                            with Item
                            <asp:Label ID="lb4" ClientIDMode="Static" runat="server"></asp:Label>
                        </p>

                        <br />
                        <asp:Label ID="hidgd3" runat="server" Text="Label" Visible="false"></asp:Label>
                        <asp:Label ID="hidgd4" runat="server" Text="Label" Visible="false"></asp:Label>
                        <asp:GridView ID="prod_up_pop1" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%; grid-area: auto;">
                            <RowStyle BackColor="White" ForeColor="DarkBlue" />
                            <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                            <Columns>
                                <asp:TemplateField>

                                    <ItemTemplate>
                                        <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                                    </ItemTemplate>
                                </asp:TemplateField>

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
                                <asp:TemplateField HeaderText="Price">
                                    <ItemTemplate>
                                        <asp:Label ID="exp_dt" runat="server" Text=""></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Description">
                                    <ItemTemplate>
                                        <asp:Label ID="day_exp_by" runat="server" Text='<%# Eval("CNT_DES") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>

                            <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                        </asp:GridView>
                        <br />

                        <div style="text-align: right; padding-right: 10%;">
                            <asp:Button ID="Button8" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"  />
                        </div>
                        <br />
                        <p style="font-family: Helvetica; color: #843C0C; font-size: 24px;">Seacrh All</p>
                        <asp:GridView ID="prod_up_pop2" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%; grid-area: auto;">
                            <RowStyle BackColor="White" ForeColor="DarkBlue" />
                            <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />

                            <Columns>
                                <asp:TemplateField>

                                    <ItemTemplate>
                                        <asp:CheckBox ID="ckpop1" runat="server" onclick="CheckOne(this)" />
                                    </ItemTemplate>
                                </asp:TemplateField>

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
                                <asp:TemplateField HeaderText="Price">
                                    <ItemTemplate>
                                        <asp:Label ID="exp_dt" runat="server" Text=""></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Description">
                                    <ItemTemplate>
                                        <asp:Label ID="day_exp_by" runat="server" Text='<%# Eval("CNT_DES") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>

                            <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                        </asp:GridView>
                        <br />
                        <div style="text-align: right; padding-right: 10%;">
                            <asp:Button ID="Button9" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"  />
                        </div>
                        <asp:Button ID="Button10" runat="server" Text="Done" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
            <br />
        </asp:Panel>

        <div id="ImgDetails3" style="display: none;">

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gd3" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%;">
                        <RowStyle BackColor="White" ForeColor="DarkBlue" />
                        <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkCheck2" runat="server" onclick="CheckOne(this)" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Distributor Name">
                                <ItemTemplate>
                                    <asp:Label ID="dis_nm" runat="server" Text='<%# Eval("DIST_NR") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Distributor ID">
                                <ItemTemplate>
                                    <asp:Label ID="dis_id" runat="server" Text='<%# Eval("dist_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Product ID">
                                <ItemTemplate>
                                    <asp:Label ID="con_ID" runat="server" Text='<%# Eval("prod_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Replace with">
                                <ItemTemplate>
                                    <asp:TextBox ID="replacewith" runat="server" Width="150px" BorderColor="#808080" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                          

                        </Columns>

                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>

                    <br />
                    <div style="text-align: right; padding-right: 10%;">
                        <asp:Button ID="Button2" runat="server" Text="Replace" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"  />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div id="ImgDetails4" style="display: none;">

        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gd4" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10"
                    BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 80%;">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <%--<asp:CheckBox ID="chkCheckAll1" runat="server" onclick=""  />--%>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkCheck2" runat="server" onclick="CheckOne(this)" />
                                <%--<asp:RadioButton ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Distributor">
                            <ItemTemplate>
                                <asp:Label ID="dis" runat="server" Text='<%# Eval("dist_id") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contract ID">
                            <ItemTemplate>
                                <asp:Label ID="con_ID" runat="server" Text='<%# Eval("cnt_id") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Replace with">
                            <ItemTemplate>
                                <asp:TextBox ID="un_con_id" runat="server" Width="150px" BorderColor="#808080" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Replace">
                            <ItemTemplate>
                                <asp:RadioButton ID="Replace" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="text-align: center" />
                            </ItemTemplate>
                        </asp:TemplateField>


                    </Columns>

                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

                <br />
                <div style="text-align: right; padding-right: 10%;">
                    <asp:Button ID="Button3" runat="server" Text="Replace" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"  />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>

