/* A servlet that acts as the movie list page. */

import movies.Constants;
import movies.Movie;
import movies.Star;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class MovieList extends HttpServlet {

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

        //Remove session attributes
        session.removeAttribute("urlMovieTitle");
        session.removeAttribute("urlMovieYear");
        session.removeAttribute("urlMovieGenre");
        session.removeAttribute("urlMovieDirector");
        session.removeAttribute("urlStarFirstName");
        session.removeAttribute("urlStarLastName");
        session.removeAttribute("method");
        session.removeAttribute("page");

        // Gets the page number you are currently on
        String page = request.getParameter("page");
        //Sends the page number back to the frontend to perform pagination results filtering
        request.setAttribute("page", page == null ? 1 : Integer.parseInt(page));

        session.setAttribute("page",page);

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
            //String movieId = request.getParameter("movieId");
            //String movieQuantity = request.getParameter("movieQuantity");
            String starFirstName = request.getParameter("starFirstName");
            String starLastName = request.getParameter("starLastName");

            //Handles scenario where user does not type in anything in search bar
            if ((movieTitle != null && movieTitle.length() == 0) && (movieYear != null && movieYear.length() == 0) && (movieDirector != null && movieDirector.length() == 0) && (starFirstName != null && starFirstName.length() == 0) && (starLastName != null && starLastName.length() == 0)){
                out.println("<script> alert('No movie results were found!') </script>");
                out.println("<script> window.location.replace('../search.jsp'); </script>");
            } else {

                //If GET variables are null, assign them to empty strings "". Otherwise, store as session attribute.
                if (movieTitle == null) {
                    movieTitle = "";
                } else {
                    session.setAttribute("urlMovieTitle",movieTitle);
                }
                if (movieYear == null) {
                    movieYear = "";
                } else {
                    session.setAttribute("urlMovieYear",movieYear);
                }
                if (movieGenre == null) {
                    movieGenre = "";
                } else {
                    session.setAttribute("urlMovieGenre",movieGenre);
                }
                if (movieDirector == null) {
                    movieDirector = "";
                } else {
                    session.setAttribute("urlMovieDirector",movieDirector);
                }
                if (starFirstName == null) {
                    starFirstName = "";
                } else {
                    session.setAttribute("urlStarFirstName",starFirstName);
                }
                if (starLastName == null) {
                    starLastName = "";
                } else {
                    session.setAttribute("urlStarLastName",starLastName);
                }

                //Append "%" to the end of each GET variable which will be used for LIKE in the query
                movieTitle += "%";
                movieYear += "%";
                movieGenre += "%";
                movieDirector += "%";
                starFirstName += "%";
                starLastName += "%";

                //Based on provided information, generate a query that can be executed to display movie results
                String strToFormat = "", query = "";
                String method = request.getParameter("method");
                request.setAttribute("method",method);

                session.setAttribute("method",method);

                //If the movieGenre has a length > 1 and no sort method apply do the standard genre search query
                if (movieGenre.length() > 1 && (method == null || method.isEmpty())){
                    strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s'));";
                    query = String.format(strToFormat,movieGenre);
                } else if (movieGenre.length() > 1 && (method != null || !method.isEmpty())){
                    //changes the query for genre based on type of sort method applied
                    switch (method) {
                        case "AscTitle":
                            strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s')) order by title;";
                            query = String.format(strToFormat, movieGenre);
                            break;
                        case "DescTitle":
                            strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s')) order by title desc;";
                            query = String.format(strToFormat, movieGenre);
                            break;
                        case "AscYear":
                            strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s')) order by year asc;";
                            query = String.format(strToFormat, movieGenre);
                            break;
                        case "DescYear":
                            strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s')) order by year desc;";
                            query = String.format(strToFormat, movieGenre);
                            break;
                    }
                } else { //otherwise perform same query for search and browse by title
                    if (method == null || method.isEmpty()){
                        strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s'));";
                        query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                    } else {
                        //changes the search and browse by title query based on type of sort method applied
                        switch (method) {
                            case "AscTitle":
                                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s')) order by title;";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "DescTitle":
                                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s')) order by title desc;";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "AscYear":
                                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s')) order by year asc;";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "DescYear":
                                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s')) order by year desc;";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                        }
                    }
                }

                //Execute the query
                ResultSet rs = statement.executeQuery(query);

                //If no movie results returned, inform the user
                if (!rs.isBeforeFirst()) {
                    out.println("No movie results found.");
                } else { //Otherwise print the movie results

                    //Create PreparedStatements for displaying list of genres and stars
                    PreparedStatement genreStatement, starsStatement;
                    String genreQuery = "select name from genres where id in (select genre_id from genres_in_movies where movie_id = ?);";
                    String starsQuery = "select first_name, last_name from stars where id in (select star_id from stars_in_movies where movie_id = ?);";
                    genreStatement = dbcon.prepareStatement(genreQuery);
                    starsStatement = dbcon.prepareStatement(starsQuery);


                    while (rs.next()) {

                        //Get movie information
                        String resultId = rs.getString("id");
                        String resultYear = rs.getString("year");
                        String resultTitle = rs.getString("title");
                        String resultDirector = rs.getString("director");
                        String resultBanner = rs.getString("banner_url");

                        Movie movie = new Movie(resultId, resultYear, resultTitle, resultDirector, resultBanner);

                        genreStatement.setString(1, resultId);
                        ResultSet genreResultSet = genreStatement.executeQuery();
                        while (genreResultSet.next()) {
                            String resultGenre = genreResultSet.getString("name");
                            movie.genres.add(resultGenre);
                        }

                        genreResultSet.close();

                        starsStatement.setString(1, resultId);
                        ResultSet starsResultSet = starsStatement.executeQuery();
                        while (starsResultSet.next()) {
                            String resultName = starsResultSet.getString("first_name") + " " + starsResultSet.getString("last_name");
                        }
                        starsResultSet.close();
                        movies.add(movie);
                    }


                    //Close prepared statements
                    genreStatement.close();
                    starsStatement.close();

                    out.println("</table>");
                }

                //Close ResultSet, Statement, and Connection to Database
                rs.close();
                //System.out.println("movies = " + movies);
                request.setAttribute("movies", movies);
                request.getRequestDispatcher("/titles.jsp").forward(request, response);
            }
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

    @SuppressWarnings("unchecked")
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        doGet(request, response);
    }


}
