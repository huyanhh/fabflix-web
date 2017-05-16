
package parser;

import java.util.Objects;

/**
 *
 * @author krish
 */
public class StarFilmRelation {
    String stagename;
    String fid;

    public StarFilmRelation(String stage, String id) {
        this.stagename = stage;
        this.fid = id;
    }
    
    
    @Override
    public boolean equals(Object o) {
        StarFilmRelation rhs = (StarFilmRelation) o;
        return stagename.equals(rhs.stagename) && fid.equals(rhs.fid);
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 29 * hash + Objects.hashCode(this.stagename);
        hash = 29 * hash + Objects.hashCode(this.fid);
        return hash;
    }
    
    @Override
    public String toString()
    {
        return "[" + stagename + "," + fid + "]";
    }
}
