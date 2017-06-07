/* A servlet that acts as the movie list page. */

import movies.Constants;
import movies.Movie;
import movies.Star;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class Checkout extends HttpServlet {

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

            //Get POST variables
            String creditCardNumber = request.getParameter("creditCardNumber");
            String expirationDate = request.getParameter("expirationDate");
            String firstNameOnCard = request.getParameter("firstNameOnCard");
            String lastNameOnCard = request.getParameter("lastNameOnCard");

            //If any parameter is null or is a string of length 0, then error occurs
            boolean error = false;
            if (creditCardNumber == null || creditCardNumber.length() == 0){
                error = true;
            }
            if (expirationDate == null || expirationDate.length() == 0){
                error = true;
            }
            if (firstNameOnCard == null || firstNameOnCard.length() == 0){
                error = true;
            }
            if (lastNameOnCard == null || lastNameOnCard.length() == 0){
                error = true;
            }
            if (error){
                out.println("<script> alert('Please provide customer checkout information!'); </script>");
                out.println("<script> window.location.replace('../checkout.jsp'); </script>");
            }

            //Create a statement
            Statement statement = dbcon.createStatement();

            //Query to execute
            String query = "SELECT * from creditcards where id = '" + creditCardNumber + "' and expiration = '" + expirationDate + "' and first_name='" + firstNameOnCard + "' and last_name = '" + lastNameOnCard + "';";

            //Execute the query
            ResultSet rs = statement.executeQuery(query);

            if (!rs.isBeforeFirst() ) {
                out.println("<script> alert('Incorrect credit card information!'); </script>");
                out.println("<script> window.location.replace('../checkout.jsp'); </script>");
            } else {
                //Prepared Statement
                PreparedStatement ps;
                String psQuery = "insert into sales(customer_id,movie_id,sale_date) values(?,?,?)";
                ps = dbcon.prepareStatement(psQuery);

                //Get the current date
                DateFormat df = new SimpleDateFormat("yy-MM-dd");
                Date dateobj = new Date();
                String saleDate = df.format(dateobj);

                //Iterate through shopping cart and use prepared statement to store each sale
                ArrayList<Movie> shoppingCart = new ArrayList<Movie>();
                if (session.getAttribute("shoppingCart") != null){
                    shoppingCart = (ArrayList<Movie>)session.getAttribute("shoppingCart");
                    for (int i = 0; i < shoppingCart.size(); i++){
                        for (int j = 0; j < Integer.parseInt(shoppingCart.get(i).quantity); j++) {
                            ps.setString(1, customerId);
                            ps.setString(2, shoppingCart.get(i).id);
                            ps.setString(3, saleDate);
                            int updateResult = ps.executeUpdate();
                        }
                    }
                }

                //Close the prepared statement
                ps.close();

                //Redirect user to confirmation page
                out.println("<script> window.location.replace('../confirmation.jsp'); </script>");
            }

            //Close the statement
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
