/* A servlet that acts as the movie list page. */

import movies.Movie;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;

public class MovieList extends HttpServlet {

    public String getServletInfo() {
        return "Servlet that acts as the movie list page.";
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

        String loginUser = Constants.USER;
        String loginPasswd = Constants.PASSWORD;
        String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

        response.setContentType("text/html");    // Response mime type

//        out.println("<h1> Movie List </h1>");

        List<Movie> movies = new ArrayList<>();

        try
        {
            //Class.forName("org.gjt.mm.mysql.Driver");
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            //Connect to the database
            Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

            //Declare statement
            Statement statement = dbcon.createStatement();

            //Get GET variables
            String movieTitle = request.getParameter("movieTitle");
            String movieYear = request.getParameter("movieYear");
            String movieGenre = request.getParameter("movieGenre");
            String movieDirector = request.getParameter("movieDirector");
            String starFirstName = request.getParameter("starFirstName");
            String starLastName = request.getParameter("starLastName");

            //If GET variables are null, assign them to empty strings ""
            if (movieTitle == null){
                movieTitle = "";
            }
            if (movieYear == null){
                movieYear = "";
            }
            if (movieGenre == null){
                movieGenre = "";
            }
            if (movieDirector == null){
                movieDirector = "";
            }
            if (starFirstName == null){
                starFirstName = "";
            }
            if (starLastName == null){
                starLastName = "";
            }

            //Append "%" to the end of each GET variable which will be used for LIKE in the query
            movieTitle += "%";
            movieYear += "%";
            movieGenre += "%";
            movieDirector += "%";
            starFirstName += "%";
            starLastName += "%";

            //Based on provided information, generate a query that can be executed to display movie results
            String strToFormat, query;

            //If the movieGenre has a length > 1, then it was passed as a parameter so perform a different query
            if (movieGenre.length() > 1){
                strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s'));";
                query = String.format(strToFormat,movieGenre);
            } else { //otherwise perform same query for search and browse by title
                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s'));";
                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
            }

            //select * from movies where title like 'sp%' and year like '%' and director like '%'

            //Execute the query
            ResultSet rs = statement.executeQuery(query);

            //If no movie results returned, inform the user
            if (!rs.isBeforeFirst() ) {
                out.println("No movie results found.");
            } else { //Otherwise print the movie results

//                //Create table
//                out.println("<table border=1>");
//
//                //Display column names
//                out.println("<tr>");
//                out.println("<td>Id</td>");
//                out.println("<td>Title</td>");
//                out.println("<td>Year</td>");
//                out.println("<td>Director</td>");
//                out.println("<td>Genres</td>");
//                out.println("<td>Stars</td>");
//                out.println("</tr>");

                //Create PreparedStatements for displaying list of genres and stars
                PreparedStatement genreStatement, starsStatement;
                String genreQuery = "select name from genres where id in (select genre_id from genres_in_movies where movie_id = ?);";
                String starsQuery = "select first_name, last_name from stars where id in (select star_id from stars_in_movies where movie_id = ?);";
                genreStatement = dbcon.prepareStatement(genreQuery);
                starsStatement = dbcon.prepareStatement(starsQuery);


                while (rs.next()){

                    //Get movie information
                    String resultId = rs.getString("id");
                    String resultYear = rs.getString("year");
                    String resultTitle = rs.getString("title");
                    String resultDirector = rs.getString("director");
                    String resultBanner = rs.getString("banner_url");

                    Movie movie = new Movie(resultId, resultYear, resultTitle, resultDirector, resultBanner);


//                    out.println("<tr>");
//                    out.println("<td>" + resultId + "</td>");
//                    out.println("<td>" + resultTitle + "</td>");
//                    out.println("<td>" + resultYear + "</td>");
//                    out.println("<td>" + resultDirector + "</td>");

//                    Display the list of genres
//                    out.println("<td>");
                    genreStatement.setString(1,resultId);
                    ResultSet genreResultSet = genreStatement.executeQuery();
                    while (genreResultSet.next()){
                        String resultGenre = genreResultSet.getString("name");
//                        out.println(resultGenre + "<br>");
                        movie.genres.add(resultGenre);
                    }

                    genreResultSet.close();
//                    out.println("</td>");

                    //Display the list of stars
//                    out.println("<td>");
                    starsStatement.setString(1,resultId);
                    ResultSet starsResultSet = starsStatement.executeQuery();
                    while (starsResultSet.next()){
                        String resultName = starsResultSet.getString("first_name") + " " + starsResultSet.getString("last_name");
//                        out.println(resultName + "<br>");
                        movie.stars.add(resultName);
                    }
                    starsResultSet.close();
//                    out.println("</td>");
//                    out.println("</tr>");
                    movies.add(movie);
                }



                //Close prepared statements
                genreStatement.close();
                starsStatement.close();

                out.println("</table>");
            }

            //Close ResultSet, Statement, and Connection to Database
            rs.close();
            statement.close();
            dbcon.close();
            System.out.println("movies = " + movies);
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("/titles.jsp").forward(request, response);
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
