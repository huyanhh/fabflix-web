/* A servlet that acts as the movie list page. */

import movies.Constants;
import movies.Movie;
import movies.Star;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AjaxSearch extends HttpServlet {

    public String getServletInfo() {
        return "Servlet for handling search AJAX requests.";
    }

    // Use http GET

    @SuppressWarnings("unchecked")
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        //Start the session
        HttpSession session = request.getSession(true);

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

        //Get session attributes
        String customerId = (String)session.getAttribute("customerId");
        String customerFirstName = (String)session.getAttribute("customerFirstName");
        String customerLastName = (String)session.getAttribute("customerLastName");
        String loggedIn = (String)session.getAttribute("loggedIn");

        //Check to see if the user has logged in. If not, redirect user to the login page.
        if (loggedIn == null){
            out.println("<script> window.location.replace('../index.html'); </script>");
        }

        String loginUser = Constants.USER;
        String loginPasswd = Constants.PASSWORD;
        String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

        response.setContentType("text/html");    // Response mime type

        try
        {
            //Class.forName("org.gjt.mm.mysql.Driver");
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            //Connect to the database
            Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

            //Declare statement
            Statement statement = dbcon.createStatement();

            //Store movie title passed as GET variable
            String movieTitle = request.getParameter("movieTitle");

            //Because title may have spaces, split by spaces, append a + to beginning of each string and * to end. Then append all
            String[] splitTitle = movieTitle.split("\\s+");
            String newMovieTitle = "";
            for (int i = 0; i < splitTitle.length; i++){
                newMovieTitle += "+";
                newMovieTitle += splitTitle[i];
                newMovieTitle += "* ";
            }
            movieTitle = newMovieTitle;

            //Query database to find movie results with the corresponding title (Uses Full-Text search)
            String query = "select * from movies where match(title) against('" + movieTitle + "' in boolean mode)";
            ResultSet rs = statement.executeQuery(query);

            //Print movie results
            while (rs.next()) {
                String resultId = rs.getString("id");
                String resultTitle = rs.getString("title");
                out.println("<a href = 'movie.jsp?id=" + resultId + "'>" + resultTitle + "</a><br>");
            }

            //Close result set
            rs.close();
            
            //Close statement
            statement.close();

            //Close database connection
            dbcon.close();
        }
        catch (SQLException ex) {
            while (ex != null) {
                System.out.println ("SQL Exception:  " + ex.getMessage ());
                ex = ex.getNextException ();
            }
        }
        catch(java.lang.Exception ex) {
            out.println("<HTML><HEAD><TITLE>MovieDB: Error</TITLE></HEAD>\n<BODY><P>SQL error in doGet: " + ex.getMessage() + "</P></BODY></HTML>");
            return;
        }
        out.close();
    }

    @SuppressWarnings("unchecked")
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        doGet(request, response);
    }


}
