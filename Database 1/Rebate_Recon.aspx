<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Rebate_Recon.aspx.vb" Inherits="Database_1.Rebate_Recon" %>

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
                $('div[id*=ImgDetails]').hide();
                currentDiv.show();
                if (currentDiv.style.display === "none") {
                    inp.style.background - color === "#A40000";
                } else {
                    inp.style.background - color === "#808080";
                }
            });


        });

        //        $("#btnShowPopUp").live("click", function () {

        //        $("#popup").dialog({
        //            title: "Displaying GridView Data",
        //            width: 600,
        //            hide:false,

        //            buttons: {
        ////            if you want close button use below code
        ////                Close: function () {
        ////                    $(this).dialog('close');
        ////                }
        //            }
        //            });
        //            return false;
        //            //$(document).ready(function () {


        //    });
        //            //function pop(cnt, prod) {

        //            //      $.session.set("contr", (cnt));
        //            //$.session.set("produ", (prod));
        //            //    $.session.get("contr");
        //            //}

        //        $(document).ready(function () {
        // $(".opener").click(function () {
        //          $(".popup").dialog("open");
        //          return false;
        //      });
        //  });
        //        function popup1(cnt, prod) {
        //            $("#lb1").text(cnt);
        //            $("#lb2").text(prod);
        //            $("#popup").dialog({

        //                title: "show",
        //                width: "800px",
        //                height: "800px",
        //                modal=true,
        //                buttons: {
        //                    close: function () { $(this).dialog('close');}

        //                }



        //            })



        //        }
        function CompareConfirm() {
            var str1 = "abc";
            var str2 = "def";

            if (str1 === str2) {
                // your logic here
                return false;
            } else {
                // your logic here
                return confirm("Confirm?");
            }
        }
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
        } function HidePanelA() {
            $('ImgDetails1').hide()
            $('ImgDetails2').show()
            $('ImgDetails3').hide()
            $('ImgDetails4').hide()
        }
        function HidePanelA() {
            $('ImgDetails1').show()
            $('ImgDetails2').hide()
            $('ImgDetails3').hide()
            $('ImgDetails4').hide()
        }
    </script>
    <style>
        /**
     * Reset button styles
     * It takes some work to achieve a “blank slate” look.
     */
        INPUT {
            padding: 0;
            border: none;
            font: inherit;
            color: inherit;
            background-color: transparent;
            /* show a hand cursor on hover; some argue that we
      should keep the default arrow cursor for buttons */
            cursor: pointer;
            font-family: Trebuchet MS, Arial, Helvetica, sans-serif;
        }


        .my-button {
            /* default for <button>, but needed for <a> */
            display: inline-block;
            text-align: center;
            text-decoration: none;
            font-family: Trebuchet MS, Arial, Helvetica, sans-serif;
            /* create a small space when buttons wrap on 2 lines */
            margin: 2px 0;
            /* invisible border (will be colored on hover/focus) */
            /*border: solid 1px transparent;
      border-radius: 4px;*/
            /* button size comes from text + padding, avoid height */
            padding: 0.5em 1em;
            /* make sure colors have enough contrast! */
            color: #FFFFFF;
            background-color: #808080;
            width: 100%;
        }

            /* old-school "down" effect on clic + color tweak */
            .my-button:active {
                transform: translateY(1px);
                filter: saturate(150%);
            }

            /* inverse colors on mouse-over and focus */
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
            font-family: Trebuchet MS, Arial, Helvetica, sans-serif;
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
        <br />
        <div id="ImgDetails1" <%--style="display: none;"--%>>
            <table style="width: 100%">
                <tr>
                    <td>
                        <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Expired Contract </p>
                    </td>
                    <td>
                        <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: black; font-size: 20px; text-align: right;">Sales Period:<asp:Label runat="server" ID="sales_period"></asp:Label></p>
                    </td>
                </tr>

            </table>

            <asp:UpdatePanel ID="up1" runat="server">
                <ContentTemplate>

                    <asp:GridView ID="gd1" EnableViewState="true" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">
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
                            <asp:TemplateField HeaderText="Persistent">
                                <ItemTemplate>
                                    <asp:CheckBox ID="Persistent" runat="server" Checked="true" />
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
                            <asp:TemplateField HeaderText="Replace">
                                <ItemTemplate>
                                    <asp:RadioButton ID="Replace" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="text-align: center" />
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
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
            <br />
            <div style="text-align: right;">
                <asp:Button ID="Button5" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                <asp:HiddenField ID="hfHidden" runat="server" />
                <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
                    PopupControlID="Panel1" DropShadow="true"
                    BackgroundCssClass="modalBackground" CancelControlID="btnCancel">
                </ajaxToolkit:ModalPopupExtender>


                <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Trebuchet MS, Arial, Helvetica, sans-serif;" ScrollBars="Auto">
                    <div id="popup">

                        <asp:UpdatePanel ID="pop1gd1" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">
                                    Contract for 
                                    <asp:Label ID="Lb1" runat="server" Text="Label"></asp:Label>
                                    with Item
                                    <asp:Label ID="Lb2" runat="server" Text="Label"></asp:Label>
                                </p>

                                <br />

                                <asp:GridView ID="pop1" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" OnPageIndexChanging="pop1_PageIndexChanging" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%; grid-area: auto;">


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
                                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <br />
                        <div style="text-align: right; padding-right: 10%;">
                            <asp:Button ID="Button4" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                        </div>
                        <br />
                        <asp:UpdatePanel ID="UpdatePanel5" runat="server" style="text-align: left">
                            <ContentTemplate>
                                <br />
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Seacrh All</p>
                                <asp:GridView ID="pop2" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" OnPageIndexChanging="pop2_PageIndexChanging" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%; grid-area: auto;">


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
                                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                                </asp:GridView>
                                <br />
                                <div style="text-align: right; padding-right: 10%;">
                                    <asp:Button ID="Button6" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
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
        <br />
        <div id="ImgDetails2" style="display: none;">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Product Not In Contract </p>
                            </td>
                            <td>
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: black; font-size: 20px; text-align: right;"></p>
                            </td>
                        </tr>

                    </table>
                    <asp:GridView ID="gd2" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%;">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    &nbsp;&nbsp; <%--<asp:CheckBox ID="chkCheckAll1" runat="server" onclick=""  />--%>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    &nbsp;&nbsp;<asp:CheckBox ID="chkCheck2" runat="server" onclick="j" />
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
                            <asp:TemplateField HeaderText="Persistent">
                                <ItemTemplate>
                                    <asp:CheckBox ID="Persistent" runat="server" Checked="true" />
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
                            <asp:TemplateField HeaderText="Comment">
                                <ItemTemplate>
                                    <%-- <asp:TextBox ID="INV_comment" runat="server" Width="200px" BorderColor="#808080" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>--%>
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
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>

                </ContentTemplate>
            </asp:UpdatePanel>


            <br />
            <div style="text-align: right;">

                <asp:Button ID="Button1" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
            </div>

        </div>

        <asp:HiddenField ID="HiddenField1" runat="server" />
        <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender2" runat="server" TargetControlID="HiddenField1"
            PopupControlID="Panel2" DropShadow="true"
            BackgroundCssClass="modalBackground" CancelControlID="Button7">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="Panel2" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Trebuchet MS, Arial, Helvetica, sans-serif;" ScrollBars="Auto">
            <div id="popup2">



                <asp:UpdatePanel ID="UpdatePanel4" runat="server" style="text-align: left">
                    <ContentTemplate>

                        <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">
                            Contract for 
                            <asp:Label ID="lb3" ClientIDMode="Static" runat="server"></asp:Label>
                            with Item
                            <asp:Label ID="lb4" ClientIDMode="Static" runat="server"></asp:Label>
                        </p>


                        <br />
                        <asp:Label ID="hidgd3" runat="server" Text="Label" Visible="false"></asp:Label>
                        <asp:Label ID="hidgd4" runat="server" Text="Label" Visible="false"></asp:Label>
                        <asp:GridView ID="prod_up_pop1" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%; grid-area: auto;">


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
                            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                        </asp:GridView>
                        <br />

                        <div style="text-align: right; padding-right: 10%;">
                            <asp:Button ID="Button8" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                        </div>
                        <br />
                        <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Seacrh All</p>
                        <asp:GridView ID="prod_up_pop2" EnableViewState="true" runat="server" ClientIDMode="Static" PageSize="5" AllowPaging="true" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%; grid-area: auto;">


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
                            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                        </asp:GridView>
                        <br />
                        <div style="text-align: right; padding-right: 10%;">

                            <asp:Button ID="Button9" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                        </div>
                        <asp:Button ID="Button10" runat="server" Text="Done" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" />
                    </ContentTemplate>
                </asp:UpdatePanel>


            </div>
            <br />
        </asp:Panel>

        <br />
        <br />

        <div id="ImgDetails3" style="display: none;">

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Unknown Product </p>
                            </td>
                            <td>
                                <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: black; font-size: 20px; text-align: right;"></p>
                            </td>
                        </tr>

                    </table>

                    <asp:GridView ID="gd3" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%;">
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
                            <asp:TemplateField HeaderText="Persistent">
                                <ItemTemplate>
                                    <asp:CheckBox ID="Persistent" runat="server" Checked="true" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Comment">
                                <ItemTemplate>
                                    <asp:TextBox ID="un_pro_comment" runat="server" Width="200px" BorderColor="#808080" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>


                        </Columns>


                        <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                        <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                        <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                    </asp:GridView>




                    <br />
                    <div style="text-align: right; padding-right: 10%;">





                        <asp:Button ID="Button2" runat="server" Text="Replace" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div id="ImgDetails4" style="display: none;">

        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
            <ContentTemplate>
                <table style="width: 100%">
                    <tr>
                        <td>
                            <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Unknown Contract </p>
                        </td>
                        <td>
                            <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: black; font-size: 20px; text-align: right;"></p>
                        </td>
                    </tr>

                </table>
                <asp:GridView ID="gd4" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" AllowPaging="true" PageSize="10" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 80%;">
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
                                <%-- <asp:DropDownList ID="rep_with" runat="server">
                     <asp:ListItem Text="Please Select an item" Value ="-1"></asp:ListItem>
                </asp:DropDownList>--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Persistent">
                            <ItemTemplate>
                                <asp:CheckBox ID="Persistent" runat="server" Checked="true" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="align-content: center;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- <asp:TemplateField  HeaderText="Accept">
            <ItemTemplate>
                <asp:RadioButton ID="Accept" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" style="text-align:center"/>
            </ItemTemplate>
        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Replace">
                            <ItemTemplate>
                                <asp:RadioButton ID="Replace" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" Style="text-align: center" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comment">
                            <ItemTemplate>
                                <asp:TextBox ID="un_con_comment" runat="server" Width="200px" BorderColor="#808080" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>



                    </Columns>


                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>




                <br />
                <div style="text-align: right; padding-right: 10%;">

                    <asp:Button ID="Button3" runat="server" Text="Replace" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px" OnClientClick="return confirm('Please confirm');" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>


</asp:Content>
