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
        session.removeAttribute("fromSearchPage");
        //session.removeAttribute("numPageResults");

        // Gets the page number you are currently on
        String page = request.getParameter("page");
        //Sends the page number back to the frontend to perform pagination results filtering
        request.setAttribute("page", page == null ? 1 : Integer.parseInt(page));

        session.setAttribute("page",page);

        //Get the number of results per page you want to view
        String numPageResults = request.getParameter("numPageResults");

        if (numPageResults != null){
            session.setAttribute("numPageResults",numPageResults);
        } else {
            if (session.getAttribute("numPageResults") == null){
                session.setAttribute("numPageResults","10"); //10 is default
            }
        }

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

        List<Movie> movies = new ArrayList<>();

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

            //Declare statement
            PreparedStatement ps = null;

            //Get GET variables
            String movieTitle = request.getParameter("movieTitle");
            String movieYear = request.getParameter("movieYear");
            String movieGenre = request.getParameter("movieGenre");
            String movieDirector = request.getParameter("movieDirector");
            String starFirstName = request.getParameter("starFirstName");
            String starLastName = request.getParameter("starLastName");
            String fromSearchPage = request.getParameter("fromSearchPage");

            String method = request.getParameter("method");
            request.setAttribute("method",method);

            session.setAttribute("method",method);

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
                if (fromSearchPage != null){
                  session.setAttribute("urlFromSearchPage",fromSearchPage);
                }

                //Append "%" to the end of each GET variable which will be used for LIKE in the query
                //movieTitle += "%";
                movieYear += "%";
                movieGenre += "%";
                movieDirector += "%";
                starFirstName += "%";
                starLastName += "%";

                //Because title may have spaces, split by spaces, append a + to beginning of each string and * to end. Then append all
                if (fromSearchPage != null){
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
                  movieTitle = newMovieTitle;
                } else {
                  movieTitle += "%";
                }

                //Based on provided information, generate a query that can be executed to display movie results
                String query = "";

                //If the movieGenre has a length > 1 and no sort method apply do the standard genre search query
                if (movieGenre.length() > 1 && (method == null || method.isEmpty())){
                    query = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like ?));";
                    ps = dbcon.prepareStatement(query);
                    ps.setString(1,movieGenre);
                } else if (movieGenre.length() > 1 && (method != null || !method.isEmpty())){
                    //changes the query for genre based on type of sort method applied
                    switch (method) {
                        case "AscTitle":
                            query = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like ?)) order by title;";
                            break;
                        case "DescTitle":
                            query = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like ?)) order by title desc;";
                            break;
                        case "AscYear":
                            query = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like ?)) order by year asc;";
                            break;
                        case "DescYear":
                            query = "select * from movies where id in (select movie_id from genres_in_movies where genre_id in (select id from genres where name like ?)) order by year desc;";
                            break;
                    }
                    ps = dbcon.prepareStatement(query);
                    ps.setString(1,movieGenre);
                } else { //otherwise perform same query for search and browse by title
                    if (method == null || method.isEmpty()){
                        if (fromSearchPage == null){
                            query = "select * from movies where title like ? and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?));";
                        } else {
                            query = "select * from movies where match(title) against(? in boolean mode) and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?));";
                        }
                        ps = dbcon.prepareStatement(query);
                        ps.setString(1,movieTitle);
                        ps.setString(2,movieYear);
                        ps.setString(3,movieDirector);
                        ps.setString(4,starFirstName);
                        ps.setString(5,starLastName);
                    } else {
                        //changes the search and browse by title query based on type of sort method applied
                        switch (method) {
                            case "AscTitle":
                                if (fromSearchPage == null){
                                    query = "select * from movies where title like ? and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by title;";
                                } else {
                                    query = "select * from movies where match(title) against(? in boolean mode) and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by title;";
                                }
                                break;
                            case "DescTitle":
                                if (fromSearchPage == null){
                                    query = "select * from movies where title like ? and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by title desc;";
                                } else {
                                    query = "select * from movies where match(title) against(? in boolean mode) and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by title desc;";
                                }
                                break;
                            case "AscYear":
                                if (fromSearchPage == null){
                                    query = "select * from movies where title like ? and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by year asc;";
                                } else {
                                    query = "select * from movies where match(title) against(? in boolean mode) and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by year asc;";
                                }
                                break;
                            case "DescYear":
                                if (fromSearchPage == null){
                                    query = "select * from movies where title like ? and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by year desc;";
                                } else {
                                    query = "select * from movies where match(title) against(? in boolean mode) and year like ? and director like ? and id in (select movie_id from stars_in_movies where star_id in (select id from stars where first_name like ? and last_name like ?)) order by year desc;";
                                }
                                break;
                        }
                        ps = dbcon.prepareStatement(query);
                        ps.setString(1,movieTitle);
                        ps.setString(2,movieYear);
                        ps.setString(3,movieDirector);
                        ps.setString(4,starFirstName);
                        ps.setString(5,starLastName);
                    }
                }

                //Execute the query
                ResultSet rs = ps.executeQuery();

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
                            String resultName = starsResultSet.getString("first_name") + " " + starsResultSet.getString("last_name");
                            if (resultName.startsWith("none"))
                                resultName = resultName.split(" ")[1];
                            star.name = resultName;
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

                //Close ResultSet, Prepared Statement, and Connection to Database
                rs.close();
                //System.out.println("movies = " + movies);
                request.setAttribute("movies", movies);
                request.getRequestDispatcher("/titles.jsp").forward(request, response);
            }
            if (ps != null){
              ps.close();
            }
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
