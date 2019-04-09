<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="CurrentMonthSales.aspx.vb" Inherits="Database_1.WebForm3" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/main.css" rel="stylesheet" media="screen" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript">
        window.onload = function () {
            var $tooltip = $("#LineChart1").find("LineChart1_tooltipDiv");


            $tooltip.style.top = evt.pageY - 2 + 'px';
            $tooltip.style.left = evt.pageX + 2 + 'px';
            $tooltip.style.visibility = 'visible';
            $tooltip.style.strokeWidth = '0';
            $tooltip.style.padding = 0 + 'px';

        };
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server" ScriptMode="Release">
    </asp:ScriptManager>



        <div style="width: 100%">

            <table style="width: 100%">
                <tr>
                    <td>
                        <p class="pTitleStyles"> 
                            Sales Period:&nbsp  
                            <asp:DropDownList ID="DropDownExtender1" runat="server" AutoPostBack="true" Font-Names="Helvetica"
                                Font-Size="14px" ForeColor="#843C0C">
                            </asp:DropDownList>
                       </p>
                    </td>
                   
                    <td>
                        <p class="pLabelStyles">Sales Tracing Summary</p>
                    </td>
                </tr>

            </table>
        </div>


        <asp:GridView ID="gd1" runat="server"
            AutoGenerateColumns="false" GridLines="Horizontal"
            CellPadding="5" BorderStyle="None" BorderWidth="1px"
            AllowPaging="false" AllowSorting="true" CssClass="gridStyle">
            <RowStyle BackColor="White" ForeColor="DarkBlue" />
            <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
            <Columns>

                <asp:TemplateField HeaderText="Distributer">
                    <ItemTemplate>
                        <div style="text-align: left;">
                            <asp:Label ID="PROD" runat="server" Text='<%# Eval("DIST_TRC_NM") %>'></asp:Label>
                            <asp:Label ID="DIST_ID" runat="server" Text='<%# Eval("DIST_ID") %>' Visible="false"></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Receive Date">
                    <ItemTemplate>
                        <asp:Label ID="pr_ds" runat="server" Text='<%# Eval("RECVD_DTE") %>' Style="text-align: right;"></asp:Label>
                        <asp:Label ID="sales_period_gd1" runat="server" Text='<%# Eval("SALES_PERIOD") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Total Rec">
                    <ItemTemplate>
                        <asp:Label ID="cu_pr" runat="server" Text='<%# Eval("REC_CNT") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>


                <asp:TemplateField HeaderText="Exception">
                    <ItemTemplate>
                        <asp:Label ID="cu_vol" runat="server" Text='<%# Eval("EXCP_COUNT") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="CS Qty">
                    <ItemTemplate>
                        <asp:Label ID="rl_6asp" runat="server" Text='<%# Eval("CS_QTY") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="6 Mo. Avg">
                    <ItemTemplate>
                        <asp:Label ID="rl_12asp" runat="server" Text='<%# Eval("ROLLING_6_MN_AV_QTY") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="12 Mo. Avg">
                    <ItemTemplate>
                        <asp:Label ID="vz_pr" runat="server" Text='<%# Eval("ROLLING_12_MN_AV_QTY") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Sales Amt">
                    <ItemTemplate>
                        <asp:Label ID="am_ti1" runat="server" Text='<%# Eval("SALES_AMT") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="6 Mo. Avg">
                    <ItemTemplate>
                        <asp:Label ID="am_ti2" runat="server" Text='<%# Eval("ROLLING_6_MN_AV_AMT") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="12 Mo. Avg">
                    <ItemTemplate>
                        <asp:Label ID="Ehg_pr" runat="server" Text='<%# Eval("ROLLING_12_MN_AV_AMT") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>

                        <asp:LinkButton ID="btnShowPopUp23" runat="server" BorderWidth="0" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>'>
                            <asp:ImageButton ID="btnShowPopUp54" runat="server" ClientIDMode="Static" ImageUrl="~/img/line_chart.jpg" CommandName="select" CommandArgument='<%# Container.DataItemIndex %>' Width="16px" Height="16px" />

                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>


            <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Right" VerticalAlign="Middle" Wrap="FALSE" />
            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />

            <RowStyle Font-Names="Helvetica" HorizontalAlign="Right" VerticalAlign="Middle" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

        </asp:GridView>



    <asp:HiddenField ID="hfHidden" runat="server"  />
    <ajaxToolkit:ModalPopupExtender ClientIDMode="Static" ID="ModalPopupExtender1" runat="server" TargetControlID="hfHidden"
        PopupControlID="Panel1" DropShadow="true"
        BackgroundCssClass="modalBackground" CancelControlID="Button1">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="Panel1" ClientIDMode="Static" runat="server" CssClass="modalPopup" align="center" Style="display: none; font-family: Helvetica;" ScrollBars="Auto">
        <p style="text-align: right;">
            <asp:ImageButton ID="Button1" runat="server" Height="20px" Width="20px" BorderStyle="None" ImageUrl="~/img/Cancle.Png" />
        </p>
        <div style="width: 80%; height: 400px;">
            <ajaxToolkit:LineChart ID="LineChart1" runat="server" ClientIDMode="Static" ChartWidth="650" ChartHeight="800" EnableViewState="True"
                ChartType="Basic" ChartTitleColor="#0E426C" Visible="false" CategoryAxisLineColor="#ffcccc"
                ValueAxisLineColor="#ffcccc" BaseLineColor="#A40000" BorderStyle="None" BorderColor="White" TooltipBorderColor="white">
            </ajaxToolkit:LineChart>
        </div>
    </asp:Panel>


</asp:Content>
