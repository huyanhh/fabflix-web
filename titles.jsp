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
                    <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">--%>
                        <%--<tbody>--%>
                        <%--</tbody>--%>
                    <%--</table>--%>
                    <%
                        List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                        for (Movie movie : movies ) {
                            out.println("<br/>" + movie.id);
                            out.println("<br/>" + movie.title);
                            out.println("<br/>" + movie.year);
                            out.println("<br/>" + movie.director);
                        }
                    %>
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