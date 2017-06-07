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
        out.println("<script> window.location.replace('../index.html'); </script>");
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
    String urlNumPageResults = (String)session.getAttribute("numPageResults");
    String urlFromSearchPage = (String)session.getAttribute("fromSearchPage");

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
    } else {
        urlPage = "1";
    }
    if (urlNumPageResults != null){
        try {
            if (Integer.parseInt(urlNumPageResults) >= 0) {
                urlParams.put("numPageResults", urlNumPageResults);
            } else {
                urlParams.put("numPageResults","10");
            }
        } catch (Exception e) {
            urlParams.put("numPageResults","10");
        }
    } else {
        urlParams.put("numPageResults","10");
    }
    if (urlFromSearchPage != null){
      urlParams.put("fromSearchPage",urlFromSearchPage);
    }



%>
<!DOCTYPE html>
<html>
<head>
    <link rel = "stylesheet" type = "text/css" href = "../css/mal.css">

    <script src="<%=request.getContextPath()%>/js/jquery-1.10.2.js" lang="javascript"></script>
    <script src="<%=request.getContextPath()%>/js/jquery-ui.js" lang="javascript"></script>

    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/ui-darkness/jquery-ui.css" type="text/css" rel="stylesheet" >
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/dialog.js" lang="javascript"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery-ui.css">

    <script>$(document).ready(function(){});</script>
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
                    <table border="0" width="100%">
                        <tr>
                            <td width="76%">Titles</td>
                            <%

                                out.println("<td align='right'>");
                                out.println("<b> # of Results Per page</b>");
                                out.println("</td>");
                                out.println("<td align='right'>");
                                out.println("<form action = '/servlet/MovieList' method='post'>");
                                out.println("<input type = 'text' maxlength='4' size='4' name='numPageResults' value=" + Integer.parseInt(urlParams.get("numPageResults")) + " style='text-align:center;'>");
                                for (Map.Entry<String,String> e : urlParams.entrySet()) {
                                    if (e.getKey().equals("page")){
                                        out.println("<input type = 'hidden' value = '1' name = '" + e.getKey() + "'>"); //after user adjusts number of results per page, have it redirect to page 1
                                    } else {
                                        out.println("<input type = 'hidden' value = '" + e.getValue() + "' name = '" + e.getKey() + "'>");
                                    }
                                }
                                out.println("<input type = 'hidden' value = 'true' name = 'movieList'>");
                                out.println("<input type = 'submit' value='Submit' name='submit'>");
                                out.println("</form>");
                                out.println("</td>");

                            %>
                        </tr>
                    </table>
                </div>


                <div class="js-categories-seasonal js-block-list list">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                        <tr>
                            <%
                                String options = "";
                                String genreInstance = request.getParameter("movieGenre");
                                String titleInstance = request.getParameter("movieTitle");
                                String yearInstance = request.getParameter("movieYear");
                                String directorInstance = request.getParameter("movieDirector");
                                String starFirstNameInstance = request.getParameter("starFirstName");
                                String starLastNameInstance = request.getParameter("starLastName");
                                String fromSearchPage = request.getParameter("fromSearchPage");

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
                                if (fromSearchPage != null){
                                  options += "&fromSearchPage=" + fromSearchPage;
                                }
                            %>
                            <td class="borderClass bgColor1" valign="top" width="50"></td>
                            <%--Added sorting method checks--%>
                            <%--Apply options based on type on sort. First checks for movie genre and then checks all attributes for various search conditions--%>
                            <td class="borderClass bgColor1 ac fw-b" valign="top">Title
                                <br>
                                <%
                                    //clicking on sort by year or sorting by title appends session parameter options and displays the results in sorted order
                                    out.println("<a href='./MovieList?method=AscTitle" + options + "'>Asc</a>&nbsp <a href='./MovieList?method=DescTitle" + options + "'>Desc</a>");
                                %>
                            </td>
                            <td class="borderClass bgColor1 ac fw-b" width="45" nowrap="">
                                Year
                                <% out.println("<a href='./MovieList?method=AscYear" + options + "'>Asc</a>&nbsp<a href='./MovieList?method=DescYear" + options + "'>Desc</a></td>"); %>
                            </td>
                            <td class="borderClass bgColor1 ac fw-b" width="40" nowrap="">Director</td>
                            <td class="borderClass bgColor1 ac fw-b" width="50" nowrap="">Stars</td>
                            <td class="borderClass bgColor1 ac fw-b" width="50" nowrap="">Genres</td>
                            <td class="borderClass bgColor1 ac fw-b" width="40">Quantity</td>
                            <td class="borderClass bgColor1 ac fw-b" width="40"></td>
                        </tr>
                        <%
                            List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                            Integer ipage = (Integer) request.getAttribute("page");
                            String sortMethod = (String) request.getAttribute("method");
                            int placeholder = ipage == null ? 1 : ipage;
                            int itemsPerPage = Integer.parseInt(urlParams.get("numPageResults"));
                            double itemsPerPageConverted = 1.0* itemsPerPage;
                            int numberOfMoviePages = (int) Math.ceil(movies.size()/itemsPerPageConverted);
                            int offset = (placeholder - 1) * itemsPerPage;

                            if (movies.isEmpty())
                                out.println("<tr><td class=\"borderClass bgColor0\" valign=\"top\" width=\"300\">" +
                                        "No titles that matched your query were found</td></tr>");

                            for (int i = offset; i < offset + itemsPerPage && i < movies.size(); i++){
                                Movie movie = movies.get(i);
                                out.println("<tr>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\" width=\"50\">");
                                out.println("<img width=\"50\" height=\"70\" border=\"0\" src=\"" + movie.bannerURL + "\">");
                                out.println("</td>");
                                out.println("<td class=\"borderClass bgColor0\" valign=\"top\">" +
                                        "<a href=../movie.jsp?id=" + movie.id + ">" +
                                        "<strong id='" + movie.id + "' onmouseover='popDialog(event)' onmouseout='removeDialog()'>" + movie.title + "(" + movie.id + ")" + "</strong>" +
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

//                              changed to 1 as default. Shouldn't affect code logic and sets default in dialog box to 1
                                int quant = 1;

                                for (int j = 0; j < shoppingCart.size(); j++) {
                                    if (shoppingCart.get(j).id.equals(movie.id) && Integer.parseInt(shoppingCart.get(j).quantity) > 1) {
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


                                //add another form tag to implement shopping cart button
                                //create divs which hold text data for title, director, stars, genres, banner, and an add to shopping cart button
                                out.println("<div id='d" + movie.id + "' style='display: none;'>");
                                out.println("<form action = '/servlet/ShoppingCart' method = 'get'>");

                                out.println("<div>"+ "Title: " + movie.title +"</div>");
                                out.println("<div>"+ "Director: " + movie.director +"</div>");
                                out.println("<div>"+ "Year: " + movie.year +"</div>");
                                for(Star star: movie.stars){
                                    out.println("<div>"+ "Stars: " + star.name + "</div>");
                                }
                                for (String g: movie.genres){
                                    out.println("<div>"+ "Genre: " + g + "</div>");
                                }
                                out.println("<div>"+ "Banner_url: " + movie.bannerURL + "</div>");


                                //takes the inputs for add to shopping card and sends it to the shopping cart servlet when an action occurs like pressing a button
                                out.println("<input type = 'submit' value='addToCart' />");
                                out.println("<input type = 'hidden' name='movieId' value='" + movie.id + "' />");
                                out.println("<input type = 'text' name='movieQuantity' value='" + quant + "' />");

                                out.println("</form>");
                                out.println("</div>");
                            }
                        %>
                        <span style="padding: 2px; background-color: rgba(192,198,255,0.59)">
                        <%
                            //applies sorting condition if it exists along with options when clicking on a page link
                            if (numberOfMoviePages > 1) {
                                out.println("<b> Pages: </b>");
                                for (Integer k = 1; k <= numberOfMoviePages; k++) {
                                    String currentPage = k.toString();
                                    if (currentPage.equals(urlPage))
                                        currentPage = "[" + currentPage + "]";
                                    if (sortMethod != null) {
                                        out.println("&nbsp <a href=\"MovieList?numPageResults=" + urlParams.get("numPageResults") + "&method=" + sortMethod + "&page=" + k.toString() + options + "\">" + currentPage + "</a> ");
                                    } else {
                                        out.println("&nbsp <a href=\"MovieList?numPageResults=" + urlParams.get("numPageResults") + "&page=" + k.toString() + options + "\">" + currentPage + "</a> ");

                                    }
                                }
                            }
                        %>
                        </span>

                        </tbody>
                    </table>
                </div>

            </div>

        </div><!-- end of contentHome -->
    </div><!-- end of contentWrapper -->

    <!--  control container height -->
    <div style="clear:both;"></div>

    <!-- end rightbody -->

</div><!-- wrapper -->

<script>
    var header = {
        alphabet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    };

    function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'block')
          e.style.display = 'none';
       else
          e.style.display = 'block';
    }

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
