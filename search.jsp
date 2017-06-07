<%@page import="java.sql.*,
                javax.sql.*,
                java.io.IOException,
                javax.servlet.http.*,
                javax.servlet.*"
%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="movies.Movie" %>
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
            <div><h1 class="h1">Movie Search</h1></div>
            <div id="content">
                <div>
                    <form id="advancedsearch" data-type="anime" method="GET" action="/servlet/MovieList"
                          class="js-advancedsearch" _lpchecked="1">
                        <div class="anime-search-form-block po-r">
                            <div class="anime-search-form-search clearfix mb8">
                                <input id="q" name="movieTitle" size="50" type="text" autocomplete="off" placeholder="Search By Title..." class="inputtext js-advancedSearchText" onkeyup="ajaxSearch(this.value)" style="border-radius:0px;">
                                <input type="hidden" name="fromSearchPage" value="true"> 
                                <input type="submit" value="Go" class="inputButton notActive">
                            </div>
                            <div style = "margin:0px auto;">
                                <div id = "ajaxSearchResults" style="width:695px; margin-top:-8px;"></div>
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
                                    <td><input class="inputtext" type="text" name="starFirstName" placeholder="Star's First Name"></td>
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

<script language="javascript" type="text/javascript">

    function ajaxSearch(searchValue) {
        if (searchValue.length == 0) {
            document.getElementById("ajaxSearchResults").innerHTML = "";
            document.getElementById("ajaxSearchResults").style.border = "0px";
            return;
        }
        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        } else {  // code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if (this.responseText.length > 0){
                  document.getElementById("ajaxSearchResults").innerHTML = this.responseText;
                  document.getElementById("ajaxSearchResults").style.border = "1px solid #A5ACB2";
                  document.getElementById("ajaxSearchResults").style.borderTop = "0px";
                  document.getElementById("ajaxSearchResults").style.padding = "10px";
                  document.getElementById("ajaxSearchResults").style.fontSize = "medium";
                }
            }
        }
        xmlhttp.open("GET","/servlet/AjaxSearch?movieTitle=" + searchValue,true);
        xmlhttp.send();
    }
</script>

</body>
</html>
