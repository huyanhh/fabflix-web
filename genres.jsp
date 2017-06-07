<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<%@ page import="movies.Constants" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
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
    //Connection pooling
    Context initCtx = new InitialContext();
    if (initCtx == null)
        out.println("initCtx is NULL");

    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    if (envCtx == null)
        out.println("envCtx is NULL");

    //Look up data source
    DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");

    //Establish connection with data source
    if (ds == null)
        out.println("ds is null.");

    Connection connection = ds.getConnection();
    if (connection == null)
        out.println("connection is null.");
        
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
