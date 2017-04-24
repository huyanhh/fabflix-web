<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Main</title>
    <link rel="stylesheet" href="css/main.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,700" rel="stylesheet">
</head>
<body class="align">
<div class="grid welcome">
    <div class="text--center">
        <% out.println("<h1 id='welcome'>Welcome back, " + customerFirstName + " " + customerLastName + "</h1>"); %>
    </div>
    <div class="cell text--center">
        <span><a href="search.jsp">Search</a></span>
        <span><a href="browse.jsp">Browse</a></span>
    </div>
    <div class="cell footer text--center">
        <a href="servlet/Logout">Logout</a>
    </div>
</div>
</body>
</html>
