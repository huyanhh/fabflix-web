DELIMITER $$

CREATE PROCEDURE moviedb.add_movie(IN `_title`      VARCHAR(100), IN `_year` INT, IN `_director` VARCHAR(100),
                                   IN `_first_name` VARCHAR(50), IN `_last_name` VARCHAR(50),
                                   IN `_genre_name` VARCHAR(32))
  BEGIN
    select 'Checking if movie exists' as log;
    if not exists (select * from movies where title=_title)
    then
      BEGIN
        select 'Creating movie' as log;
        insert into movies(title, year, director) values
          (_title, _year, _director);
        select 'Checking if star exists' as log;
        if not exists (select * from stars
        where first_name=_first_name and last_name=_last_name)
        then
          select 'Creating new star' as log;
          insert into stars(first_name, last_name) values (_first_name, _last_name);
        end if;
        select 'Checking if genre exists' as log;
        if not exists (select * from genres where name=_genre_name)
        then
          select 'Creating new genre' as log;
          insert into genres(name) values (_genre_name);
        end if;
        select 'Linking the star to the movie' as log;
        insert into stars_in_movies(star_id, movie_id) values
          ((select id from stars where first_name=_first_name and last_name=_last_name),
           (select id from movies where title=_title));
        select 'Linking the genre to the movie' as log;
        insert into genres_in_movies(genre_id, movie_id) values
          ((select id from genres where name=_genre_name),
           (select id from movies where title=_title));
        select 'Add movie successful' as log;
      END;
    else
      select 'Movie already exists, exiting' as log;
    end if;
  END;

$$
DELIMITER ;