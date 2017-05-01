### to compile stuff:

```apple js
javac -classpath "../lib/mysql-connector-java-5.1.4:../lib/servlet-api.jar:." MovieList.java 
```

to compile, you must be in the /src/ folder. when you download the .war file, rename it to ROOT,
because we use fabflix as localhost:8080/. 



Styling taken from [myanimelist](https://myanimelist.net)

### Changes

- removed all ads
- replaced images with images from database
- moved the search function to a different page
- removed breadcrumbs
- removed all headers and replaced with search, browse, checkout, logout
- replaced logo
- modify table formatting
- removed extraneous fonts

### Project specific requirements

Our queries use: 'ABC%': All strings that start with 'ABC'. For example, 'ABCD' and 'ABCABC' would both satisfy the condition.

First we append "%" to the end of each GET variable which will be used for LIKE in the query. We get the variables from
the url parameters. Then we execute the query.