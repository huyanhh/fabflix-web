<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="movies.Movie" %>
<%@ page import="movies.Constants" %>
<%

    //Get session attributes
    String customerId = (String)session.getAttribute("customerId");
    String customerFirstName = (String)session.getAttribute("customerFirstName");
    String customerLastName = (String)session.getAttribute("customerLastName");
    String loggedIn = (String)session.getAttribute("loggedIn");

    //Check to see if the user has logged in. If not, redirect user to the login page.
    if (loggedIn == null){
        out.println("<script> window.location.replace('index.html'); </script>");
    }

    //Get total movie quantity in shopping cart
    int totalQuantity = 0;
    ArrayList<Movie> shoppingCart = new ArrayList<Movie>();
    if (session.getAttribute("shoppingCart") != null){
        shoppingCart = (ArrayList<Movie>)session.getAttribute("shoppingCart");
        for (int i = 0; i < shoppingCart.size(); i++){
            totalQuantity += Integer.parseInt(shoppingCart.get(i).quantity);
        }
    }

%>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
    <link rel="stylesheet" type="text/css" href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-0761696b57.css">
</head>
<body onload=" " class="page-common">
<div id="myanimelist">
    <div class="wrapper">
        <div id="headerSmall" style="background: url(../resources/logo_small.png) center top no-repeat rgba(0, 0, 0, 0)">
            <a href="/" class="link-mal-logo">Fabflix</a>
        </div>
        <div id="menu" class="">
            <div id="menu_left">
                <ul id="nav">
                    <li class="small">
                        <%--Must be ../ because the current path is servlet/--%>
                        <a href="../search.jsp" class="non-link">Search</a>
                    </li>
                    <li class="small">
                        <a href="../browse.jsp" class="non-link">Browse</a>
                    </li>
                    <%
                        if (totalQuantity < 10){
                            out.println("<li class=\"large\" style = 'width:160px;'>");
                        } else if (totalQuantity < 100){
                            out.println("<li class=\"large\" style = 'width:170px;'>");
                        } else if (totalQuantity < 1000){
                            out.println("<li class=\"large\" style = 'width:180px;'>");
                        } else if (totalQuantity < 10000){
                            out.println("<li class=\"large\" style = 'width:190px;'>");
                        } else {
                            out.println("<li class=\"large\" style = 'width:200px;'>");
                        }
                    %>
                    <a href="../shoppingCart.jsp" class="non-link">Checkout (<% out.println(totalQuantity); %> items) </a>
                    </li>
                    <li class="small">
                        <a href="/servlet/Logout" class="non-link">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="contentWrapper" itemscope="" itemtype="http://schema.org/Product">
            <div><h1 class="h1">Shopping Cart</h1></div>
            <div id="content">

                <div class="js-categories-seasonal js-block-list list">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>

                        <%
                            if (session.getAttribute("shoppingCart") == null){
                                out.println("<tr><td><div style = 'margin-top:5px;'>No items in shopping cart.</div></td></tr>");
                            } else {
                                if (shoppingCart.size() == 0){
                                    out.println("<tr><td><div style = 'margin-top:5px;'>No items in shopping cart.</div></td></tr>");
                                } else {
                                    for (int i = 0; i < shoppingCart.size(); i++) {
                                        out.println("<tr>");
                                        out.println("<td class=\"borderClass bgColor0\" valign=\"top\" width=\"50\">");
                                        out.println("<img width=\"50\" height=\"70\" border=\"0\" src=\"" + shoppingCart.get(i).bannerURL + "\">");
                                        out.println("</td>");
                                        out.println("<td class=\"borderClass bgColor0\" valign=\"top\">" +
                                                "<a href=../movie.jsp?id=" + shoppingCart.get(i).id + ">" +
                                                "<strong>" +
                                                shoppingCart.get(i).title + "</strong>" +
                                                "</a>");

                                        out.println("<td class=\"borderClass ac bgColor0\" width=\"45\"></td>");
                                        out.println("<td class=\"borderClass ac bgColor0\" width=\"40\">");
                                        out.println("<form action = '/servlet/ShoppingCart' method = 'get'>");
                                        out.println("<input type = 'text' name = 'movieQuantity' value = '" + shoppingCart.get(i).quantity + "' maxlength = '4' size = '4' style = 'text-align:center;'>");
                                        out.println("<input type = 'hidden' value = '" + shoppingCart.get(i).id + "' name = 'movieId'>");
                                        out.println("</td><td class=\"borderClass ac bgColor0\" width=\"50\"> <input type = 'submit' value = 'Update Cart'></form> </td>");
                                        out.println("</tr>");
                                    }
                                }
                            }
                        %>

                        </tbody>
                    </table>
                    <%
                        if (totalQuantity > 0) {
                            out.println("<div style = 'margin:0px auto; width:200px; text-align:center;'><div style = 'margin-top:10px;'><a href = 'checkout.jsp'> Proceed to Checkout</a></div></div>");
                        }
                    %>
                </div>

            </div>

        </div>
    </div>

</div>

<script>
    var header = {
        alphabet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    };

    function makeUL(string) {
        var list = document.createElement('ul');

        for (var i = 0; i < string.length; i++) {
            var item = document.createElement('li');
            var link = document.createElement('a');
            link.innerHTML = string.charAt(i);
            link.href = '/servlet/MovieList?movieTitle=' + string.charAt(i);

            item.appendChild(link);
            list.appendChild(item);
        }

        return list;
    }
    document.getElementById('horiznav_nav').appendChild(makeUL(header.alphabet));
</script>
</body>
</html>