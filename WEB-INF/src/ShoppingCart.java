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
            String movie = request.getParameter("movie");
            String movieList = request.getParameter("movieList");
            String movieTitle = request.getParameter("movieTitle");
            String movieYear = request.getParameter("movieYear");
            String movieGenre = request.getParameter("movieGenre");
            String movieDirector = request.getParameter("movieDirector");
            String starFirstName = request.getParameter("starFirstName");
            String starLastName = request.getParameter("starLastName");
            String method = request.getParameter("method");
            String page = request.getParameter("page");
            String numPageResults = request.getParameter("numPageResults");

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
                    String scGenreQuery = "SELECT name FROM genres WHERE id IN (SELECT genre_id FROM genres_in_movies WHERE movie_id = ?);";
                    String scStarsQuery = "SELECT first_name, last_name FROM stars WHERE id IN (SELECT star_id FROM stars_in_movies WHERE movie_id = ?);";
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


            if (movie != null && movie.equals("true")){ //Redirect to movie.jsp if movie is not null and is true.
                out.println("<script>window.location.replace('../movie.jsp?id="+ movieId +"');</script>");
            } else if (movieList != null && movieList.equals("true")){ //if movieList is true, redirect to movie list page and display same movies
                //Create a list of URL parameters
                HashMap<String,String> urlParams = new HashMap<String,String>();

                //Add url parameters if they are not null
                if (movieTitle != null){
                    urlParams.put("movieTitle",movieTitle);
                }
                if (movieYear != null){
                    urlParams.put("movieYear",movieYear);
                }
                if (movieGenre != null){
                    urlParams.put("movieGenre",movieGenre);
                }
                if (movieDirector != null){
                    urlParams.put("movieDirector",movieDirector);
                }
                if (starFirstName != null){
                    urlParams.put("starFirstName",starFirstName);
                }
                if (starLastName != null){
                    urlParams.put("starLastName",starLastName);
                }
                if (method != null){
                    urlParams.put("method",method);
                }
                if (page != null){
                    urlParams.put("page",page);
                }
                if (numPageResults != null){
                    urlParams.put("numPageResults",numPageResults);
                }
                String url = "../servlet/MovieList?";
                int count = 0;
                for (Map.Entry<String,String> e : urlParams.entrySet()){
                    url += e.getKey() + "=" + e.getValue();
                    if (count < urlParams.size()-1){
                        url += "&";
                    }
                    count++;
                }
                out.println("<script>window.location.replace('"+ url + "');</script>");
            } else {
                out.println("<script>window.location.replace('../shoppingCart.jsp');</script>");
            }

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
