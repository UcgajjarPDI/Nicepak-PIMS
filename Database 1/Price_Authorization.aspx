<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Price_Authorization.aspx.vb" Inherits="Database_1.Price_Authorization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
     <asp:GridView ID="gd1" EnableViewState="true" runat="server"    AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8"   BorderStyle="None"  PageSize="10" allowpaging="true" BorderWidth="1px" style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;width:100%; grid-area:auto;"  >
            
            
            <Columns>
                  
            
                     <asp:TemplateField HeaderText="Contract ID">
            <ItemTemplate>
                <asp:Label ID="CNT_ID" runat="server" Text='<%# Eval("MFG_CNT_NR") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Gpo Name">
            <ItemTemplate>
                <asp:Label ID="GPO" runat="server" Text='<%# Eval("GPO_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                <asp:TemplateField  HeaderText="Member ID">
            <ItemTemplate>
                <asp:Label ID="ME_ID" runat="server" Text='<%# Eval("GPO_MBR_ID") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="End user">
            <ItemTemplate>
                <asp:Label ID="EN_US_NM" runat="server" Text='<%# Eval("COACCTSHIPNAME") %>'></asp:Label><BR />
                 <asp:Label ID="EN_US_ADD" runat="server" Text='<%# Eval("COACCTSHIPADDR1") %>'></asp:Label><BR />
                 <asp:Label ID="EN_US_CT" runat="server" Text='<%# Eval("COACCTSHIPCITY") %>'></asp:Label>&nbsp;<asp:Label ID="EN_US_ST" runat="server" Text='<%# Eval("COACCTSHIPSTATE") %>'></asp:Label>&nbsp;<asp:Label ID="EN_US_ZIP" runat="server" Text='<%# Eval("COACCTSHIPZIP") %>'></asp:Label>&nbsp;
            </ItemTemplate>
        </asp:TemplateField>
                      <asp:TemplateField  HeaderText="Tier">
            <ItemTemplate>
                <asp:Label ID="TIER" runat="server" Text='<%# Eval("CNT_TIER_LVL") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                  
                    <asp:TemplateField  HeaderText="Description">
            <ItemTemplate>
                <asp:Label ID="Des" runat="server" Text='<%# Eval("TIER_DESC") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>    
             <asp:TemplateField  HeaderText="Sale">
            <ItemTemplate>
                <asp:Label ID="SALE" runat="server" Text='<%# Eval("SALE") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                <asp:TemplateField  HeaderText="Network Sale">
            <ItemTemplate>
               <p style="text-align:right;  " > <asp:Label ID="NT_SALE" runat="server" Text='<%# Eval("NETWORK_SALE") %>'></asp:Label></p>
            </ItemTemplate>
        </asp:TemplateField>
                 <asp:TemplateField  HeaderText="Accept">
            <ItemTemplate>
                <asp:RadioButton ID="Accept" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" style="text-align:center"/>
            </ItemTemplate>
        </asp:TemplateField>
                  <asp:TemplateField  HeaderText="Reject">
            <ItemTemplate >
                <asp:RadioButton ID="Reject" runat="server" GroupName="re_ac_re" onclick="javascript:CheckOtherIsCheckedByGVIDMore(this);" style="align-content:center;"/>
            </ItemTemplate>
        </asp:TemplateField>
                 
                 
               
             

                </Columns>
                
   
    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left"  VerticalAlign="Middle"  Wrap="FALSE"  />
    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif"  />
    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
   
            </asp:GridView>

    <br />
    
         <p style="text-align:right  "><asp:Button ID="Button5" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"  Width="150px" OnClientClick="return confirm('Please confirm');"/></p>
</asp:Content>
