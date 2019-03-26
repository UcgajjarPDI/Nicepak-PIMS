<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ContractData.aspx.vb" Inherits="Database_1.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link rel="stylesheet" type="text/css" href="appStyle.css">    
<script src="Scripts/jquery-1.7.1.js"></script>
<script language="javascript" type="text/javascript">
 <%--   function SelectAllCheckboxes(chk) {
        var totalRows = $("#<%=GridView1 %> tr").length;
        var selected = 0;
        $('#<%=GridView1.ClientID %>').find("input:checkbox").each(function () {
            if (this != chk) {
                this.checked = chk.checked;
                selected += 1;
            }
        });
    }
 --%>
    function CheckedCheckboxes(chk) {
        if (chk.checked) {
            var totalRows = $('#<%=gd1.ClientID %> :checkbox').length;
            var checked = $('#<%=gd1.ClientID %> :checkbox:checked').length
            if (checked == (totalRows - 1)) {
                $('#<%=gd1.ClientID %>').find("input:checkbox").each(function () {
                    this.checked = true;
                });
            }
            else {
                $('#<%=gd1.ClientID %>').find('input:checkbox:first').removeAttr('checked');
            }
        }
        else {
            $('#<%=gd1.ClientID %>').find('input:checkbox:first').removeAttr('checked');
        }
    }       
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ViewStateMode="Inherit">



         <%--<div id="reccnt">
            <asp:Label ID="msgLabel" runat ="server"></asp:Label>
        </div>--%>
       <%-- <div id="ContractData">
            <asp:Repeater ID="CntRepeater" runat="server">
                <HeaderTemplate>
                    <table id="dataTable">
                        <tr>
                            <th><strong>Contract Nr</strong></th>
                            <th><strong>Effective Date</strong></th>
                            <th><strong>Expiration Date</strong></th>
                            <th><strong>Contract Type</strong></th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                        <tr>
                            <td><asp:CheckBox ID="select_co" runat="server" Text='<%# Eval("CNT_NR") %>'/></td>
                            <td><%# Eval("CNT_EFF_DT") %></td>
                            <td><%# Eval("CNT_EXP_DT") %></td>
                            <td><%# Eval("CNT_TYP_CD") %></td>
                        </tr>        
                </ItemTemplate>
                <FooterTemplate>
                    </table> 
                </FooterTemplate>
            </asp:Repeater> --%>

           
            <br />
    <div style="text-align:left">
        <asp:Label ID="ac_it" runat="server" Text="Action Items" style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;  color:#843C0C;font-size:24px;" Visible ="false"></asp:Label>
         <%-- <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;  color:#843C0C;font-size:24px;"   >Action Items</p> --%>
        <asp:GridView ID="gd2" runat="server"  OnSelectedIndexChanged="gd2_SelectedIndexChanged" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8"   BorderStyle="None" BorderWidth="1px" style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;width:100%; grid-area:auto;" >
            <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>                    
                       &nbsp;&nbsp; <asp:CheckBox ID="chkCheckAll1" runat="server" onclick=""  />
                </HeaderTemplate>
                        <ItemTemplate>
                &nbsp;&nbsp;<asp:CheckBox ID="chkCheck2" runat="server" onclick="j" />
                            <%--<asp:RadioButton ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />--%>
            </ItemTemplate>
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Contract #">
            <ItemTemplate>
                <asp:Label ID="co1" runat="server" Text='<%# Eval("CNT_NR") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Buyer Group">
            <ItemTemplate>
                <asp:Label ID="BY_GR1" runat="server" Text='<%# Eval("GRP_SHRT_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Initiated By">
            <ItemTemplate>
                <asp:Label ID="in_us" runat="server" Text='<%# Eval("INIT_USR_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                      <asp:TemplateField  HeaderText="Status">
            <ItemTemplate>
                <asp:Label ID="cnt_stat" runat="server" Text='<%# Eval("CNT_STAT_CD") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Action Requested">
            <ItemTemplate>
                <asp:Label ID="cnt_typ" runat="server" Text='<%# Eval("CNT_TYP_CD") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Complete By">
            <ItemTemplate>
                <asp:Label ID="Comp_gr_id" runat="server" Text='<%# Eval("CNT_RVW_DL_DT") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                </Columns>
                
   
    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left"  VerticalAlign="Middle"  Wrap="FALSE"  />
    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif"  />
    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
   
            </asp:GridView>
        </br>
          <div style="text-align:right">
           
        
         
         
       
         <asp:Button ID="Button5" runat="server" Text="Respond" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"  Width="150px"/>
              </div>

    </div>
    <div style="text-align:left">
              <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;  color:#843C0C;font-size:24px;"   >Active Contracts</p> 
        <asp:GridView ID="gd1" runat="server" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="8"  DataKeyNames="CNT_NR"  BorderStyle="None" BorderWidth="1px" style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;width:100%; grid-area:auto;" >
            <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>                    
                       &nbsp;&nbsp; <asp:CheckBox ID="chkCheckAll" runat="server" onclick=""  />
                </HeaderTemplate>
                        <ItemTemplate>
                &nbsp;&nbsp;<asp:CheckBox ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />
            </ItemTemplate>
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Contract #">
            <ItemTemplate>
                <asp:Label ID="co" runat="server" Text='<%# Eval("CNT_NR") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Buyer Group">
            <ItemTemplate>
                <asp:Label ID="BY_GR" runat="server" Text='<%# Eval("GRP_SHRT_NM") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField  HeaderText="Contract Type">
            <ItemTemplate>
                <asp:Label ID="CO_TY" runat="server" Text='<%# Eval("CNT_TYP_CD") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                      <asp:TemplateField  HeaderText="Tier Number">
            <ItemTemplate>
                <asp:Label ID="TI_NO" runat="server" Text='<%# Eval("CNT_TIER_LVL") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Effective Date">
            <ItemTemplate>
                <asp:Label ID="EF_DT" runat="server" Text='<%# Eval("CNT_EFF_DT") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:TemplateField  HeaderText="Expiration Date">
            <ItemTemplate>
                <asp:Label ID="EX_DT3" runat="server" Text='<%# Eval("CNT_EXP_DT") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
                </Columns>
                
   
    <HeaderStyle BackColor="#808080" Font-Bold="True" ForeColor="White" Font-Overline="false" HorizontalAlign="Left"  VerticalAlign="Middle"  Wrap="FALSE" Width="500PX" />
    <PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />
            <RowStyle Font-Names="Trebuchet MS, Arial, Helvetica, sans-serif"  />
    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
   
            </asp:GridView>

           
            <br />
            <br />
     <div style="text-align:right">
           
        
         
         
       
       
         <asp:Button ID="Button3" runat="server" Text="Update" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"/>
         &nbsp&nbsp&nbsp&nbsp&nbsp
         <asp:Button ID="Button2" runat="server" Text="Create New" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None" Width="150px"/>
            &nbsp&nbsp&nbsp&nbsp&nbsp
          <asp:Button ID="Button1" runat="server" Text="Create Alike" BackColor="#843c0c" Font-Size="Medium" ForeColor="White" BorderColor="#843C0C" BorderStyle="None"   Width="150px"/>
            </div>
       
        </div>


</asp:Content>
