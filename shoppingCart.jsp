<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="movies.Movie" %>
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

%>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
</head>
<body>

<div style = 'margin:0px auto; width:900px; text-align:center;'>

<h1>Shopping Cart</h1>

<%
    //need to change UI for this cuz it looks bad lol

    ArrayList<Movie> shoppingCart;
    if (session.getAttribute("shoppingCart") != null) {
        shoppingCart = (ArrayList<Movie>)session.getAttribute("shoppingCart");
        if (shoppingCart.size() == 0){
            out.println("No items in shopping cart.");
        } else {
            out.println("<table frame='vsides' cellspacing='20' width='500px' align='center'>");
            out.println("<tr><td></td><td><b>Title</b><td><b>Year</b></td><td><b>Quantity</b></td></tr>");
            for (int i = 0; i < shoppingCart.size(); i++) {
                out.println("<tr>");
                out.println("<td valign='top' width='50'><img width='50' height='70' border='0' src='" + shoppingCart.get(i).bannerURL + "'></td>");
                out.println("<td valign='top'><a href='#'><strong>" + shoppingCart.get(i).title + "</strong></a></td>");
                out.println("<td valign='top' width='45'>" + shoppingCart.get(i).year + "</td>");
                out.println("<td valign='top' width='40'>" + shoppingCart.get(i).quantity + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        out.println("<a href = 'checkout.jsp'>Proceed to checkout</a>");
    } else {
        out.println("No items in shopping cart.");
    }
%>

</div>

</body>
</html>