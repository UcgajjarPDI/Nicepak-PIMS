<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Create_Alike.aspx.vb" Inherits="Database_1.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <style type="text/css">
        .auto-style1 {
            width: 100%;
            table-layout: fixed;
            margin-top: 0px;
        }
    </style>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table style="width:45%;" >
    <tr>
        <td>
    <div >
          <div style="text-align:center; border-bottom:medium;border-bottom-color:gray; border-bottom-style:solid ">
          <p style="font-family: Helvetica;  color:#843C0C;font-size:24px;">New Contract Request</p>
              
          </div>
          <table style="font-family: Helvetica;" class="auto-style1">
              <tr >
                  <td >Initiator: </td>
                  <td >
                      <asp:Label ID="Initiator" runat="server" ></asp:Label></td>
                  <td ></td>
                 <td ></td>
                  <td >Buyer Group:</td>
               <td > <asp:Label ID="BG_NM" runat="server" ></asp:Label></td>
                  <td ></td>
                 <td ></td>
                  <td >Distributor:</td>
                   <td >Cardinal Health</td>
              </tr>
              <tr >
                  <td></td>
                 <td><asp:Label ID="Org_Role" runat="server" ></asp:Label></td>
                  <td ></td>
                 <td ></td>
                  <td ></td>
                  <td ><asp:Label ID="BG_ADDR1" runat="server" ></asp:Label></td>
                  <td ></td>
                  <td ></td>
                  <td ></td>
                   <td >7000 Cardinal Place</td>
                 
              </tr>
              <tr >
                  <td ></td>
                 <td ><asp:Label ID="Region" runat="server" ></asp:Label></td>
                  <td ></td>
                  <td ></td>
                   <td ></td>
                   <td ><asp:Label ID="BG_CITY_ST_ZIP" runat="server"></asp:Label></td>
                   <td ></td>
                  <td ></td>
                  <td ></td>
                   <td >Dublin, OH 43017</td>

              </tr>
               <tr >
                  <td></td>
                  <td><asp:Label ID="RD" runat="server"></asp:Label></td>
                   <td ></td>
                  <td ></td>
                   <td ></td>
                   <td ></td>
                      <td ></td>
                  <td ></td>
                  <td >&nbsp;</td>
                   <td ></td>

              </tr>
          </table>


    </div>
    <div>



   <div style="text-align:left">
           <%-- <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="4"  DataKeyNames="CNT_NR"  BorderStyle="None" BorderWidth="1px" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" >--%>
              <p style="font-family: Helvetica;  color:#843C0C;font-size:24px;">Code Request</p> 
        <asp:GridView ID="gd1" runat="server"  AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="5"  DataKeyNames="CNT_NR" BorderStyle="None" BorderWidth="1px" style="font-family: Helvetica; "    >
            <Columns>
                    <asp:TemplateField>
                       
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Product">
            <ItemTemplate>
                <asp:Label ID="PROD" runat="server" Text='<%# Eval("PRODUCT") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Product Desc">
            <ItemTemplate>
                <asp:Label ID="pr_ds" runat="server" Text='<%# Eval("Product_Desc") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                <asp:TemplateField  HeaderText="Price Request">
            <ItemTemplate>
               <asp:TextBox ID="pr_rq" runat="server"></asp:TextBox>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Current Price">
            <ItemTemplate>
                <asp:Label ID="cu_pr" runat="server" Text='<%# Eval("CURR_PRC") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                      <asp:TemplateField  HeaderText="List Price">
            <ItemTemplate>
                <asp:Label ID="li_pr" runat="server" Text='<%# Eval("LIST_PRICE") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Current CS Volume">
            <ItemTemplate>
                <asp:Label ID="cu_vol" runat="server" Text='<%# Eval("CURR_VOL") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Rolling 6-Month ASP">
            <ItemTemplate>
                <asp:Label ID="rl_6asp" runat="server" Text='<%# Eval("ASP6") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
               
                    <asp:TemplateField  HeaderText="Rolling 12-Month ASP">
            <ItemTemplate>
                <asp:Label ID="rl_12asp" runat="server" Text='<%# Eval("ASP12") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
              
                    <asp:TemplateField  HeaderText="Vizient Pricing">
            <ItemTemplate>
                <asp:Label ID="vz_pr" runat="server" Text='<%# Eval("VIZ_PRC") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
               
                    <asp:TemplateField  HeaderText="Amerinet Tier 1">
            <ItemTemplate>
                <asp:Label ID="am_ti1" runat="server" Text='<%# Eval("AMERI_TIER_1") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                
                    <asp:TemplateField  HeaderText="Amerinet Tier 2">
            <ItemTemplate>
                <asp:Label ID="am_ti2" runat="server" Text='<%# Eval("AMERI_TIER_2") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                
                    <asp:TemplateField  HeaderText="HPG pricing">
            <ItemTemplate>
                <asp:Label ID="Ehg_pr" runat="server" Text='<%# Eval("HPG_PRC") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
               
                    <asp:TemplateField  HeaderText="12-Month ASP Var">
            <ItemTemplate>
                <asp:Label ID="ASP_Var_12" runat="server" Text=""></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                       <asp:TemplateField  HeaderText="6-Month ASP var">
            <ItemTemplate>
                <asp:Label ID="ASP_Var_06" runat="server" Text=""></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                </Columns>
                
   
    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left"  VerticalAlign="Middle"  Wrap="FALSE"  />
    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
            <RowStyle Font-Names="Helvetica"  />
    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
   
            </asp:GridView>

       <br />
        <div style="text-align:right">
           
        
         
         
       
       
         <asp:Button ID="Button2" runat="server" Text="Bookmark" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"/>
            &nbsp&nbsp&nbsp&nbsp&nbsp
          <asp:Button ID="Button1" runat="server" Text="Submit" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"   Width="150px"/>
            </div>
       </div>

      </div></td>
    </tr>
        </table> 
</asp:Content>
