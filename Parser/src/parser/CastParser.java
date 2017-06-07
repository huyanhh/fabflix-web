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

public class CastParser {

    public void parse(String fileName, Set<StarFilmRelation> relations) throws ParserConfigurationException, SAXException, IOException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document docs = db.parse(fileName);

        NodeList filmIDList = docs.getElementsByTagName("m");
        for (int i = 0; i < filmIDList.getLength(); i++) {
            Element el = (Element) filmIDList.item(i);
            StarFilmRelation sfr = getCast(el);
            relations.add(sfr);
        }
    }
        

    private StarFilmRelation getCast(Element castEl) {
//        String title = getTextValue(castEl, "t");
        String film = getTextValue(castEl, "f");
        String stageName = getTextValue(castEl, "a");
        
        StarFilmRelation sfr = new StarFilmRelation (stageName, film);
        return sfr;
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

    public void printDataSet(Set<StarFilmRelation> starFilmSet) {
        for (StarFilmRelation sfr: starFilmSet) {
            System.out.println(sfr.toString());
        }
    }

}
