<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="movies.Movie" %>
<%@ page import="movies.Constants" %>
<%@ page import="movies.Star" %>
<%

    //Get session attributes
    String customerId = (String) session.getAttribute("customerId");
    String customerFirstName = (String) session.getAttribute("customerFirstName");
    String customerLastName = (String) session.getAttribute("customerLastName");
    String loggedIn = (String) session.getAttribute("loggedIn");

    //Check to see if the user has logged in. If not, redirect user to the login page.
    if (loggedIn == null) {
        out.println("<script> window.location.replace('index.html'); </script>");
    }

    //Get total movie quantity in shopping cart
    int totalQuantity = 0;
    ArrayList<Movie> shoppingCart = new ArrayList<Movie>();
    if (session.getAttribute("shoppingCart") != null){
        shoppingCart = (ArrayList<Movie>)session.getAttribute("shoppingCart");
        for (int i = 0; i < shoppingCart.size(); i++){
            totalQuantity += Integer.parseInt(shoppingCart.get(i).quantity);
        }
    }

%>
<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();

    String loginUser = Constants.USER;
    String loginPasswd = Constants.PASSWORD;
    String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

    Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

    response.setContentType("text/html");

    Statement statement = dbcon.createStatement();

    String starID = request.getParameter("id");

    String query = String.format("select CONCAT(first_name, \" \", last_name) as full_name, id, photo_url, dob from stars where id = %s;", starID);

    ResultSet rs = statement.executeQuery(query);

    PreparedStatement movieStatement;
    String movieQuery = "SELECT banner_url, title, id from movies WHERE id in (select movie_id FROM stars_in_movies WHERE star_id = ?);";
    movieStatement = dbcon.prepareStatement(movieQuery);

    Star star = new Star();

    while (rs.next()) {

        //Get movie information
        String resultId = rs.getString("id");
        String resultName = rs.getString("full_name");
        String resultPhotoURL = rs.getString("photo_url");
        String resultDOB = rs.getString("dob");

        if (resultName.startsWith("none"))
            resultName = resultName.split(" ")[1];

        star.id = resultId;
        star.name = resultName;
        star.photoURL = resultPhotoURL;
        star.dob = resultDOB;

        movieStatement.setString(1, resultId);
        ResultSet movieResultSet = movieStatement.executeQuery();
        while (movieResultSet.next()){
            String resultMovieTitle = movieResultSet.getString("title");
            String resultMovieID = movieResultSet.getString("id");
            String resultBannerURL = movieResultSet.getString("banner_url");
            Movie movie = new Movie(resultMovieID, resultMovieTitle);
            movie.bannerURL = resultBannerURL;
            star.movies.add(movie);
        }

        movieResultSet.close();
    }

    //Close prepared statements
    movieStatement.close();
%>
<!DOCTYPE html>
<html>
<head>
    <%--<link rel="stylesheet" type="text/css" href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-cfe6975aa5.css">--%>
        <link rel="stylesheet" type="text/css" href="css/mal.css">
</head>

<body onload=" " class="page-common" data-pin-hover="true">
<div id="myanimelist">

    <div class="wrapper">
        <div id="headerSmall" style="background: url(../resources/logo_small.png) center top no-repeat rgba(0, 0, 0, 0)">
            <a href="/" class="link-mal-logo">Fabflix</a>
        </div>
        <div id="menu" class="">
            <div id="menu_left">
                <ul id="nav">
                    <li class="small">
                        <%--Must be ../ because the current path is servlet/--%>
                        <a href="../search.jsp" class="non-link">Search</a>
                    </li>
                    <li class="small">
                        <a href="../browse.jsp" class="non-link">Browse</a>
                    </li>
                    <%
                        if (totalQuantity < 10){
                            out.println("<li class=\"large\" style = 'width:160px;'>");
                        } else if (totalQuantity < 100){
                            out.println("<li class=\"large\" style = 'width:170px;'>");
                        } else if (totalQuantity < 1000){
                            out.println("<li class=\"large\" style = 'width:180px;'>");
                        } else if (totalQuantity < 10000){
                            out.println("<li class=\"large\" style = 'width:190px;'>");
                        } else {
                            out.println("<li class=\"large\" style = 'width:200px;'>");
                        }
                    %>
                    <a href="../shoppingCart.jsp" class="non-link">Checkout (<% out.println(totalQuantity); %> items) </a>
                    </li>
                    <li class="small">
                        <a href="/servlet/Logout" class="non-link">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="contentWrapper" itemscope="" itemtype="http://schema.org/Product">
            <div><h1 class="h1"><span itemprop="name"><% out.println(star.name + " (" + star.id + ")"); %></span></h1></div>
            <div id="content">

                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                    <tr>
                        <td class="borderClass" width="225" style="border-width: 0 1px 0 0;" valign="top">
                            <div class="js-scrollfix-bottom" style="width: 225px; position: static">
                                <div style="text-align: center;">
                                    <a href="https://myanimelist.net/anime/25777/Shingeki_no_Kyojin_Season_2/pics">
                                        <img width="225" height="321" src="<% out.println(star.photoURL); %>" alt="Shingeki no Kyojin Season 2" class="ac" itemprop="image">
                                    </a>
                                </div>
                                <h2>Information</h2>
                                <div>
                                    <span class="dark_text">Given name:</span>
                                    <% out.println(star.name); %>
                                </div>
                                <div class="spaceit">
                                    <span class="dark_text">Birthday:</span>
                                    <% out.println(star.dob); %>
                                </div>
                            </div>
                        </td>
                        <td valign="top" style="padding-left: 5px;">
                            <div class="js-scrollfix-bottom-rel"><a name="lower"></a>
                                <div id="horiznav_nav" style="margin: 5px 0 10px 0;">
                                    <ul><li>
                                        <a href="https://myanimelist.net/anime/25777/Shingeki_no_Kyojin_Season_2" class="horiznav_active">Details</a>
                                    </li></ul>
                                </div>


                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                    <tr>
                                        <td class="pb24">
                                            <h2>
                                                <div class="floatRightHeader"></div>
                                                Movie Roles
                                            </h2>
                                            <%
                                                for (Movie movie: star.movies) {
                                                    out.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"><tbody><tr><td valign=\"top\" width=\"27\" class=\"borderClass bgColor2\" align=\"center\"><div class=\"picSurround\">");
                                                    out.println("<a href=\"movie.jsp?id=" + movie.id + "\"" + "style=\"font-weight: normal;\">");
                                                    out.println("<img src=\"" + movie.bannerURL + "\"" + "width=\"23\" height=\"32\" alt=\"Ackerman, Mikasa\" vspace=\"4\" hspace=\"8\" border=\"0\">");
                                                    out.println("</a></div></td><td valign=\"top\" class=\"borderClass bgColor2\">");
                                                    out.println("<a href=\"movie.jsp?id=" + movie.id + "\">" + movie.title + "</a>");
                                                    out.println("</td></tr></tbody></table>");
                                                }
                                            %>

                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                        </td>
                    </tr>
                    </tbody>
                </table>
            </div><!-- end of contentHome -->
        </div><!-- end of contentWrapper -->


        <!--  control container height -->
        <div style="clear:both;"></div>

        <!-- end rightbody -->

    </div><!-- wrapper -->

</div><!-- #myanimelist -->

</body>
</html>