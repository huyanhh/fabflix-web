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
<!DOCTYPE html>
<html>
<head>
    <title>Search</title>
</head>
<body>

<h1>Search Page</h1>

<form action = "/servlet/MovieList" action = "get">
    <input type = "text" name = "movieTitle" placeholder = "movies.Movie Title"> <br>
    <input type = "text" name = "movieYear" placeholder = "movies.Movie Year"> <br>
    <input type = "text" name = "movieDirector" placeholder = "movies.Movie Director"> <br>
    <input type = "text" name = "starFirstName" placeholder = "Star's First Name"> <br>
    <input type = "text" name = "starLastName" placeholder = "Star's Last Name"> <br>
    <input type = "submit" value = "Search">
</form>

</body>
</html>