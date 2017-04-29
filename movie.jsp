<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%@ page import="java.util.List" %>
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

%>
<%
    Class.forName("com.mysql.jdbc.Driver").newInstance();

    String loginUser = Constants.USER;
    String loginPasswd = Constants.PASSWORD;
    String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

    Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

    response.setContentType("text/html");

    Statement statement = dbcon.createStatement();

    String movieID = request.getParameter("id");

    String query = String.format("SELECT * FROM movies WHERE id=%s;", movieID);

    ResultSet rs = statement.executeQuery(query);

    PreparedStatement genreStatement, starsStatement;
    String genreQuery = "select name from genres where id in (select genre_id from genres_in_movies where movie_id = ?);";
    String starsQuery = "select CONCAT(first_name, \" \", last_name) as full_name, id, photo_url from stars where id in (select star_id from stars_in_movies where movie_id = ?);";
    genreStatement = dbcon.prepareStatement(genreQuery);
    starsStatement = dbcon.prepareStatement(starsQuery);

    Movie movie = new Movie();

    while (rs.next()) {

        //Get movie information
        String resultId = rs.getString("id");
        String resultYear = rs.getString("year");
        String resultTitle = rs.getString("title");
        String resultDirector = rs.getString("director");
        String resultBanner = rs.getString("banner_url");
        String resultTrailer = rs.getString("trailer_url");

        movie.id = resultId;
        movie.year = resultYear;
        movie.title = resultTitle;
        movie.director = resultDirector;
        movie.bannerURL = resultBanner;
        movie.trailerURL = resultTrailer;

        genreStatement.setString(1, resultId);
        ResultSet genreResultSet = genreStatement.executeQuery();
        while (genreResultSet.next()){
            String resultGenre = genreResultSet.getString("name");
            movie.genres.add(resultGenre);
        }

        genreResultSet.close();

        starsStatement.setString(1,resultId);
        ResultSet starsResultSet = starsStatement.executeQuery();
        while (starsResultSet.next()){
            String resultName = starsResultSet.getString("full_name");
            String resultSID = starsResultSet.getString("id");
            String resultPhotoURL = starsResultSet.getString("photo_url");
            movie.stars.add(new Star(resultSID, resultName, resultPhotoURL));
        }
        starsResultSet.close();
    }


    //Close prepared statements
    genreStatement.close();
    starsStatement.close();
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
        <div id="headerSmall"><a href="/panel.php" class="link-mal-logo">MyAnimeList.net</a>
            <div id="header-menu" class="pulldown"></div>
        </div>
        <div id="menu" class="">
            <div id="menu_left">
                <ul id="nav">
                    <li class="small">
                        <a href="search.jsp" class="non-link">Search</a>
                    </li>
                    <li class="small">
                        <a href="browse.jsp" class="non-link">Browse</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="contentWrapper" itemscope="" itemtype="http://schema.org/Product">
            <div><h1 class="h1"><span itemprop="name"><% out.println(movie.title); %></span></h1></div>
            <div id="content">

                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                    <tr>
                        <td class="borderClass" width="225" style="border-width: 0 1px 0 0;" valign="top">
                            <div class="js-scrollfix-bottom" style="width: 225px; position: static">
                                <div style="text-align: center;">
                                    <a href="https://myanimelist.net/anime/25777/Shingeki_no_Kyojin_Season_2/pics">
                                        <img width="225" height="321" src="<% out.println(movie.bannerURL); %>" alt="Shingeki no Kyojin Season 2" class="ac" itemprop="image">
                                    </a>
                                </div>
                                <h2>Information</h2>
                                <div>
                                    <span class="dark_text">Title:</span>
                                    <% out.println(movie.title); %>
                                </div>
                                <div class="spaceit">
                                    <span class="dark_text">Year:</span>
                                    <% out.println(movie.year); %>
                                </div>
                                <div>
                                    <span class="dark_text">Director:</span>
                                    <% out.println(movie.director); %>
                                </div>
                                <div class="spaceit">
                                    <span class="dark_text">Genres:</span>
                                    <% for (String genre : movie.genres)
                                        out.println("<a>" + genre + ",</a>");
                                    %>
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
                                        <td valign="top">
                                            <div class="pb16">
                                                <div class="di-t w100 mt12">
                                                    <div class="anime-detail-header-video di-tc va-t pl16" style="width:200px;">
                                                        <div class="video-promotion">
                                                            <%
                                                                String url = movie.trailerURL;
                                                                String style = "";
                                                                if (url != null) {
                                                                    String ytID = url.substring(url.indexOf("=") + 1);
                                                                    style = "background-image:url('https://i1.ytimg.com/vi/" + ytID +"/mqdefault.jpg')";
                                                                }
                                                            %>
                                                            <a class="iframe js-fancybox-video video-unit promotion" href="https://www.youtube.com/embed/zLaVP8IhIuc?enablejsapi=1&amp;wmode=opaque&amp;autoplay=1" style="<% out.println(style); %>" rel="gallery">
                                                            <div class="info-container">
                                                                <span class="title pl4 pr4">Trailer</span></div>
                                                            <span class="btn-play" style="background-color: rgba(255, 255, 255, 0);">play</span></a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="js-myinfo-error badresult-text al pb4"
                                                     style="display:none;"></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="pb24"><br><br>
                                            <h2>
                                                <div class="floatRightHeader"></div>
                                                Characters &amp; Voice Actors
                                            </h2>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%"><tbody><tr><td valign="top" width="27" class="borderClass bgColor2" align="center"><div class="picSurround">
                                                                <a href="/character/40881/Mikasa_Ackerman" style="font-weight: normal;">
                                                                    <img src="https://myanimelist.cdn-dena.com/r/46x64/images/characters/9/215563.webp?s=a12e4bc7a7cf9b18f23b8d9d589a2268" width="23" height="32" alt="Ackerman, Mikasa" vspace="4" hspace="8" border="0">
                                                                </a></div></td><td valign="top" class="borderClass bgColor2">
                                                            <a href="/character/40881/Mikasa_Ackerman">Ackerman, Mikasa</a>
                                                        </td></tr></tbody></table>
                                            <%
                                                for (Star actor : movie.stars) {
                                                    out.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"><tbody><tr><td valign=\"top\" width=\"27\" class=\"borderClass bgColor2\" align=\"center\"><div class=\"picSurround\">");
                                                    out.println("<a href=\"star.jsp?id=" + actor.id + "\"" + "style=\"font-weight: normal;\">");
                                                    out.println("<img src=\"" + actor.photoURL + "\"" + "width=\"23\" height=\"32\" alt=\"Ackerman, Mikasa\" vspace=\"4\" hspace=\"8\" border=\"0\">");
                                                    out.println("</a></div></td><td valign=\"top\" class=\"borderClass bgColor2\">");
                                                    out.println("<a href=\"star.jsp?id=" + actor.id + "\">" + actor.name + "</a>");
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


<div id="evolve_footer"></div>

<div id="fancybox-tmp" style="padding: 70px;"></div>
<div id="fancybox-loading" style="display: none;">
    <div></div>
</div>
<div id="fancybox-overlay" style="background-color: rgb(102, 102, 102); opacity: 0.3; display: none;"></div>
<div id="fancybox-wrap"
     style="opacity: 1; width: 1172.8px; height: 673.6px; top: 89.2px; left: 151.6px; display: none;">
    <div id="fancybox-outer">
        <div class="fancy-bg" id="fancy-bg-n"></div>
        <div class="fancy-bg" id="fancy-bg-ne"></div>
        <div class="fancy-bg" id="fancy-bg-e"></div>
        <div class="fancy-bg" id="fancy-bg-se"></div>
        <div class="fancy-bg" id="fancy-bg-s"></div>
        <div class="fancy-bg" id="fancy-bg-sw"></div>
        <div class="fancy-bg" id="fancy-bg-w"></div>
        <div class="fancy-bg" id="fancy-bg-nw"></div>
        <div id="fancybox-inner" style="top: 0px; left: 0px; width: 1172.8px; height: 673.6px; overflow: hidden;"></div>
        <a id="fancybox-close" style="display: none;"></a><a href="javascript:;" id="fancybox-left"
                                                             style="display: none;"><span class="fancy-ico"
                                                                                          id="fancybox-left-ico"></span></a><a
            href="javascript:;" id="fancybox-right" style="display: none;"><span class="fancy-ico"
                                                                                 id="fancybox-right-ico"></span></a>
    </div>
</div>
<div id="fb-root" class=" fb_reset">
    <div style="position: absolute; top: -10000px; height: 0px; width: 0px;">
        <div></div>
    </div>
    <div style="position: absolute; top: -10000px; height: 0px; width: 0px;">
        <div>
            <iframe name="fb_xdm_frame_https" frameborder="0" allowtransparency="true" allowfullscreen="true"
                    scrolling="no" id="fb_xdm_frame_https" aria-hidden="true"
                    title="Facebook Cross Domain Communication Frame" tabindex="-1"
                    src="https://staticxx.facebook.com/connect/xd_arbiter/r/87XNE1PC38r.js?version=42#channel=f98bce420245c8&amp;origin=https%3A%2F%2Fmyanimelist.net"
                    style="border: none;"></iframe>
        </div>
    </div>
</div>
</body>
</html>