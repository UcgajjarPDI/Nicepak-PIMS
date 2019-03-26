<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="New_Contract.aspx.vb" Inherits="Database_1.New_Contract" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/main.css" rel="stylesheet" />
 </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <div style="text-align: center; width: 100%;">
                <input type="button" value="General" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; background-color: #A40000; color: white;" onclick="window.location = 'New_Contract.aspx'" />
                <input id="3" type="button" value="Product" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080;" onclick="window.location = 'NewCont_Product.aspx'" />
                <input id="4" type="button" value="Eligible Buyers" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080;" onclick="window.location = 'NewCont_Eligible_Buyers.aspx'" />
                <input id="5" type="button" value="Comm" style="width: 100px; height: 25px; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border: none; cursor: pointer; color: WHITE; background-color: #808080;" onclick="window.location = 'NewCont_Comm.aspx'" />
            </div>
            <br />
            <div>
                <table class="divTableCell">
                    <tr>
                        <td>Buyer Group</td>
                        <td>&nbsp;</td>
                        <td>Contract Type</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtBuyerGroup" runat="server" Width="400px" CssClass="Curved"></asp:TextBox>

                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="cnt_byerGrp" MinimumPrefixLength="1"
                                CompletionInterval="10" EnableCaching="false" CompletionSetCount="10" TargetControlID="txtBuyerGroup"
                                ID="AutoCompleteExtender1" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                           <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator4"
                                ControlToValidate="txtBuyerGroup"
                                Display="Static"
                                ErrorMessage="Buyer Group is required"
                                runat="server"
                                ForeColor="Red" />--%>

                        </td>
                        <td></td>
                        <td>
                            <asp:DropDownList ID="lstContractType" runat="server" CssClass="Curved" AutoPostBack="true">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Buyer Group Contract Nr</td>
                        <td></td>
                        <td>Contract Nr</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtBuyerContractNr" runat="server" CssClass="Curved" ></asp:TextBox>
                        </td>
                        <td></td>
                        <td>
                            <asp:TextBox ID="txtContractNr" runat="server" CssClass="Curved"></asp:TextBox>
                         <%--   <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                ControlToValidate="txtContractNr"
                                Display="Static"
                                ErrorMessage="Contract number is required"
                                runat="server"
                                ForeColor="Red" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td>Effective Date</td>
                        <td></td>
                        <td>Expiration Date</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtEffDate" runat="server" CssClass="Curved" AutoCompleteType="Disabled"></asp:TextBox>
                          <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                ControlToValidate="txtEffDate"
                                Display="Static"
                                ErrorMessage="Effective Date is required"
                                runat="server"
                                ForeColor="Red" />--%>
                            <ajaxToolkit:CalendarExtender ID="CalendarExtender3" PopupButtonID="imgPopup" TargetControlID="txtEffDate" Format="yyyy-MM-dd" runat="server" />
                        </td>
                        <td></td>
                        <td>
                            <asp:TextBox ID="txtExpDate" runat="server" CssClass="Curved" AutoCompleteType="Disabled"></asp:TextBox>
                           <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator3"
                                ControlToValidate="txtExpDate"
                                Display="Static"
                                ErrorMessage="Expiration Date is required"
                                runat="server"
                                ForeColor="Red" />--%>
                            <ajaxToolkit:CalendarExtender ID="CalendarExtender4" PopupButtonID="imgPopup" TargetControlID="txtExpDate" Format="yyyy-MM-dd" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>Replacement Indicator</td>
                        <td></td>
                        <td>Replacing Contract Nr</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="lstReplIndicator" runat="server" CssClass="Curved" AutoPostBack="true">
                                <%-- <asp:ListItem Text="---Please Select---" Value="0"></asp:ListItem>--%>
                                <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                                <asp:ListItem Text="No" Value="N"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td></td>
                        <td>
                            <asp:TextBox ID="txtReplacingContractNr" runat="server" CssClass="Curved"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="old_cnt" MinimumPrefixLength="0"
                                CompletionInterval="0" EnableCaching="false" CompletionSetCount="2" TargetControlID="txtReplacingContractNr"
                                ID="AutoCompleteExtender5" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                            <ajaxToolkit:AutoCompleteExtender ServiceMethod="cnt_cnt" MinimumPrefixLength="0"
                                CompletionInterval="0" EnableCaching="false" CompletionSetCount="2" TargetControlID="txtContractNr"
                                ID="AutoCompleteExtender6" runat="server" FirstRowSelected="false" CompletionListCssClass="completionList"
                                CompletionListHighlightedItemCssClass="itemHighlighted"
                                CompletionListItemCssClass="listItem">
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                    </tr>
                    <tr>
                        <td>Tier Description</td>
                        <td></td>
                        <td>Tier Level ID</td>
                    </tr>
                    <tr>
                        <div id="tier">
                            <td>
                                <asp:TextBox ID="txtTierDesc" runat="server" CssClass="Curved" Width="400px" MaxLength="200"></asp:TextBox>
                            </td>
                            <td></td>
                            <td>
                                <asp:DropDownList ID="lsttierLevelId" runat="server" CssClass="Curved">
                                    <asp:ListItem Text="---Please Select---" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                    <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                    <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                    <%--      <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                    <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                    <asp:ListItem Text="10" Value="10"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </td>
                        </div>
                    </tr>
                    <tr>
                        <td>Contract Description</td>
                        <td></td>
                        <td>&nbsp</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtContractDesc" runat="server" CssClass="Curved" Width="400px" Height="50px" TextMode="MultiLine" MaxLength="500" ToolTip="Only 500 Characters"></asp:TextBox>
                        </td>
                        <td></td>
                        <td>
                            <asp:Button ID="btnSubmit" runat="server" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="130px" Height="25px" />
                        </td>
                    </tr>
                </table>
            </div>

            <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: red; font-size: 24px;">
                <asp:Label ID="Lbl_Error" runat="server" EnableViewState="false"></asp:Label>
            </p>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
