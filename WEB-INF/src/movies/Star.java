package movies;

import java.util.ArrayList;
import java.util.List;

public class Star {
    public String id;
    public String name;
    public String dob;
    public String photoURL;
    public List<Movie> movies = new ArrayList<>();

    public Star(String id, String name, String photoURL) {
        this.id = id;
        this.name = name;
        this.photoURL = photoURL;
    }

    public Star(String id, String name, String dob, String photoURL) {
        this.id = id;
        this.name = name;
        this.dob = dob;
        this.photoURL = photoURL;
    }

    public Star() {}
}
