/* A servlet that acts as the movie list page. */

import movies.Constants;
import movies.Movie;
import movies.Star;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

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

        response.setContentType("text/html");    // Response mime type

        try
        {
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

            Connection dbcon = ds.getConnection();
            if (dbcon == null)
                out.println("dbcon is null.");

            //Declare Prepared Statement
            PreparedStatement ps;

            //Store movie title passed as GET variable
            String movieTitle = request.getParameter("movieTitle");

            //Because title may have spaces, split by spaces, append a + to beginning of each string and * to end. Then append all
            String[] splitTitle = movieTitle.split("\\s+");
            String newMovieTitle = "";
            for (int i = 0; i < splitTitle.length; i++){
                newMovieTitle += "+" + splitTitle[i];
                if (i == splitTitle.length - 1){
                  newMovieTitle += "*";
                } else {
                  newMovieTitle += " ";
                }
            }

            //Query database to find movie results with the corresponding title (Uses Full-Text search)
            String query = "select * from movies where match(title) against(? in boolean mode)";
            ps = dbcon.prepareStatement(query);
            ps.setString(1,newMovieTitle);
            ResultSet rs = ps.executeQuery();

            //Print movie results
            int resultCount = 0;
            while (rs.next()) {
                String resultId = rs.getString("id");
                String resultTitle = rs.getString("title");
                out.println("<a href = 'movie.jsp?id=" + resultId + "'>" + resultTitle + "</a><br>");
                resultCount++;
            }

            if (resultCount == 0){
              out.println("No results found...");
            }

            //Close result set
            rs.close();

            //Close the Prepared Statement
            ps.close();

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
