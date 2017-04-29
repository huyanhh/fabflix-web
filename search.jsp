<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException,
                javax.servlet.http.*,
                javax.servlet.*"
%>
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
    <title>Search</title>
    <%--<link rel="stylesheet" type="text/css"--%>
          <%--href="https://myanimelist.cdn-dena.com/static/assets/css/pc/style-cfe6975aa5.css">--%>
    <link rel="stylesheet" type="text/css" href="css/mal.css">
</head>
<body class="page-common">

<div id="myanimelist">

    <div class="wrapper">
        <div id="headerSmall" style="background-image: url(resources/logo_small.png)"><a href="/panel.php" class="link-mal-logo">Fabflix</a></div>
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
            <div><h1 class="h1">Movie Search</h1></div>
            <div id="content">
                <div>
                    <form id="advancedsearch" data-type="anime" method="GET" action="/servlet/MovieList"
                          class="js-advancedsearch" _lpchecked="1">
                        <div class="anime-search-form-block po-r">
                            <div class="anime-search-form-search clearfix mb8"><input id="q" name="movieTitle" size="50"
                                                                                      type="text" autocomplete="off"
                                                                                      placeholder="Search By Title..."
                                                                                      class="inputtext js-advancedSearchText">
                                <input type="submit" value="Go" class="inputButton notActive">
                            </div>
                        </div>
                        <div id="advancedSearch" style="">

                            <div class="normal_header pt24 mt16 mb0">Filters</div>
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tbody>
                                <tr>
                                    <td width="100">Year</td>
                                    <td><input class="inputtext" type="text" name="movieYear" placeholder="Year"></td>
                                </tr>
                                <tr>
                                    <td width="100">Director</td>
                                    <td><input class="inputtext" type="text" name="movieDirector" placeholder="Director"></td>
                                </tr>
                                <tr>
                                    <td width="100">Star First Name</td>
                                    <td><input class="inputtext" type="text" name="starLastName" placeholder="Star's Last Name"></td>
                                </tr>
                                <tr>
                                    <td width="100">Star Last Name</td>
                                    <td><input class="inputtext" type="text" name="starLastName" placeholder="Star's Last Name"></td>
                                </tr>
                                </tbody>
                            </table>


                            <div class="mt8 mb24 pb16 ac"><input type="submit" value="Search" class="inputButton btn-form-submit notActive"></div>
                        </div>
                    </form>

                </div>
            </div><!-- end of contentHome -->
        </div>
    </div><!-- wrapper -->

</div>

</body>
</html>

