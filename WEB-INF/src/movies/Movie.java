package movies;

import java.util.ArrayList;
import java.util.List;
/**
 * Created by huyanh on 2017. 4. 23..
 */
public class Movie {
    public String id;
    public String year;
    public String title;
    public String director;
    public List<String> genres;
    public List<String> stars;
    public String bannerURL;
    public String trailerURL;
    public String quantity;


    public Movie(String id, String year, String title, String director, String bannerURL) {
        this.id = id;
        this.year = year;
        this.title = title;
        this.director = director;
        this.bannerURL = bannerURL;
        this.genres = new ArrayList<>();
        this.stars = new ArrayList<>();
    }

    public Movie(String id, String year, String title, String director, String bannerURL, String quantity) {
        this.id = id;
        this.year = year;
        this.title = title;
        this.director = director;
        this.bannerURL = bannerURL;
        this.genres = new ArrayList<>();
        this.stars = new ArrayList<>();
        this.quantity = quantity;
    }

    public void setQuantity(String quantity){
        this.quantity = quantity;
    }
}
