### to compile stuff:

```apple js
javac -classpath "../lib/mysql-connector-java-5.1.4:../lib/servlet-api.jar:." MovieList.java 
```

```apple js
jar -cvf ROOT.war * 
```

to compile, you must be in the /src/ folder. when you download the .war file, rename it to ROOT,
because we use fabflix as localhost:8080/ so the url is nicer.

After compiling, drag the folder to WEB-INF/classes.

If the Constants.java is changed, the new destination will be at WEB-INF/classes/movies

Normally, if the non package java files are compiled, Constants.java will also be compiled because
it's an imported file, so you don't have to compile it manually

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
- add checkout feature
- add add to cart feature

