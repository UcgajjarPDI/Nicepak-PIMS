<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="EDI_845_CONTRACT.aspx.vb" Inherits="Database_1.EDI_845" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table><tr><td><div>
    <table style="width:100%;"><tr><td><div style="text-align:right">
            <INPUT  type="button"  value="Contract" style="width:100px;font-family: Helvetica;border:none;cursor:pointer;background-color:#A40000;color: WHITE;  " onClick="window.location='EDI_845_CONTRACT.aspx'"/>
            <INPUT id="3" type="button"  value="Price Authorization" style="width:125px;font-family: Helvetica;border:none;cursor:pointer; color: #FFFFFF;background-color: #808080;" onClick="window.location='EDI_845_PRC_AUTH.aspx';" />
            
                                           </div></td></tr></table>
    <div>
        <asp:Button ID="btn_drop" runat="server" Text="Send" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"  Width="100px" Height="26px" />
    
    <asp:Label ID="Label5" runat="server" style="background-color:#A40000; border:none;font-family: Helvetica; color:white;font:bold; " Visible="false">Job Is Running</asp:Label></div>
    <br />
    <asp:GridView ID="gd1" runat="server"  ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="5" BorderStyle="None" BorderWidth="1px" PageSize="20" allowpaging="true" AllowSorting="true" Style="font-family: Helvetica; grid-area: auto; width: 100%">
            <Columns>

                <asp:TemplateField HeaderText="Updated Contract Type">
                    <ItemTemplate>
                        <div style="text-align:center">
                            <asp:Label ID="PROD" runat="server" Text='<%# Eval("CNT_UPD_TYP") %>'></asp:Label>
                          </div>
                       
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Contract">
                    <ItemTemplate>
                        <asp:Label ID="pr_ds" runat="server" Text='<%# Eval("CNT_NR") %>' Style="text-align: right;"></asp:Label>
                        
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Product">
                    <ItemTemplate>
                        <asp:Label ID="cu_pr" runat="server" Text='<%# Eval("PROD_ID") %>' Style="text-align: right;"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>


              
            </Columns>


            <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Right" VerticalAlign="Middle" Wrap="FALSE" />
            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />

            <RowStyle Font-Names="Helvetica" HorizontalAlign="Right" VerticalAlign="Middle" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

        </asp:GridView>
        </div></td></tr></table>
</asp:Content>
