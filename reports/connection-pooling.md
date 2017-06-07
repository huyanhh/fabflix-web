## Connection Pooling Explanation

Where it is used:

  Connection pooling is used in all of the .java servlet files located
  in the WEB-INF/src folder. It is also used in the following .jsp files:
    - browse.jsp
    - dashboard.jsp
    - genres.jsp
    - movie.jsp
    - search.jsp
    - shoppingCart.jsp
    - star.jsp
    - titles.jsp

  The context.xml file located in the META-INF folder specifies the
  username, password, and database url.

  The web.xml file located in the WEB-INF folder has been modified to
  include the <resource-ref> tag.

How it is used:

  Before connection pooling was used, each of the .java and .jsp files
  mentioned above contained the following code:

    String loginUser = "root";
    String loginPasswd = "Apple07";
    String loginUrl = "jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false";

    //Class.forName("org.gjt.mm.mysql.Driver");
    Class.forName("com.mysql.jdbc.Driver").newInstance();

    //Connect to the database
    Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

    ...

    //Close connection to the database
    dbcon.close();

  With this code, for each server request, a new connection to the database would be
  opened and closed. Because of this, this operation is very expensive.

  As a result, the above code was replaced with the following code to enable connection
  pooling and make it so that for each server request, a connection is extracted from the
  connection pool, used, and then put back into the connection pool when the request has
  finished, thus being a less expensive operation than the previous connection method.

    //Imports to enable connection pooling
    import javax.naming.InitialContext;
    import javax.naming.Context;
    import javax.sql.DataSource;

    ...

    //Connection pooling
    Context initCtx = new InitialContext();
    if (initCtx == null)
        out.println("initCtx is NULL");

    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    if (envCtx == null)
        out.println("envCtx is NULL");

    //Look up data source
    DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");

    //Establish connection with data source
    if (ds == null)
        out.println("ds is null.");

    Connection dbcon = ds.getConnection();
    if (dbcon == null)
        out.println("dbcon is null.");

    ...

    //Put connection back into the connection pool rather than explicitly close it.
    db.close();

  The database information such as the url, username, and password are retrieved from
  the context.xml file in the META-INF folder:

    <Context>

      <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
        maxTotal="100" maxIdle="30" maxWaitMillis="10000" username="root"
        password="Apple07" driverClassName="com.mysql.jdbc.Driver"
        url="jdbc:mysql:///moviedb?autoReconnect=true&amp;useSSL=false" />

    </Context>

  The web.xml file contains the <resource-ref> above the servlet code. The <res-ref-name>
  is the same name as the Resource name of the <Context> tag located in the context.xml
  file. The name of the resource is: jdbc/TestDB.

    <resource-ref>
      <description>
        Resource which is used for connection pooling.
      </description>
      <res-ref-name>
        jdbc/TestDB
      </res-ref-name>
      <res-type>
        javax.sql.DataSource
      </res-type>
      <res-auth>
        Container
      </res-auth>
    </resource-ref>
