<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="WebForm6.aspx.vb" Inherits="Database_1.WebForm6" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style type="text/css">
        body {
            font-family: Arial;
            font-size: 10pt;
        }
        /*table
    {
        border: 1px solid #ccc;
    }
    table th
    {
        background-color: #F7F7F7;
        color: #333;
        font-weight: bold;
    }
    table th, table td
    {
        padding: 5px;
        border-color: #ccc;
    }*/
        .Pager span {
            color: #333;
            background-color: #F7F7F7;
            font-weight: bold;
            text-align: center;
            display: inline-block;
            width: auto;
            margin-right: 3px;
            line-height: 150%;
            border: 1px solid #ccc;
            padding: 0px 4px 0px 4px;
        }

        .Pager a {
            text-align: center;
            display: inline-block;
            width: auto;
            border: 1px solid #ccc;
            color: #fff;
            color: #333;
            margin-right: 3px;
            line-height: 150%;
            text-decoration: none;
            padding: 0px 4px 0px 4px;
        }

        .highlight {
            background-color: #ffc0c0;
        }
    </style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    
   
    <script type="text/javascript">
     
        $(function () {
            GetCustomers(1);
        });
        $("[id*=txtSearch]").live("keyup", function () {
            GetCustomers(parseInt(1));
        });
        $(".Pager .page").live("click", function () {
            GetCustomers(parseInt($(this).attr('page')));
        });
        function SearchTerm() {
            return jQuery.trim($("[id*=txtSearch]").val());
        };
        function GetCustomers(pageIndex) {
            $.ajax({
                type: "POST",
                url: "WebForm5.aspx/GetCustomers",
                data: '{searchTerm: "' + SearchTerm() + '", pageIndex: ' + pageIndex + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        }
        var row;
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var customers = xml.find("Customers");
            if (row == null) {
                row = $("[id*=gvCustomers] tr:last-child").clone(true);
            }
            $("[id*=gvCustomers] tr").not($("[id*=gvCustomers] tr:first-child")).remove();
            if (customers.length > 0) {
                $.each(customers, function () {
                    var customer = $(this);
                    $("td", row).eq(0).html($(this).find("CMPNY_NM").text());
                    //$("td", row).eq(1).html($(this).find("CMPNY_ADDR_1").text());
                    //$("td", row).eq(2).html($(this).find("CMPNY_CITY").text());
                    //$("td", row).eq(3).html($(this).find("CMPNY_ST").text());
                    //$("td", row).eq(4).html($(this).find("CMPNY_ZIP").text());
                    //$("td", row).eq(5).html($(this).find("PDI_CMPNY_ID").text());

                    $("[id*=gvCustomers]").append(row);
                    row = $("[id*=gvCustomers] tr:last-child").clone(true);
                });
                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });

                $(".CMPNY_NM").each(function () {
                    var searchPattern = new RegExp('(' + SearchTerm() + ')', 'ig');
                    $(this).html($(this).text().replace(searchPattern, "<span class = 'highlight'>" + SearchTerm() + "</span>"));
                });
            } else {
                var empty_row = row.clone(true);
                $("td:first-child", empty_row).attr("colspan", $("td", row).length);
                $("td:first-child", empty_row).attr("align", "center");
                $("td:first-child", empty_row).html("No records found for the search criteria.");
                $("td", empty_row).not($("td:first-child", empty_row)).remove();
                $("[id*=gvCustomers]").append(empty_row);
            }
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    Search:
    <asp:TextBox ID="txtSearch" runat="server" Width="200px" />
    <hr />
    <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false" GridLines="Horizontal" CellPadding="5" BorderStyle="None" BorderWidth="1px" Style="font-family: Helvetica; width: 100%; grid-area: auto;">
    <Columns>  <asp:TemplateField>
    <ItemTemplate>
       <table style="border-collapse: collapse; vertical-align: top;">
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td colspan="2">Price Detail</td>

                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td colspan="2">
                            <asp:Label ID="PRODUCT_ID" runat="server" Text='<%# Eval("CMPNY_NM") %>' />
                            - 
                                    <asp:Label ID="PRODUCT_DESCRIPTION" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Current Price</td>
                        <td style="width: 20%">$<asp:Label ID="cur_pri" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">List Price</td>
                        <td style="width: 20%">$<asp:Label ID="Li_pri" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Rolling 6-Month ASP</td>
                        <td style="width: 20%">$<asp:Label ID="ASP6" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Rolling 12-Month ASP</td>
                        <td style="width: 20%">$<asp:Label ID="ASP12" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Vizient Tier 1</td>
                        <td style="width: 20%">$<asp:Label ID="vt1" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Vizient Tier 2</td>
                        <td style="width: 20%">$<asp:Label ID="vt2" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Amerient Tier 1</td>
                        <td style="width: 20%">$<asp:Label ID="at1" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Amerient Tier 2</td>
                        <td style="width: 20%">$<asp:Label ID="at2" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">HPG</td>
                        <td style="width: 20%">$<asp:Label ID="HPG" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Premier</td>
                        <td style="width: 20%">$<asp:Label ID="Pre" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">MFG 1</td>
                        <td style="width: 20%">$<asp:Label ID="mfg1" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">MFG 2</td>
                        <td style="width: 20%">$<asp:Label ID="MFG2" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray; border-top: solid; border-top-color: Gray;">
                        <td style="width: 80%">Volume Detail</td>
                        <td style="width: 20%">(<asp:Label ID="Vol_det" runat="server" Text="" />cs)</td>

                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Buyer</td>
                        <td style="width: 20%">
                            <asp:Label ID="Buyer" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Vizient</td>
                        <td style="width: 20%">
                            <asp:Label ID="viz" runat="server" Text="" /></td>
                    </tr>
                    <tr style="border-bottom: solid; border-bottom-color: Gray;">
                        <td style="width: 80%">Amerinet</td>
                        <td style="width: 20%">
                            <asp:Label ID="Amer" runat="server" Text="" /></td>


                </table>
           


       
            
        </ItemTemplate>
</asp:TemplateField></Columns> 
        <%--<PagerStyle BackColor="White" ForeColor="#cccccc" HorizontalAlign="Right" />--%>
        <RowStyle Font-Names="Helvetica"  Font-Size="14px"/>
        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
    </asp:GridView>
    <br />
    <div class="Pager">
    </div>
    <script src="ASPSnippets_Pager.min.js" type="text/javascript"></script>
</asp:Content>
 <%--<asp:BoundField HeaderStyle-Width="150px" DataField="CMPNY_NM" 
                ItemStyle-CssClass="CMPNY_NM" />
            <asp:BoundField HeaderStyle-Width="150px" DataField="CMPNY_ADDR_1"  />
            <asp:BoundField HeaderStyle-Width="150px" DataField="CMPNY_CITY"  />
            <asp:BoundField HeaderStyle-Width="150px" DataField="CMPNY_ST"  />
            <asp:BoundField HeaderStyle-Width="150px" DataField="CMPNY_ZIP" />
            <asp:BoundField HeaderStyle-Width="150px" DataField="PDI_CMPNY_ID"  />--%>