<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="movies.Movie" %>
<%@ page import="movies.Constants" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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

    //Get URL parameters
    String urlMovieTitle = (String)session.getAttribute("urlMovieTitle");
    String urlMovieYear = (String)session.getAttribute("urlMovieYear");
    String urlMovieGenre = (String)session.getAttribute("urlMovieGenre");
    String urlMovieDirector = (String)session.getAttribute("urlMovieDirector");
    String urlStarFirstName = (String)session.getAttribute("urlStarFirstName");
    String urlStarLastName = (String)session.getAttribute("urlStarLastName");

    //Create a list of URL parameters
    HashMap<String,String> urlParams = new HashMap<String,String>();

    //Add url parameters if they are not null
    if (urlMovieTitle != null){
        urlParams.put("movieTitle",urlMovieTitle);
    }
    if (urlMovieYear != null){
        urlParams.put("movieYear",urlMovieYear);
    }
    if (urlMovieGenre != null){
        urlParams.put("movieGenre",urlMovieGenre);
    }
    if (urlMovieDirector != null){
        urlParams.put("movieDirector",urlMovieDirector);
    }
    if (urlStarFirstName != null){
        urlParams.put("starFirstName",urlStarFirstName);
    }
    if (urlStarLastName != null){
        urlParams.put("starLastName",urlStarLastName);
    }

%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-cfe6975aa5.css">
    <%--<link rel="stylesheet" type="text/css" href="css/mal.css">--%>
</head>

<body onload=" " class="page-common">
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
            <div><h1 class="h1">Browse Movies</h1></div>
            <div id="content">

                <div id="horiznav_nav" class="ac mt8 ml0 mr0"></div>

                <div class="normal_header clearfix pt16">
                    <div class="fl-r di-ib fs11 fw-n">
                        <div style="float: right;"><span class="bgColor1" style="padding: 2px;">[1] <a
                                href="/anime.php?letter=A&amp;show=50">2</a> <a href="/anime.php?letter=A&amp;show=100">3</a> ... <a
                                href="/anime.php?letter=A&amp;show=650">14</a></span></div>
                    </div>
                    Titles
                </div>

                <div class="js-categories-seasonal js-block-list list">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                        <tr>
                            <td class="borderClass bgColor1" valign="top" width="50"></td>
                            <td class="borderClass bgColor1 ac fw-b" valign="top">Title
                                <br>
                                <%
                                    out.println("<a href='./MovieList?method=AscYear" + "'>Asc&uarr;</a>&nbsp;<a href='./MovieList?method=DescYear" + "'>Desc&darr;</a></td>");
                                %>
                            </td>
                            <td class="borderClass bgColor1 ac fw-b" width="45" nowrap="">
                                Year
                                <%
                                    String options = "";
                                    String genreInstance = request.getParameter("movieGenre");
                                    String titleInstance = request.getParameter("movieTitle");
                                    String directorInstance = request.getParameter("movieDirector");
                                    if (genreInstance != null) {
                                        options += "&genre=" + genreInstance;
                                    }
                                    if (titleInstance != null) {
                                        options += "&title=" + titleInstance;
                                    }
                                    if (directorInstance != null) {
                                        options += "&director=" + directorInstance;
                                    }

                                out.println("<a href='./MovieList?method=AscYear" + options + "'>Asc&uarr;</a>&nbsp;<a href='./MovieList?method=DescYear" + options + "'>Desc&darr;</a></td>");
                                %>
                            </td>

                            <td class="borderClass bgColor1 ac fw-b" width="40" nowrap="">Director</td>
                            <td class="borderClass bgColor1 ac fw-b" width="50" nowrap="">Stars</td>
                            <td class="borderClass bgColor1 ac fw-b" width="50" nowrap="">Genres</td>
                            <td class="borderClass bgColor1 ac fw-b" width="40">Quantity</td>
                            <td class="borderClass bgColor1 ac fw-b" width="40"></td>
                        </tr>
                        <%
                            List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                            for (Movie movie : movies ) {
                                out.println("<tr>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\" width=\"50\">");
                                out.println("<img width=\"50\" height=\"70\" border=\"0\" src=\"" + movie.bannerURL + "\">");
                                out.println("</td>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\">" +
                                        "<a href=../movie.jsp?id=" + movie.id + ">" +
                                        "<strong>" + movie.title + "</strong>" +
                                        "</a>" + "</td>");

                                out.println("<td class=\"borderClass ac bgColor0\" width=\"45\">" + movie.year + "</td>");
                                out.println("<td class=\"borderClass ac bgColor0\" width=\"100\">" + movie.director + "</td>");
                                out.println("<td class=\"borderClass ac bgColor0\" width=\"100\">");
                                for (Star star : movie.stars)
                                    out.println("<a href=\"../star.jsp?id=" + star.id + "\">" + star.name + "</a><br>");
                                out.println("</td>");
                                out.println("<td class=\"borderClass ac bgColor0\" width=\"70\">");
                                for (String genre : movie.genres)
                                    out.println(genre + "<br>");
                                out.println("</td>");

                                out.println("<td class=\"borderClass ac bgColor0\" width=\"40\">");
                                out.println("<form action = '/servlet/ShoppingCart' method = 'get'>");

                                int quant = 0;
                                for (int i = 0; i < shoppingCart.size(); i++){
                                    if (shoppingCart.get(i).id.equals(movie.id) && Integer.parseInt(shoppingCart.get(i).quantity) > 1){
                                        quant = Integer.parseInt(shoppingCart.get(i).quantity);
                                        break;
                                    }
                                }
                                if (quant != 0){
                                    out.println("<input type = 'text' name = 'movieQuantity' value = '" + quant + "' maxlength = '4' size = '4' style = 'text-align:center;'>");
                                } else {
                                    out.println("<input type = 'text' name = 'movieQuantity' value = '1' maxlength = '4' size = '4' style = 'text-align:center;'>");
                                }
                                out.println("<input type = 'hidden' value = '" + movie.id + "' name = 'movieId'>");
                                for (Map.Entry<String,String> e : urlParams.entrySet()) {
                                    out.println("<input type = 'hidden' value = '" + e.getValue() + "' name = '" + e.getKey() + "'>");
                                }
                                out.println("<input type = 'hidden' value = 'true' name = 'movieList'>");
                                out.println("</td><td class=\"borderClass ac bgColor0\" width=\"50\"> <input type = 'submit' value = 'Add to Cart'></form> </td>");
                                out.println("</tr>");
                            }
                        %>

                        </tbody>
                    </table>
                </div>

                <div class="anime-manga-search pb24">
                    <div class="genre-link">
                        <%
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection connection = DriverManager.getConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false", Constants.USER, Constants.PASSWORD);
                            Statement select = connection.createStatement();
                            ResultSet result = select.executeQuery("select *  from genres; ");

                            //TODO

                            result.close();
                            select.close();
                        %>
                    </div>
                </div>

            </div>

        </div><!-- end of contentHome -->
    </div><!-- end of contentWrapper -->

    <!--  control container height -->
    <div style="clear:both;"></div>

    <!-- end rightbody -->

</div><!-- wrapper -->


<div id="ad-skin-bg-right" class="ad-skin-side-outer ad-skin-side-bg bg-right">
    <div id="ad-skin-right" class="ad-skin-side right" style="display: none;">
        <div id="ad-skin-right-absolute-block">
            <div id="ad-skin-right-fixed-block"></div>
        </div>
    </div>
</div>
</div><!-- #myanimelist -->

<script>
    var header = {
        alphabet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    };

    function makeUL(string) {
        var list = document.createElement('ul');

        for (var i = 0; i < string.length; i++) {
            var item = document.createElement('li');
            var link = document.createElement('a');
            link.innerHTML = string.charAt(i);
            link.href = '/servlet/MovieList?movieTitle=' + string.charAt(i);

            item.appendChild(link);
            list.appendChild(item);
        }

        return list;
    }
    document.getElementById('horiznav_nav').appendChild(makeUL(header.alphabet));
</script>
</body>
</html>