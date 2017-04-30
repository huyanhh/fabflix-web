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
    String urlMethod = (String)session.getAttribute("method");
    String urlPage = (String)session.getAttribute("page");

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
    if (urlMethod != null){
        urlParams.put("method",urlMethod);
    }
    if (urlPage != null){
        urlParams.put("page",urlPage);
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
                    Titles
                </div>

                <div class="js-categories-seasonal js-block-list list">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                        <tr>
                            <td class="borderClass bgColor1" valign="top" width="50"></td>
                            <td class="borderClass bgColor1 ac fw-b" valign="top">Title</td>

                            <%--<td class="borderClass bgColor1 ac fw-b" width="40" nowrap="">--%>
                                <%--<a href="?letter=A&amp;sy=0&amp;sm=0&amp;sd=0&amp;ey=0&amp;em=0&amp;ed=0&amp;o=4&amp;w=1"><i--%>
                                    <%--class="fa fa-sort ml2"></i></a></td>--%>
                            <td class="borderClass bgColor1 ac fw-b" width="135" nowrap="">

                                <%--Added sorting method checks--%>
                                <%--Apply options based on type on sort. First checks for movie genre and then checks all attributes for various search conditions--%>
                                    <%
                                    String options = "";
                                    String genreInstance = request.getParameter("movieGenre");
                                    String titleInstance = request.getParameter("movieTitle");
                                    String yearInstance = request.getParameter("movieYear");
                                    String directorInstance = request.getParameter("movieDirector");
                                    String starFirstNameInstance = request.getParameter("starFirstName");
                                    String starLastNameInstance = request.getParameter("starLastName");

                                    if (genreInstance != null) {
                                        options += "&movieGenre=" + genreInstance;
                                    }
                                    if (titleInstance != null) {
                                        options += "&movieTitle=" + titleInstance;
                                    }
                                    if (yearInstance != null) {
                                        options += "&movieYear=" + yearInstance;
                                    }
                                    if (directorInstance != null) {
                                        options += "&movieDirector=" + directorInstance;
                                    }
                                    if (starFirstNameInstance != null) {
                                        options += "&starFirstName=" + starFirstNameInstance;
                                    }
                                    if (starLastNameInstance != null) {
                                        options += "&starLastName=" + starLastNameInstance;
                                    }

                                    //clicking on sort by year or sorting by title appends session parameter options and displays the results in sorted order
                                    out.println("<a href='./MovieList?method=AscYear" + options + "'>AscYear </a> &nbsp <a href='./MovieList?method=DescYear" + options + "'> DescYear</a></td>");
                                    out.println("<a href='./MovieList?method=AscTitle" + options + "'>AscTitle </a> &nbsp <a href='./MovieList?method=DescTitle" + options + "'> DescTitle</a></td>");


                                %>
                            <td class="borderClass bgColor1 ac fw-b" width="40">Quantity</td>

                        </tr>
                        <tr>
                            <td class="borderClass bgColor0" valign="top" width="50">
                                <div class="picSurround">
                                    <a class="hoverinfo_trigger" href="https://myanimelist.net/anime/320/A_Kite"
                                       id="sarea320" rel="#sinfo320">
                                        <img width="50" height="70" alt="A Kite" border="0"
                                             data-src="https://myanimelist.cdn-dena.com/r/50x70/images/anime/3/61495.webp?s=a40ff43509a7b064dfee81aefcd07640"
                                             data-srcset="https://myanimelist.cdn-dena.com/r/50x70/images/anime/3/61495.webp?s=a40ff43509a7b064dfee81aefcd07640 1x, https://myanimelist.cdn-dena.com/r/100x140/images/anime/3/61495.webp?s=dc18b0fbee25dff309757257935b7b16 2x"
                                             class=" lazyloaded"
                                             srcset="https://myanimelist.cdn-dena.com/r/50x70/images/anime/3/61495.webp?s=a40ff43509a7b064dfee81aefcd07640 1x, https://myanimelist.cdn-dena.com/r/100x140/images/anime/3/61495.webp?s=dc18b0fbee25dff309757257935b7b16 2x"
                                             src="https://myanimelist.cdn-dena.com/r/50x70/images/anime/3/61495.webp?s=a40ff43509a7b064dfee81aefcd07640">
                                    </a>
                                </div>
                            </td>
                            <td class="borderClass bgColor0" valign="top">
                                <div id="sarea320">
                                    <div class="hoverinfo left bottom" id="sinfo320" rel="a320"
                                         style="left: 129.859px; top: -25px; display: none;">
                                        <div class="hoverinfo-contaniner"></div>
                                    </div>
                                </div>
                                <a class="hoverinfo_trigger fw-b fl-l" href="https://myanimelist.net/anime/320/A_Kite"
                                   id="sinfo320" rel="#sinfo320" style="display: inline-block;">
                                    <strong>A Kite</strong></a>
                                <a href="https://myanimelist.net/login.php?error=login_required&amp;from=%2Fanime.php%3Fletter%3DA"
                                   title="Quick add anime to my list" class="button_add ml8">add</a>

                                <div class="pt4">Sawa is a school girl, an orphan, and an assassin. She is being
                                    controlled by a corrupt cop who gives her targets to kill, detailing to her the
                                    crimes these men have committed in order to justify thei...<a
                                            href="https://myanimelist.net/anime/320/A_Kite">read more.</a></div>
                            </td>
                            <td class="borderClass ac bgColor0" width="45">
                                OVA
                            </td>
                            <td class="borderClass ac bgColor0" width="40">
                                2
                            </td>
                            <td class="borderClass ac bgColor0" width="50">
                                6.70
                            </td>
                        </tr>
                        <%
                            List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                            Integer ipage = (Integer) request.getAttribute("page");
                            String sortMethod = (String) request.getAttribute("method");
                            int placeholder = ipage == null ? 1 : ipage;
                            int itemsPerPage = 10;
                            int numberOfMoviePages = (int) Math.ceil(movies.size()/itemsPerPage);
                            int offset = (placeholder - 1) * itemsPerPage;

                            for (int i = offset; i < offset + itemsPerPage && i < movies.size(); i++){
                                Movie movie = movies.get(i);
                                out.println("<tr>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\" width=\"50\">");
                                out.println("<img width=\"50\" height=\"70\" border=\"0\" src=\"" + movie.bannerURL + "\">");
                                out.println("</td>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\">" +
                                        "<a href=//TODO>" +
                                        "<strong>" +
                                        movie.title + "</strong>" +
                                        "</a>");

                                out.println("<td class=\"borderClass ac bgColor0\" width=\"50\">" + movie.year + "</td>");
                                out.println("<td class=\"borderClass ac bgColor0\" width=\"40\">");
                                out.println("<form action = '/servlet/ShoppingCart' method = 'get'>");

                                int quant = 0;
                                for (int j = 0; j < shoppingCart.size(); j++){
                                    if (shoppingCart.get(j).id.equals(movie.id) && Integer.parseInt(shoppingCart.get(j).quantity) > 1){
                                        quant = Integer.parseInt(shoppingCart.get(j).quantity);
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

                            //applies sorting condition if it exists along with options when clicking on a page link
                            for (Integer k = 1; k <= numberOfMoviePages; k++){
                                if (sortMethod!=null) {
                                    out.println("&nbsp <a href=\"MovieList?method=" + sortMethod + "&page=" + k.toString() + options + "\">"+ k.toString() + "</a> ");
                                }else {
                                    out.println("&nbsp <a href=\"MovieList?page=" + k.toString() + options + "\">"+ k.toString() + "</a> ");

                                }
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