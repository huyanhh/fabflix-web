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

    //Get shopping cart
    ArrayList<Movie> shoppingCart = new ArrayList<Movie>();
    if (session.getAttribute("shoppingCart") != null){
        shoppingCart = (ArrayList<Movie>)session.getAttribute("shoppingCart");
    }

%>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-cfe6975aa5.css">
</head>
<body>

<div style = "margin-top:100px;">
    <div style = "margin:0px auto; width:500px; text-align:center;">
        <h2> Customer Information </h2>
        <div style = "margin:0px auto; width:330px; border:1px solid #cfcfcf; border-radius:5px; padding:15px 15px 15px 15px;">
            <form action = "/servlet/Checkout" method="post">
                <div class = "form-group">
                    <input type = "text" name = "creditCardNumber" class = "form-control" placeholder="Credit Card Number">
                </div>
                <div class = "form-group">
                    <input type = "text" name = "expirationDate" class = "form-control" placeholder="Expiration Date">
                </div>
                <div class = "form-group">
                    <input type = "text" name = "firstNameOnCard" class = "form-control" placeholder="First Name on Card">
                </div>
                <div class = "form-group">
                    <input type = "text" name = "lastNameOnCard" class = "form-control" placeholder="Last Name on Card">
                </div>
                <div style = "text-align:right;">
                    <input type = "submit" value = "Checkout" class = "btn btn-primary">
                </div>
            </form>
        </div>
        <div style = "text-align:center; margin-top:15px; font-size:140%;">
            <a href = "shoppingCart.jsp"> Back </a>
        </div>
    </div>
</div>

</body>
</html>
