<%@ page import="java.sql.*,
                 javax.sql.*,
                 java.io.IOException,
                 javax.servlet.*,
                 javax.servlet.http.*"
%>
<%@ page import="movies.Constants" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%

  //Get session attributes

  String loggedIn = (String)session.getAttribute("employeeLoggedIn");

  //Check to see if the user has logged in. If not, redirect user to the login page.
  if (loggedIn == null){
    out.println("<script> window.location.replace('_dashboard.jsp'); </script>");
  }

%>

<%
  //Connection pooling
  Context initCtx = new InitialContext();
  if (initCtx == null)
      out.println("initCtx is NULL");

  Context envCtx = (Context) initCtx.lookup("java:comp/env");
  if (envCtx == null)
      out.println("envCtx is NULL");

  //Look up data source
  DataSource ds = (DataSource) envCtx.lookup("jdbc/WriteDB");

  //Establish connection with data source
  if (ds == null)
      out.println("ds is null.");

  Connection connection = ds.getConnection();
  if (connection == null)
      out.println("connection is null.");

  String firstName = request.getParameter("first_name");
  String lastName = request.getParameter("last_name");
  String dob = request.getParameter("dob");
  String photoURL = request.getParameter("photo_url");

  if(request.getParameter("submitted") != null){
    insertStar(response.getWriter(), connection, firstName, lastName, dob, photoURL);
    out.println("<script> window.location.replace('dashboard.jsp'); </script>");
  }
%>
<%!
  // change to return just string
  private void insertStar(PrintWriter out, Connection connection, String firstName, String lastName, String dob, String photoURL) {
    try {
      //Declare variables
      boolean dobUsed = false, photoURLUsed = false;

      //Get name. If only 1 name provided, first name = "" and last name = name provided
      String fullName = firstName + lastName;
      if (fullName.length() == 0) {
        out.println("<script>alert('Please provide a valid name!')</script>");
        return;
      } else {
        if (lastName.equals("")) {
          lastName = firstName;
          firstName = "";
        }
      }
      //Get date of birth and/or photo url. If user actually provided a dob and/or photoURL, then update dobUsed and photoURLUsed
      if (dob.length() > 0) {
        dobUsed = true;
      }

      if (photoURL.length() > 0) {
        photoURLUsed = true;
      }

      //Store the star into the database based on the information the user provided.
      Statement select = connection.createStatement();
      int result = 0;
      if (!dobUsed && !photoURLUsed) {
        result = select.executeUpdate(String.format("insert into stars (first_name, last_name) values('%s','%s')", firstName, lastName));
      } else if (dobUsed && !photoURLUsed) {
        result = select.executeUpdate(String.format("insert into stars (first_name, last_name, dob) values('%s','%s','%s')", firstName, lastName, dob));
      } else if (!dobUsed && photoURLUsed) {
        result = select.executeUpdate(String.format("insert into stars (first_name, last_name, photo_url) values('%s','%s','%s')", firstName, lastName, photoURL));
      } else {
        result = select.executeUpdate(String.format("insert into stars (first_name, last_name, dob, photo_url) values('%s','%s','%s','%s')", firstName, lastName, dob, photoURL));
      }

      String message;
      //Print out success or fail message based upon whether the user was successfully stored in the database or not
      if (result == 1) {
        message = String.format("You have successfully inserted %s %s!", firstName, lastName);
      } else {
        message = "You have failed to insert the star!";
      }
      out.println("<script>alert('" + message + "')</script>");
      //Close Statement
      select.close();
    } catch (SQLException e) {
      out.println("<script>alert('Star could not be inserted. Please try again.')</script>");
    }
  }

%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <link rel="icon" type="image/png" href="resources/img/favicon.ico">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

  <title>Light Bootstrap Dashboard by Creative Tim</title>

  <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport'/>
  <meta name="viewport" content="width=device-width"/>


  <!-- Bootstrap core CSS     -->
  <link href="resources/css/bootstrap.min.css" rel="stylesheet"/>

  <!-- Animation library for notifications   -->
  <link href="resources/css/animate.min.css" rel="stylesheet"/>

  <!--  Light Bootstrap Table core CSS    -->
  <link href="resources/css/light-bootstrap-dashboard.css" rel="stylesheet"/>

  <!--     Fonts and icons     -->
  <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
  <link href='http://fonts.googleapis.com/css?family=Roboto:400,700,300' rel='stylesheet' type='text/css'>
  <link href="resources/css/pe-icon-7-stroke.css" rel="stylesheet"/>

</head>
<body>

<div class="wrapper">
  <div class="sidebar" data-color="purple" data-image="resources/img/sidebar-5.jpg">

    <!--

        Tip 1: you can change the color of the sidebar using: data-color="blue | azure | green | orange | red | purple"
        Tip 2: you can also add an image using data-image tag

    -->

    <div class="sidebar-wrapper">
      <div class="logo">
        <a href="http://www.creative-tim.com" class="simple-text">
          Fabflix Admin
        </a>
      </div>

      <ul class="nav">
        <li class="active">
          <a href="dashboard.jsp">
            <i class="pe-7s-graph"></i>
            <p>Dashboard</p>
          </a>
        </li>

      </ul>
    </div>
  </div>

  <div class="main-panel">
    <nav class="navbar navbar-default navbar-fixed">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Dashboard</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav navbar-left">
            <li>
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-dashboard"></i>
              </a>
            </li>
          </ul>

          <ul class="nav navbar-nav navbar-right">
            <li>
              <a href="">
                Account
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>


    <div class="content">
      <div class="container-fluid">
        <div class="row">
          <%--insert star--%>
          <div class="col-md-12">
            <div class="card">
              <div class="header">
                <h4 class="title">Insert a Star into the Database</h4>
              </div>
              <div class="content">
                <form method="post" action="dashboard.jsp" name="add_star">

                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>First Name</label>
                        <input type="text" class="form-control" placeholder="First Name" name="first_name" value="">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" class="form-control" placeholder="Last Name" name="last_name" value="">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label>Photo URL (optional)</label>
                        <input type="text" class="form-control" placeholder="https://google.com/img&=asdfqwe1234"
                               name="photo_url" value="">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label>dob (optional). Format is YYYY-MM-DD</label>
                        <input type="text" class="form-control" placeholder="2017-05-12" name="dob" value="">
                      </div>
                    </div>
                  </div>

                  <input type="hidden" name="submitted">
                  <button type="submit" class="btn btn-info btn-fill pull-right">Add Star</button>
                  <div class="clearfix"></div>
                </form>
              </div>
            </div>
          </div>

          <%--insert movie--%>
          <div class="col-md-12">
            <div class="card">
              <div class="header">
                <h4 class="title">Insert a Movie into the Database</h4>
              </div>
              <div class="content">
                <form method="post" action="MovieInsert" name="add_movie">

                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Title</label>
                        <input type="text" class="form-control" placeholder="Ip Man 2" name="title" value="" style="background-image: url(&quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABHklEQVQ4EaVTO26DQBD1ohQWaS2lg9JybZ+AK7hNwx2oIoVf4UPQ0Lj1FdKktevIpel8AKNUkDcWMxpgSaIEaTVv3sx7uztiTdu2s/98DywOw3Dued4Who/M2aIx5lZV1aEsy0+qiwHELyi+Ytl0PQ69SxAxkWIA4RMRTdNsKE59juMcuZd6xIAFeZ6fGCdJ8kY4y7KAuTRNGd7jyEBXsdOPE3a0QGPsniOnnYMO67LgSQN9T41F2QGrQRRFCwyzoIF2qyBuKKbcOgPXdVeY9rMWgNsjf9ccYesJhk3f5dYT1HX9gR0LLQR30TnjkUEcx2uIuS4RnI+aj6sJR0AM8AaumPaM/rRehyWhXqbFAA9kh3/8/NvHxAYGAsZ/il8IalkCLBfNVAAAAABJRU5ErkJggg==&quot;); background-repeat: no-repeat; background-attachment: scroll; background-size: 16px 18px; background-position: 98% 50%; cursor: auto;">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Year</label>
                        <input type="text" class="form-control" placeholder="2010" name="year" value="">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Director</label>
                        <input type="text" class="form-control" placeholder="Michael Bay" name="director" value="">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Star First Name</label>
                        <input type="text" class="form-control" placeholder="Donnie" name="first_name" value="">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Star Last Name</label>
                        <input type="text" class="form-control" placeholder="Yen" name="last_name" value="">
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Genre name</label>
                        <input type="text" class="form-control" placeholder="Kung Fu" name="genre_name" value="">
                      </div>
                    </div>
                  </div>

                  <button type="submit" class="btn btn-info btn-fill pull-right">Add Movie</button>
                  <div class="clearfix"></div>
                </form>
              </div>
            </div>
          </div>

          <%--metadata--%>
          <div class="col-md-10">
            <div class="card">
              <div class="header">
                <h4 class="title">Metadata</h4>
                <%--<p class="category">Credit Cards</p>--%>
              </div>
              <%--<div class="content table-responsive table-full-width">--%>
              <%--<table class="table table-hover table-striped">--%>
              <%--<thead>--%>
              <%--<tr>--%>
              <%--<th>Name</th>--%>
              <%--<th>Datatype</th>--%>
              <%--</tr>--%>
              <%--</thead>--%>
              <%--<tbody>--%>
              <%--<tr>--%>
              <%--<td>first_name</td>--%>
              <%--<td>VARCHAR</td>--%>
              <%--</tr>--%>
              <%--</tbody>--%>
              <%--</table>--%>
              <%--</div>--%>
              <%
                String selectStatement = "SELECT * FROM ";
                String[] tables = {"sales", "creditcards", "customers", "movies", "stars", "employees",
                    "genres_in_movies", "stars_in_movies", "genres"};
                try {
                  PreparedStatement ps = null;
                  for (String table : tables) {
                    String psQuery = selectStatement + table;
                    ps = connection.prepareStatement(psQuery);
                    ResultSet result = ps.executeQuery();
                    if (result.next()) {
                      ResultSetMetaData metadata = result.getMetaData();
                      int columns = metadata.getColumnCount();
                      out.println(String.format("<div class=\"header\">" +
                              "<p class=\"category\">%s</p>" +
                              "</div>",
                          metadata.getTableName(1))
                      );
                      out.println(
                          "<div class=\"content table-responsive table-full-width\">" +
                              "<table class=\"table table-hover table-striped\">" +
                              "<thead>" +
                              "<tr>" +
                              "<th>Name</th>" +
                              "<th>Datatype</th>" +
                              "</tr>" +
                              "</thead>" +
                              "<tbody>");
                      for (int i = 1; i < columns; i++) {
                        out.println(String.format(
                            "<tr>" +
                                "<td>%-15s</td>" +
                                "<td>%s</td>" +
                                "</tr>"
                            ,metadata.getColumnName(i), metadata.getColumnTypeName(i))
                        );
                      }
                      out.println(
                          "</tbody>" +
                              "      </table>" +
                              "     </div>"
                      );
                    }
                  }
                  if (ps != null){
                    ps.close();
                  }
                } catch (SQLException e) {
                  out.println("<script>alert('There was an error retrieving the metadata')</script>");
                }
              %>

            </div>
          </div>

        </div>

      </div>
    </div>


    <footer class="footer">
      <div class="container-fluid">
        <nav class="pull-left">
          <ul>
            <li>
              <a href="#">
                Home
              </a>
            </li>

          </ul>
        </nav>
        <p class="copyright pull-right">
          &copy;
          <script>document.write(new Date().getFullYear())</script>
          <a href="http://www.creative-tim.com">Creative Tim</a>, made with love for a better web
        </p>
      </div>
    </footer>

  </div>
</div>


</body>

<!--   Core JS Files   -->
<script src="resources/js/jquery-1.10.2.js" type="text/javascript"></script>
<script src="resources/js/bootstrap.min.js" type="text/javascript"></script>

<!--  Checkbox, Radio & Switch Plugins -->
<script src="resources/js/bootstrap-checkbox-radio-switch.js"></script>

<!--  Charts Plugin -->
<script src="resources/js/chartist.min.js"></script>

<!--  Notifications Plugin    -->
<script src="resources/js/bootstrap-notify.js"></script>

<!--  Google Maps Plugin    -->
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<!-- Light Bootstrap Table Core javascript and methods for Demo purpose -->
<script src="resources/js/light-bootstrap-dashboard.js"></script>

<!-- Light Bootstrap Table DEMO methods, don't include it in your project! -->
<script src="resources/js/demo.js"></script>


</html>
