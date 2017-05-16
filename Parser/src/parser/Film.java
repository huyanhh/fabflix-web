/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package parser;

import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;

/**
 *
 * @author krish
 */
public class Film {
    //bad coding should use getters but I don't care
    public Integer id;
    public String fid;
    public String title;
    public Integer year;
    public String director;

    Film(String filmcode, String t, Integer y, String d) {
        title = t;
        year = y;
        director = d;
        fid = filmcode;
    }
    
    @Override
    //compare by value not by reference for relation
    public boolean equals(Object o)
    {
        Actor rhs = (Actor) o;
        return fid.equals(rhs.stageName);
    }

    @Override
    //compare by value not by reference for relation
    public int hashCode() {
        int hash = 7;
        hash = 11 * hash + Objects.hashCode(this.id);
        return hash;
    }
    
    @Override
    public String toString(){
        return "id: " + fid + ", title: " + title + ", year: " + year + ", director: " + director + "\n";
    }
}
