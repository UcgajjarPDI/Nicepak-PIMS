<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Site_Admin.aspx.vb" Inherits="Database_1.Site_Admin" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 60%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">




    <div style="font-family: Helvetica; color: red; font-size: 20px;">NON EDI DATA LOAD</div>
    <br />
    <table style="border-top: solid; font-family: Helvetica; color: black; font-size: 18px; width: 60%">
        <tr>
            <td>Current Sales Period:                  </td>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            </td>
            <td>&nbsp;
            </td>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td>Reset to
            </td>
            <td>
                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="Button1" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="RESET" Width="100px" />
            </td>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td>Load Non-EDI Data for
            </td>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
            </td>
            <td>
                <asp:Button ID="Button5" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>
                <asp:Label ID="ERR" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>

    </table>
    <br />
    <div style="font-family: Helvetica; color: red; font-size: 20px;">EDI DATA TRANSFER</div>
    <br />
    <table style="font-family: Helvetica; color: black; font-size: 18px; border-top-style: solid; border-top-color: inherit; border-top-width: medium;" class="auto-style1">
        <tr>
            <td>EDI 845 IMPORT CONTRACT CHANGES
            </td>
            <td>

                <asp:TextBox ID="TextBox3" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            </td>
            <td>
                <asp:Button ID="Button2" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>
                <asp:Label ID="Label4" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>
        <tr>
            <td>EDI 845 IMPORT PRICE AUTHORIZATION CHANGES
            </td>
            <td>

                <asp:TextBox ID="TextBox4" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            </td>
            <td>
                <asp:Button ID="Button4" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>
                <asp:Label ID="Label5" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>
        <tr>
            <td>EDI 845 OUTPUT FTP
            </td>
            <td>

                <asp:TextBox ID="TextBox2" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            </td>
            <td>
                <asp:Button ID="Button3" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>
                <asp:Label ID="ERR_ftp" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">check on Files on ftp site</asp:Label></td>
        </tr>


    </table>
    <br />
    <div style="font-family: Helvetica; color: red; font-size: 20px;">GPO Membership Data Transfer</div>
    <br />
    `
           <table style="border-top: solid; font-family: Helvetica; color: black; font-size: 18px; width: 60%;">
               <tr>
                   <td>GPO Membership Roster
                   </td>
                   <td>

                       <asp:TextBox ID="TextBox5" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                   </td>
                   <td>
                       <asp:Button ID="Button6" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
                   </td>
                   <td>
                       <asp:Label ID="Label6" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
                   </td>
               </tr>
           </table>
    <br />
    <div style="font-family: Helvetica; color: red; font-size: 20px;">Price Authorization Data Transfer</div>
    <br />
    <table style="border-top: solid; font-family: Helvetica; color: black; font-size: 18px; width: 60%;">
        <tr>
            <td>Price Authorization
            </td>
            <td>

                <asp:TextBox ID="TextBox6" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            </td>
            <td>
                <asp:Button ID="Button7" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>
                <asp:Label ID="Label7" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <div style="font-family: Helvetica; color: red; font-size: 20px;">DHC Data Transfer</div>
    <br />
    <table style="border-top: solid; font-family: Helvetica; color: black; font-size: 18px; width: 60%;">
        <tr>
            <td>DHC (Hospital)
            </td>
            <td>

                <asp:TextBox ID="TextBox7" runat="server" Visible="False"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            </td>
            <td>
                <asp:Button ID="Button8" runat="server" BackColor="#843c0c" BorderColor="#843C0C" BorderStyle="None" Font-Size="Medium" ForeColor="White" OnClientClick="return confirm('Please confirm');" Text="Run" Width="100px" />
            </td>
            <td>

                <asp:Label ID="Label8" runat="server" Style="background-color: #A40000; border: none; font-family: Helvetica; color: white; font: bold;" Visible="false">Job Is Running</asp:Label>
            </td>
        </tr>
    </table>

</asp:Content>
