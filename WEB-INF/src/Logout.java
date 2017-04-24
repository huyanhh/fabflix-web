
/* A servlet which logs the user out of the website. */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Logout extends HttpServlet
{
    public String getServletInfo()
    {
        return "Servlet which logs the user out of the website.";
    }

    // Use http GET

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

        //Destroy the session
        request.getSession().invalidate();

        //Redirect user to the login page
        out.println("<script> window.location.replace('../index.html'); </script>");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        doGet(request, response);
    }
}
