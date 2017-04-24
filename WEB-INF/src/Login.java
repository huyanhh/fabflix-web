
/* A servlet to check whether login information inputted by the user is correct. */

import com.sun.tools.internal.jxc.ap.Const;

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Login extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and determines if login information is correct";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        String loginUser = Constants.USER;
        String loginPasswd = Constants.PASSWORD;
        String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

        response.setContentType("text/html");    // Response mime type

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

        try
           {
              //Class.forName("org.gjt.mm.mysql.Driver");
              Class.forName("com.mysql.jdbc.Driver").newInstance();

              Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
              //Declare our statement
              Statement statement = dbcon.createStatement();

              //Get POST variables
	          String email = request.getParameter("email");
	          String password = request.getParameter("password");

	          //Query to execute
              String query = "SELECT * from customers where email = '" + email + "' and password = '" + password + "';";

              //Execute the query
              ResultSet rs = statement.executeQuery(query);

              //If the login information is incorrect, then an error is displayed and user is redirectd to login page
              if (!rs.isBeforeFirst() ) {
                  out.println("<script> alert('Incorrect login information!'); </script>");
                  out.println("<script> window.location.replace('../index.html'); </script>");
              } else { //If the login is successful, a session is started and user is redirected to main page

                  //Get user information from the customer's table
                  rs.next();
                  String customerId = rs.getString("ID");
                  String customerFirstName = rs.getString("first_name");
                  String customerLastName = rs.getString("last_name");

                  //Start the session
                  HttpSession session = request.getSession(true);

                  //Set session attributes
                  session.setAttribute("customerId",customerId);
                  session.setAttribute("customerFirstName",customerFirstName);
                  session.setAttribute("customerLastName",customerLastName);
                  session.setAttribute("loggedIn","true");

                  //Redirect user to the main page
                  out.println("<script> window.location.replace('../main.jsp'); </script>");
              }

              //Close ResultSet, Statement, and Connection to Database
              rs.close();
              statement.close();
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
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
	    doGet(request, response);
	}
}
