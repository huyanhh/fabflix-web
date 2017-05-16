/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package parser;

/**
 *
 * @author krish
 */
public class FilmGenreRelation {
    public String filmId;
    public String genreName;
    

    public FilmGenreRelation(String filmId, String genreName) {
        this.filmId = filmId;
        this.genreName = genreName;
    }
    
    @Override
    public String toString()
    {
        return "[" + genreName + "," + filmId + "]";
    }
    
}
