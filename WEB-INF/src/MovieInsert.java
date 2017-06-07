import movies.Constants;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class MovieInsert extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        ArrayList<String> log = new ArrayList<>();

        PrintWriter out = response.getWriter();

        String title = request.getParameter("title");
        String year = request.getParameter("year");
        String director = request.getParameter("director");
        String first = request.getParameter("first_name");
        String last = request.getParameter("last_name");
        String genre = request.getParameter("genre_name");

        if (title.equals("")) {
            out.println("<script> alert('Movie title cannot be blank!'); </script>");
            out.println("<script> window.location.replace('./dashboard.jsp'); </script>");
            return;
        }

        try {

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

            CallableStatement cs = dbcon.prepareCall("{call add_movie(?, ?, ?, ?, ?, ?)}");

            cs.setString(1, title);
            cs.setInt(2, Integer.parseInt(year));
            cs.setString(3, director);
            cs.setString(4, first);
            cs.setString(5, last);
            cs.setString(6, genre);
            boolean results = cs.execute();

            //Loop through the available result sets.
            while (results) {
                ResultSet rs = cs.getResultSet();
                //Retrieve data from the result set.
                while (rs.next()) {
                    System.out.println(rs.getString(1));
                    log.add(rs.getString(1));
                }
                rs.close();

                //Check for next result set
                results = cs.getMoreResults();
            }
            cs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (log.get(log.size()-1).equals("Add movie successful"))
            out.println("<script> alert('Add movie successful'); </script>");
        else
            out.println("<script> alert('Movie already exists'); </script>");

        out.println("<script> window.location.replace('./dashboard.jsp'); </script>");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        doGet(request, response);
    }
}
