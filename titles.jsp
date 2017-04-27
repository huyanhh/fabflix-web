<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%@ page import="java.util.List" %>
<%@ page import="movies.Movie" %>
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
<!DOCTYPE html>
<html>
<head>
    <%--<link rel="stylesheet" type="text/css" href="css/mal.css">--%>
    <link rel="stylesheet" type="text/css" href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-cfe6975aa5.css">
    <script type="text/javascript" async=""
            src="https://www.gstatic.com/recaptcha/api2/r20170411114922/recaptcha__en.js"></script>
    <script async="" type="text/javascript" src="https://www.googletagservices.com/tag/js/gpt.js"></script>
    <script type="text/javascript"
            src="https://myanimelist.cdn-dena.com/static/assets/js/pc/header-61a5e90384.js"></script>
</head>

<body onload=" " class="page-common">
<div id="myanimelist">
    <div class="_unit " style="width:1px;display: block !important;" data-height="1">
        <div id="skin_detail" class="" style="width:1px;">
            <script type="text/javascript">
                googletag.cmd.push(function () {
                    var slot = googletag.defineOutOfPageSlot("/84947469/skin_detail", "skin_detail").addService(googletag.pubads())
                        .setTargeting("adult", "white").setCollapseEmptyDiv(true, true);
                    googletag.enableServices();

                    googletag.display("skin_detail");
                });</script>
        </div>
    </div>

    <div class="wrapper">
        <div id="headerSmall">
            <a href="/" class="">Fabflix</a>
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
                </ul>
            </div>
        </div>
        <div id="contentWrapper" itemscope="" itemtype="http://schema.org/Product">
            <div><h1 class="h1">Browse Movies</h1></div>
            <div id="content">

                <div id="horiznav_nav" class="ac mt8 ml0 mr0">
                </div>

                <script language="javascript" type="text/javascript">
                    function search_animeSearchLoad() {
                        var titleObj = document.getElementById("q");
                        titleObj.focus();
                    }

                    function search_showAdvanced() {
                        $("#advancedSearch").toggle();
                    }
                </script>

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
                            <td class="borderClass bgColor1 ac fw-b" valign="top">Title</td>
                            <%--<td class="borderClass bgColor1 ac fw-b" width="45" nowrap="">--%>
                                <%--<a href="?letter=A&amp;sy=0&amp;sm=0&amp;sd=0&amp;ey=0&amp;em=0&amp;ed=0&amp;o=6&amp;w=1"><i--%>
                                    <%--class="fa fa-sort ml2"></i></a></td>--%>
                            <%--<td class="borderClass bgColor1 ac fw-b" width="40" nowrap="">--%>
                                <%--<a href="?letter=A&amp;sy=0&amp;sm=0&amp;sd=0&amp;ey=0&amp;em=0&amp;ed=0&amp;o=4&amp;w=1"><i--%>
                                    <%--class="fa fa-sort ml2"></i></a></td>--%>
                            <td class="borderClass bgColor1 ac fw-b" width="135" nowrap="">
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

                                out.println("<a href='./MovieList?method=AscYear" + options + "'>Asc </a> &nbsp <a href='./MovieList?method=DescYear" + options + "'> Desc</a></td>");
                                %>
                                <a href="">Year<i
                                    class="fa fa-sort ml2"></i></a></td>
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
                            //TODO krishna here
                            List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                            for (Movie movie : movies ) {
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
                            Connection connection =
                                    DriverManager.getConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false", "root", "");
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