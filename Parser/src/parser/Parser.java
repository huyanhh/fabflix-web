package parser;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXException;

/**
 *
 * @author krish
 */
public class Parser {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        ActorParser a = new ActorParser();
        FilmParser f = new FilmParser();
        CastParser c = new CastParser();
        
        Map<String, Actor> actors = new HashMap<String, Actor> ();
        Map<String, Film> films = new HashMap<String, Film> ();
        Map<String, Genre> genres = new HashMap<String, Genre>();
        Set<StarFilmRelation> sm_relation = new HashSet();
        Set<FilmGenreRelation> fg_relation = new HashSet();
        
        try {
            actors = a.parse("stanford-movies/actors63.xml");
            f.parse("stanford-movies/mains243.xml", films, genres, fg_relation);
            c.parse("stanford-movies/casts124.xml", sm_relation);
            
        } catch (IOException | ParserConfigurationException | SAXException ex) {
            System.out.println(ex.getMessage());
        }

        Database db = new Database();
        db.insert(actors, films, genres, sm_relation, fg_relation);
    }

}
