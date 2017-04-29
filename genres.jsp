<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
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

%>
<!DOCTYPE html>
<html>
<head>
    <title>Genres</title>
</head>
<body>

<h1>Browse By movies.Movie Genres Page</h1>

<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false", Constants.USER, Constants.PASSWORD);
    Statement select = connection.createStatement();
    ResultSet result = select.executeQuery("select *  from genres; ");

    while (result.next()){
        String genre = result.getString("name");
        out.println("<a href = '/servlet/MovieList?movieGenre=" + genre + "'>" + genre + "</a><br>");
    }

    result.close();
    select.close();

%>

</body>
</html>