<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException"
%>
<%@ page import="movies.Constants" %>
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
    <link rel="stylesheet" type="text/css" href="css/mal.css">
    <script type="text/javascript" async=""
            src="https://www.gstatic.com/recaptcha/api2/r20170411114922/recaptcha__en.js"></script>
    <script async="" type="text/javascript" src="https://www.googletagservices.com/tag/js/gpt.js"></script>
    <script type="text/javascript"
            src="https://myanimelist.cdn-dena.com/static/assets/js/pc/header-61a5e90384.js"></script>
</head>

<body onload=" " class="page-common">
<div id="myanimelist">

    <div class="wrapper">
        <div id="headerSmall">
            <a href="/" class="">Fabflix</a>
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
            <div><h1 class="h1">Browse Movies</h1></div>
            <div id="content">

                <div id="horiznav_nav" class="ac mt8 ml0 mr0"></div>

                <div class="anime-manga-search pb24">
                    <div class="normal_header pt24 mb0">Genres</div>
                    <div class="genre-link">
                        <%
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection connection = DriverManager.getConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false", Constants.USER, Constants.PASSWORD);
                            Statement select = connection.createStatement();
                            ResultSet result = select.executeQuery("select *  from genres; ");
                            int col = 0;
                            out.println("<div class=\"genre-list-col\">");

                            while (result.next()){
                                if (col % 5 == 0) {
                                    out.println("</div>");
                                    out.println("<div class=\"genre-list-col\">");
                                }
                                String genre = result.getString("name");
                                out.println("<div class=\"genre-list al\">");
                                out.println("<a href = '/servlet/MovieList?movieGenre=" + genre + "' class=\"genre-name-link\">" + genre + "</a>");
                                out.println("</div>");
                                col++;
                            }
                            out.println("</div>");

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