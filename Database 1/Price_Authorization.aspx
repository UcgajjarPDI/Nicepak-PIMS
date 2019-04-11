<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Price_Authorization.aspx.vb" Inherits="Database_1.Price_Authorization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/main.css" rel="stylesheet" media="screen" />
    <script src="Scripts/jquery-3.3.1.min.js" type="text/javascript"></script>
    <%-- <script type="text/javascript">

        function GetContractsBuyersId() {
            debugger;
            var objddl = document.getElementById("<%= ddlGPO.ClientID%>");
            //Show the seleted item value
            alert(objddl.options[objddl.selectedIndex].value);
            $.ajax({
                type: "GET",
                url: "Price_Authorization.aspx/GetContractsInfo",
                contentType: "application/json",
                dataType: "json",
                success: function (response) {
                    debugger;
                    alert(response.d);
                },
                failure: function (response) {
                    debugger;
                    alert(response.d);
                }
            });
        }

    </script>--%>
    <style>
        * {
            box-sizing: border-box;
        }

        .column {
            float: left;
            width: 80%;
            padding: 10px;
        }

        .column1 {
            float: left;
            width: 20%;
            padding: 10px;
        }

        .row:after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="column">
            <div style="width: 100%">

                <table style="width: 80%">
                    <tr>
                        <td style="width: 90px">
                            <p class="pTitleStyles">
                                GPO Name:
                            </p>
                        </td>
                        <td style="text-align: left">
                            <p class="pLabelStyles">
                                <asp:DropDownList ID="ddlGPO" runat="server" Font-Names="Helvetica"
                                    Font-Size="14px" ForeColor="#843C0C" Width="200px"
                                    AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlGPO_SelectedIndexChanged">
                                </asp:DropDownList>
                            </p>
                        </td>
                        <td style="width: 160px">
                            <p class="pTitleStyles">
                                Contract & Tier Number
                            </p>
                        </td>
                        <td>
                            <p class="pLabelStyles">
                                <asp:DropDownList ID="ddlContractNumber" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                    Font-Size="14px" ForeColor="#843C0C" Width="200px">
                                </asp:DropDownList>
                            </p>
                        </td>
                        <td>
                            <p class="pLabelStyles">
                                <input type="button" id="btnSearch"
                                    runat="server"
                                    onserverclick="btnSearch_ServerClick"
                                    value="Show" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; background-color: #A40000; color: white;" />
                            </p>
                        </td>
                    </tr>

                </table>


                <asp:GridView ID="gd1" EnableViewState="true" runat="server" AutoGenerateColumns="false" GridLines="Horizontal"
                    CellPadding="8" BorderStyle="None" PageSize="20" AllowPaging="true" BorderWidth="1px" CssClass="gridStyle">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Image ID="img_eb" runat="server" Visible='<%# IIf(Eval("BI").Equals("Y"), "True", "False") %>'
                                    ClientIDMode="Static" ImageUrl="~/img/buyer_icon.PNG"
                                    Width="15px" Height="15px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Member ID">
                            <ItemTemplate>
                                <asp:Label ID="GPO_MBR_ID" runat="server" Text='<%# Eval("GPO_MBR_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GPO Company">
                            <ItemTemplate>
                                <asp:Label ID="GPOCompany" runat="server" Text='<%# Eval("GPOCompany") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PDI Company">
                            <ItemTemplate>
                                <asp:Label ID="PDICompany" runat="server" Text='<%# Eval("PDICompany") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sales">
                            <ItemTemplate>
                                <asp:Label ID="Sales" runat="server" Text='<%# Eval("Sales") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Parent Sales">
                            <ItemTemplate>
                                <asp:Label ID="ParSales" runat="server" Text='<%# Eval("ParSales") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Network Sales">
                            <ItemTemplate>
                                <asp:Label ID="NetworkSales" runat="server" Text='<%# Eval("NetworkSales") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Curr. Tier">
                            <ItemTemplate>
                                <asp:Label ID="CurrTier" runat="server" Text='<%# Eval("CurrTier") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reqt. Tier">
                            <ItemTemplate>
                                <asp:Label ID="ReqtTier" runat="server" Text='<%# Eval("ReqtTier") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approve Tier">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlApprTier" runat="server"
                                    OnSelectedIndexChanged="ddlApprTier_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

                </asp:GridView>

                <p style="text-align: right">
                    <input type="button" id="btnSumit"
                        runat="server"
                        onserverclick="btnSumit_ServerClick"
                        visible="false"
                        value="Submit" style="width: 100px; height: 25px; font-family: Helvetica; border: none; cursor: pointer; background-color: #A40000; color: white;" />
                </p>

            </div>
        </div>
        <div class="column1">
            <div>
                <asp:GridView ID="grdTierDesc" EnableViewState="true" runat="server" AutoGenerateColumns="false" GridLines="Horizontal"
                    CellPadding="8" BorderStyle="None" PageSize="20" AllowPaging="true">
                    <RowStyle BackColor="White" ForeColor="DarkBlue" Font-Names="Helvetica" Font-Size="14px" />
                    <Columns>

                        <asp:TemplateField HeaderText="Tier">
                            <ItemTemplate>
                                <asp:Label ID="TierId" runat="server" Text='<%# Eval("TierId") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <asp:Label ID="Description" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <HeaderStyle Font-Bold="True" ForeColor="Red" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Top" Wrap="FALSE" />
                    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
                </asp:GridView>
            </div>

        </div>
    </div>


</asp:Content>
