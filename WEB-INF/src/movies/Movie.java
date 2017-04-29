package movies;

import java.util.ArrayList;
import java.util.List;

public class Movie {
    public String id;
    public String year;
    public String title;
    public String director;
    public List<String> genres = new ArrayList<>();
    public List<Star> stars = new ArrayList<>();
    public String bannerURL;
    public String trailerURL;
    public String quantity;


    public Movie(String id, String year, String title, String director, String bannerURL) {
        this.id = id;
        this.year = year;
        this.title = title;
        this.director = director;
        this.bannerURL = bannerURL;
    }

    public Movie(String id, String title) {
        this.id = id;
        this.title = title;
    }

    public Movie() {

    }

    public Movie(String id, String year, String title, String director, String bannerURL, String quantity) {
        this.id = id;
        this.year = year;
        this.title = title;
        this.director = director;
        this.bannerURL = bannerURL;
        this.quantity = quantity;
    }

    public void setQuantity(String quantity){
        this.quantity = quantity;
    }
}
