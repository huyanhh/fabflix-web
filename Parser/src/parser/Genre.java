/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package parser;

import java.util.ArrayList;
import java.util.Objects;


public class Genre {
    //bad coding should use getters but I don't care
    public Integer id;
    public String genre;

    Genre(String g) {
        genre = g;
    }
    
    @Override
    //compare by value not by reference for relation
    public boolean equals(Object o)
    {
        Genre rhs = (Genre) o;
        return genre.equals(rhs.genre);
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 23 * hash + Objects.hashCode(this.genre);
        return hash;
    }
   
    
    @Override
    public String toString(){
        return "genre: " + genre + "\n";
    }
}