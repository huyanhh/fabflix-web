
/* A servlet to check whether login information inputted by the user is correct. */

import movies.Constants;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Login extends HttpServlet {
    public String getServletInfo() {
        return "Servlet connects to MySQL database and determines if login information is correct";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        boolean mobile = request.getHeader("User-Agent").toLowerCase().contains("android");

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

        /*
        //ReCaptcha Check
        String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
        if (gRecaptchaResponse != null) {
            System.out.println("gRecaptchaResponse=" + gRecaptchaResponse);
            // Verify CAPTCHA.
            boolean valid = VerifyUtils.verify(gRecaptchaResponse);
            if (!valid) {
                //errorString = "Captcha invalid!";
                out.println("<script> alert('ReCaptcha Wrong!'); window.location.replace('../index.html'); </script>");
                return;
            }
        }
        */

        String loginUser = Constants.USER;
        String loginPasswd = Constants.PASSWORD;
        String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

        response.setContentType("text/html");    // Response mime type

        try {
            //Class.forName("org.gjt.mm.mysql.Driver");
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
            //Declare our statement
            Statement statement = dbcon.createStatement();

            //Get POST variables
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            System.out.println(email);
            System.out.println(password);

            String query;

            boolean isEmployee = request.getParameter("employee") != null;

            //Query to execute
            if (isEmployee)
                query = "SELECT * from employees where email = '" + email + "' and password = '" + password + "';";
            else
                query = "SELECT * from customers where email = '" + email + "' and password = '" + password + "';";

            //Execute the query
            ResultSet rs = statement.executeQuery(query);

            if (!isEmployee) {
                //If the login information is incorrect, then an error is displayed and user is redirectd to login page
                if (!rs.isBeforeFirst()) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.println("<script> alert('Incorrect login information!'); </script>");
                    out.println("<script> window.location.replace('../index.html'); </script>");
                } else { //If the login is successful, a session is started and user is redirected to main page
                    response.setStatus(HttpServletResponse.SC_ACCEPTED);
                    //Get user information from the customer's table
                    rs.next();
                    String customerId = rs.getString("ID");
                    String customerFirstName = rs.getString("first_name");
                    String customerLastName = rs.getString("last_name");

                    //Start the session
                    HttpSession session = request.getSession(true);

                    //Set session attributes
                    session.setAttribute("customerId", customerId);
                    session.setAttribute("customerFirstName", customerFirstName);
                    session.setAttribute("customerLastName", customerLastName);
                    session.setAttribute("loggedIn", "true");

                    if (!mobile)
                        out.println("<script> window.location.replace('../main.jsp'); </script>");
                    else
                        out.println("success");
                }
            } else {
                if (!rs.isBeforeFirst()) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.println("<script> alert('Incorrect login information!'); </script>");
                    out.println("<script> window.location.replace('../_dashboard.jsp'); </script>");
                } else {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("employeeLoggedIn", "true");
                    response.setStatus(HttpServletResponse.SC_ACCEPTED);
                    out.println("<script> window.location.replace('../dashboard.jsp'); </script>");
                }
            }

            //Close ResultSet, Statement, and Connection to Database
            rs.close();
            statement.close();
            dbcon.close();
        } catch (SQLException ex) {
            while (ex != null) {
                System.out.println("SQL Exception:  " + ex.getMessage());
                ex = ex.getNextException();
            }
        } catch (java.lang.Exception ex) {
            out.println("<HTML><HEAD><TITLE>MovieDB: Error</TITLE></HEAD>\n<BODY><P>SQL error in doGet: " + ex.getMessage() + "</P></BODY></HTML>");
            return;
        }
        out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doGet(request, response);
    }
}
