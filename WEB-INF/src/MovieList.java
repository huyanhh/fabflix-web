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
            String movieId = request.getParameter("movieId");
            String movieQuantity = request.getParameter("movieQuantity");
            String starFirstName = request.getParameter("starFirstName");
            String starLastName = request.getParameter("starLastName");

            //Handles scenario where user does not type in anything in search bar
            if ((movieTitle != null && movieTitle.length() == 0) && (movieYear != null && movieYear.length() == 0) && (movieDirector != null && movieDirector.length() == 0) && (starFirstName != null && starFirstName.length() == 0) && (starLastName != null && starLastName.length() == 0)){
                out.println("<script> alert('No movie results were found!') </script>");
                out.println("<script> window.location.replace('../search.jsp'); </script>");
            } else {

                //Add items to shopping cart if movieId and movieQuantity are both not null (they are in the url as parameters)
                if (movieId != null && movieQuantity != null) {
                    //Create a shopping cart if it does not exist already
                    if (session.getAttribute("shoppingCart") == null) {
                        session.setAttribute("shoppingCart", new ArrayList<Movie>());
                    }
                    //Iterate through the session's shoppingCart
                    boolean movieFound = false; //denotes whether or not movie exists in shopping cart
                    ArrayList<Movie> shoppingCart = (ArrayList<Movie>) session.getAttribute("shoppingCart"); //due to casting, suppresswarnings("unchecked") is needed
                    for (int i = 0; i < shoppingCart.size(); i++) {
                        //Look for the movie using movieId
                        if (shoppingCart.get(i).id.equals(movieId)) {
                            //Update movieFound to true
                            movieFound = true;
                            //Set the quantity.
                            shoppingCart.get(i).setQuantity(movieQuantity);
                            //If quantity is 0, then remove it from the shopping cart
                            if (movieQuantity.equals("0")) {
                                shoppingCart.remove(i);
                            }
                            break;
                        }
                    }
                    //If movie not found in shopping cart and quantity is > 0, then add it to the shopping cart
                    if (movieFound == false && Integer.parseInt(movieQuantity) > 0) {
                        //Create a movie object
                        Statement movieStatement = dbcon.createStatement();
                        String movieSQL = "select * from movies where id='" + movieId + "';";
                        ResultSet movieRS = movieStatement.executeQuery(movieSQL);
                        movieRS.next();
                        String scYear = movieRS.getString("year");
                        String scTitle = movieRS.getString("title");
                        String scDirector = movieRS.getString("director");
                        String scBanner = movieRS.getString("banner_url");
                        Movie scMovie = new Movie(movieId, scYear, scTitle, scDirector, scBanner, movieQuantity);

                        //Get the stars and genres
                        PreparedStatement scGenreStatement, scStarsStatement;
                        String scGenreQuery = "select name from genres where id in (select genre_id from genres_in_movies where movie_id = ?);";
                        String scStarsQuery = "select first_name, last_name from stars where id in (select star_id from stars_in_movies where movie_id = ?);";
                        scGenreStatement = dbcon.prepareStatement(scGenreQuery);
                        scStarsStatement = dbcon.prepareStatement(scStarsQuery);

                        scGenreStatement.setString(1, movieId);
                        ResultSet scGenreResultSet = scGenreStatement.executeQuery();
                        while (scGenreResultSet.next()) {
                            String scResultGenre = scGenreResultSet.getString("name");
                            scMovie.genres.add(scResultGenre);
                        }

                        scGenreResultSet.close();

                        scStarsStatement.setString(1, movieId);
                        ResultSet scStarsResultSet = scStarsStatement.executeQuery();
                        while (scStarsResultSet.next()) {
                            Star star = new Star();
                            star.name = scStarsResultSet.getString("first_name") + " " + scStarsResultSet.getString("last_name");
                            scMovie.stars.add(star);
                        }
                        scStarsResultSet.close();

                        //Add the movie to the shopping cart
                        shoppingCart.add(scMovie);

                        movieStatement.close();
                    }

                }

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

                //If the movieGenre has a length > 1, then it was passed as a parameter so perform a different query

                if (movieGenre.length() > 1 && (method == null || method.isEmpty())) {
                    strToFormat = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like '%s'));";
                    query = String.format(strToFormat, movieGenre);
                } else if (movieGenre.length() > 1 && (method != null || !method.isEmpty())) {
                    switch (method) {
                        case "AscTitle":
                            strToFormat = strToFormat + "order by title asc";
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
                    strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s'));";
                    if (method == null || method.isEmpty()) {
                        strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s'));";
                        query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                    } else {
                        switch (method) {
                            case "AscTitle":
                                strToFormat = strToFormat + "order by title asc";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "DescTitle":
                                strToFormat = strToFormat + "order by title desc";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "AscYear":
                                strToFormat = "select * from movies where title like '%s' and year like '%s' and director like '%s' and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like '%s' and last_name like '%s')) order by title;";
                                query = String.format(strToFormat, movieTitle, movieYear, movieDirector, starFirstName, starLastName);
                                break;
                            case "DescYear":
                                strToFormat = strToFormat + "order by year desc";
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
                    String starsQuery = "select first_name, last_name, id from stars where id in (select star_id from stars_in_movies where movie_id = ?);";
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
                            Star star = new Star();
                            star.name = starsResultSet.getString("first_name") + " " + starsResultSet.getString("last_name");
                            star.id = starsResultSet.getString("id");
                            movie.stars.add(star);
                        }
                        starsResultSet.close();
                        movies.add(movie);
                    }


                    //Close prepared statements
                    genreStatement.close();
                    starsStatement.close();
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
