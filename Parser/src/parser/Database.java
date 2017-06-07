package parser;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author krish
 */
public class Database {

    Connection conn;

    public Database() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        String host = "jdbc:mysql://localhost:3306/moviedb";
        String username = "root";
        String password = "krishnam21";
        conn = DriverManager.getConnection(host, username, password);
    }

    public void clear() throws SQLException {
        this.conn.createStatement().executeUpdate("DELETE FROM stars_in_movies;");
        this.conn.createStatement().executeUpdate("DELETE FROM genres_in_movies");
        this.conn.createStatement().executeUpdate("DELETE FROM sales");
        this.conn.createStatement().executeUpdate("DELETE FROM movies;");
        this.conn.createStatement().executeUpdate("DELETE FROM stars;");
        this.conn.createStatement().executeUpdate("DELETE FROM genres;");
    }

    public void insert(Map<String, Actor> actors, Map<String, Film> films, Map<String, Genre> genres, Set<StarFilmRelation> relation1, Set<FilmGenreRelation> relation2) throws SQLException {
        this.conn.setAutoCommit(false);

        PreparedStatement ps = this.conn.prepareStatement("INSERT INTO stars (id, first_name, last_name, dob) VALUES (NULL, ?, ?, ?);",
                Statement.RETURN_GENERATED_KEYS);

        PreparedStatement ps1 = this.conn.prepareStatement("INSERT INTO movies (id, title, year, director) VALUES (NULL, ?, ?, ?);",
                Statement.RETURN_GENERATED_KEYS);

        PreparedStatement ps2 = this.conn.prepareStatement("INSERT INTO genres (id, name) VALUES (NULL, ?);",
                Statement.RETURN_GENERATED_KEYS);

        PreparedStatement ps3 = this.conn.prepareStatement("INSERT INTO stars_in_movies (star_id, movie_id) VALUES (?, ?);",
                Statement.RETURN_GENERATED_KEYS);

        PreparedStatement ps4 = this.conn.prepareStatement("INSERT INTO genres_in_movies (genre_id, movie_id) VALUES (?, ?);",
                Statement.RETURN_GENERATED_KEYS);
//////////////////////////
        for (Actor actor : actors.values()) {
            ps.setString(1, actor.firstName);
            ps.setString(2, actor.lastName);
            if (actor.dob != null) {
                java.sql.Date sqlDate = new java.sql.Date(actor.dob.getTime());
                ps.setDate(3, sqlDate);
            } else {
                ps.setDate(3, null);
            }
            ps.addBatch();
        }
        ps.executeBatch();
        ResultSet actor_ids = ps.getGeneratedKeys();
        for (Actor actor : actors.values()) {
            actor_ids.next();
            actor.id = actor_ids.getInt("GENERATED_KEY");
        }
////////////////////////////////
        for (Film film : films.values()) {
            ps1.setString(1, film.title);
            ps1.setInt(2, film.year);
            ps1.setString(3, film.director);

            ps1.addBatch();
        }
        ps1.executeBatch();
        ResultSet film_ids = ps1.getGeneratedKeys();
        for (Film film : films.values()) {
            film_ids.next();
            film.id = film_ids.getInt("GENERATED_KEY");
        }
///////////////////////////////////
        for (Genre genre : genres.values()) {
            ps2.setString(1, genre.genre);
            ps2.addBatch();
        }
        
        ps2.executeBatch();
        ResultSet genre_ids = ps2.getGeneratedKeys();
        for (Genre genre : genres.values()) {
            genre_ids.next();
            genre.id = genre_ids.getInt("GENERATED_KEY");
        }
////////////////////////////////////////
        for (StarFilmRelation sfr : relation1) {
            Film film = films.get(sfr.fid);
            Actor star = actors.get(sfr.stagename);
            if (film == null || star == null) {
                if (film == null && star != null){
                    System.out.println("Relation in star but not in movie " + sfr.toString());
                }else if (star == null && film != null)  {
                    System.out.println("Relation in movie but not in star " + sfr.toString());
                }else {
                    System.out.println("Relation in neither movie or star " + sfr.toString());
                }
                continue;
            }
            Integer starId = star.id;
            Integer filmId = film.id;

            ps3.setInt(1, starId);
            ps3.setInt(2, filmId);

            ps3.addBatch();
        }
        ps3.executeBatch(); 
        
///////////////////////////////////
        for (FilmGenreRelation fgr : relation2) {
            Film film = films.get(fgr.filmId);
            Genre genre = genres.get(fgr.genreName);

            if (film == null || genre == null) {
                if (film == null && genre != null){
                    System.out.println("Relation in genre but not in movie " + fgr.toString());
                }else if (genre == null && film != null)  {
                    System.out.println("Relation in movie but not in genre " + fgr.toString());
                }else {
                    System.out.println("Relation in neither genre nor movie " + fgr.toString());
                }
                continue;
            }
        
            Integer genreId = genre.id;
            Integer movieId = film.id;
            ps4.setInt(1, genreId);
            ps4.setInt(2, movieId);

            ps4.addBatch();
        }
        ps4.executeBatch();

        this.conn.commit();
        this.conn.setAutoCommit(true);
    }
}
