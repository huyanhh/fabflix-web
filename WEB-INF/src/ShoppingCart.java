/* A servlet that acts as the movie list page. */

import movies.Constants;
import movies.Movie;
import movies.Star;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShoppingCart extends HttpServlet {

    public String getServletInfo() {
        return "Servlet that acts as the movie list page.";
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

            //Get GET parameters
            String movieQuantity = request.getParameter("movieQuantity");
            String movieId = request.getParameter("movieId");

            //Iterate through shopping cart, find movie with movieId and update quantity. If quantity is 0, remove.
            ArrayList<Movie> shoppingCart;
            if (session.getAttribute("shoppingCart") != null) {
                shoppingCart = (ArrayList<Movie>) session.getAttribute("shoppingCart");
                for (int i = 0; i < shoppingCart.size(); i++) {
                    if (shoppingCart.get(i).id.equals(movieId)) {
                        shoppingCart.get(i).setQuantity(movieQuantity);
                        if (movieQuantity.equals("0")) {
                            shoppingCart.remove(i);
                        }
                        break;
                    }
                }
            }

            //Redirect to shopping cart page
            out.println("<script>window.location.replace('../shoppingCart.jsp');</script>");

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
