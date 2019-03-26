<%@ Page Title="LogInPage" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="LogIn.aspx.vb" Inherits="Database_1.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ViewStateMode="Inherit">
    <header>
        <link rel="stylesheet" type="text/css" href="appStyle.css">
        </header>
   
    <div style=" vertical-align:top;margin-top:0px;">
        <br />
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
        <br />
        <asp:Label ID="Label1" runat="server" Font-Names="Trebuchet MS" ForeColor="#0066CC" Text="User ID" Font-Bold="True"></asp:Label>
        <br />
        <asp:TextBox ID="txtUNM" runat="server" class="input" Width="307px"> </asp:TextBox>
        <br />
        <br />
        <asp:Label ID="Label2" runat="server" Font-Names="Trebuchet MS" ForeColor="#0066CC" Text="Password" Font-Bold="True"></asp:Label>
        <br />
        <asp:TextBox ID="txtPWD" runat="server" class="input" Width="307px" TextMode="Password"></asp:TextBox>
        <br />
        <!-- <asp:Image ID="imgLogIn" runat="server" Height="32px" ImageAlign="Right" ImageUrl="~/img/Go.jpg" ToolTip="Log-in" Width="30px" onclick="imgLogIn_Click"/>-->
        <asp:Button ID="btnLogIn" runat="server" Text="Log In" CssClass="auto-style1" BackColor="#CCCCCC" ForeColor="#000099" style="height: 26px" />

        <br />
        <br />
    </div>
         
  
</asp:Content>
