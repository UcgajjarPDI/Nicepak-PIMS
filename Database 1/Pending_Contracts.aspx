<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Pending_Contracts.aspx.vb" Inherits="Database_1.Pending_Contracts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <table style="width: 100%">
            <tr>
                <td>
                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: #843C0C; font-size: 24px;">Action Items</p>
                </td>
                <td>
                    <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; color: black; font-size: 20px; text-align: right;">Pending Contracts</p>
                </td>
            </tr>

        </table>
        <asp:GridView ID="gd2" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8" BorderStyle="None" BorderWidth="1px" Style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; grid-area: auto;">

            <RowStyle BackColor="White" ForeColor="DarkBlue" />
            <AlternatingRowStyle BackColor="#E7E7E7" ForeColor="DarkBlue" />
            <Columns>
                <asp:TemplateField HeaderText="Contract #">
                    <ItemTemplate>    
                        <asp:LinkButton ID="Link" runat="server" PostBackUrl= '<%# String.Format("~/New_Contract.aspx?CntNr={0}", Eval("CNT_NR"))%>' ><%# Eval("CNT_NR") %></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Buyer Group">
                    <ItemTemplate>
                        <asp:Label ID="BY_GR1" runat="server" Text='<%# Eval("CMPNY_NM") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Initiated By">
                    <ItemTemplate>
                        <asp:Label ID="in_us" runat="server" Text='<%# Eval("USR_FULL_NM") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="cnt_stat" runat="server" Text='<%# Eval("CNT_STAT_CD") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action Requested">
                    <ItemTemplate>
                        <asp:Label ID="cnt_typ" runat="server" Text='<%# Eval("CNT_TYP_CD") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Complete By">
                    <ItemTemplate>
                        <asp:Label ID="Comp_gr_id" runat="server" Text='<%# Eval("CNT_RVW_DL_DT") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="FALSE" />
            <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />

        </asp:GridView>
    </div>
</asp:Content>
