package parser;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class FilmParser {

    public void parse(String fileName, Map<String, Film> FilmMap, Map<String, Genre> genreMap, Set<FilmGenreRelation> relation) throws ParserConfigurationException, SAXException, IOException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document docs = db.parse(fileName);

        NodeList filmList = docs.getElementsByTagName("film");

        //watch for bad attributes like year 199x etc.
        for (int i = 0; i < filmList.getLength(); i++) {
            Element el = (Element) filmList.item(i);
            Film movie = getFilm(el);
            if (movie != null) {
                FilmMap.put(movie.fid, movie);
                NodeList genreSubNodes = el.getElementsByTagName("cats");
            
                //watch for bad genres like Ctxx,Fant*, H8, anti-clerical, pro-faith
                for (int j = 0; j < genreSubNodes.getLength(); j++) {
                    NodeList genreList = genreSubNodes.item(j).getChildNodes();
                    for (int k = 0; k < genreList.getLength(); k++) {
                        if (genreList.item(k).getNodeName().equals("cat")) {
                            String g = genreList.item(k).getTextContent();
                            Genre genre = new Genre(g);
                            if (!genre.genre.isEmpty()) {
                                genreMap.put(g, genre);
                                relation.add(new FilmGenreRelation(movie.fid, genre.genre));
                            }
                        }
                    }
                }
            }
        }
    }
        

    private Film getFilm(Element filmEl) {

        String title = getTextValue(filmEl, "t");
        String sYear = getTextValue(filmEl, "year");
        String fid = getTextValue(filmEl, "fid");
        if (fid == null) {
            fid = getTextValue(filmEl, "filmed");
        }
        String directorName = getTextValue(filmEl, "dirn");
        Integer year;
        try {
            year = Integer.parseInt(sYear);
        } catch (NumberFormatException e) {
            return null;
        }
        
        if (fid == null)
            return null;
        if (title == null){
            return null;
        }
        if (directorName == null){
            return null;
        }
        //Create a new Film with value read from xml
        Film f = new Film(fid, title, year, directorName);
        return f;
    }

    private String getTextValue(Element ele, String tagName) {
        String textVal = null;
        NodeList nl = ele.getElementsByTagName(tagName);
        if (nl != null && nl.getLength() > 0) {
            Element el = (Element) nl.item(0);
            if (el.getFirstChild() == null) {
                return null;
            }
            textVal = el.getFirstChild().getNodeValue();
        }
        return textVal;
    }

    public void printDataMap(Map<String, Film> FilmMap) {
        for (Film film : FilmMap.values()) {
            System.out.println(film.toString());
        }
    }

    public void printDataSet(Set<Genre> genres) {
        for (Genre g : genres) {
            System.out.println(g);
        }
    }

}
