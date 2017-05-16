/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package parser;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 *
 * @author krish
 */
public class ActorParser {

    public Map<String, Actor> parse(String fileName) throws ParserConfigurationException, SAXException, IOException {
        Map<String, Actor> ActorsMap = new HashMap<>();
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document docs = db.parse(fileName);

        NodeList actorElems = docs.getElementsByTagName("actors").item(0).getChildNodes();

        if (actorElems != null && actorElems.getLength() > 0) {
            for (int i = 0; i < actorElems.getLength(); i++) {
                if (!actorElems.item(i).getNodeName().equals("actor"))
                    continue;
                
                Element el = (Element) actorElems.item(i);

                //get the Actor object
                Actor actor = getActor(el);

                //add it to Map of Actors
                ActorsMap.put(actor.stageName, actor);
            }
        }
        return ActorsMap;
    }

    private Actor getActor(Element actorEl) {

        //for each <employee> element get text or int values of
        //name ,id, age and name
        String stage = getTextValue(actorEl, "stagename");
        String last = getTextValue(actorEl, "familyname");
        String first = getTextValue(actorEl, "firstname");
        Date birthDate = getDateValue(actorEl, "dob");
        if (first == null || last == null) {
            String[] parts = stage.split(" ");
            first = parts[0];
            last = parts[parts.length-1];


        }
        //Create a new Actor with the value read from the xml nodes
        Actor a = new Actor(stage, first, last, birthDate);
        return a;
    }

    private String getTextValue(Element ele, String tagName) {
        String textVal = null;
        NodeList nl = ele.getElementsByTagName(tagName);
        if (nl != null && nl.getLength() > 0) {
            Element el = (Element) nl.item(0);
            if (el.getFirstChild() == null)
                return null;
            textVal = el.getFirstChild().getNodeValue();
        }
        return textVal;
    }
    
    private Date getDateValue(Element ele, String tagName) {
        Date dateValue = null;
        
        String dateTextValue = getTextValue(ele,tagName);
        if (dateTextValue != null){
            DateFormat format = new SimpleDateFormat("yyyy");
            try {
                dateValue = format.parse(dateTextValue);
            } catch (ParseException ex) {
                return null;
            }
        }
        return dateValue;
    }

    public void printData(Map<String, Actor> actorMap) {
        System.out.println("No of Actors '" + actorMap.size() + "'.");

        for (Actor actor : actorMap.values()) {
            System.out.println(actor.toString());
        }
    }
}
