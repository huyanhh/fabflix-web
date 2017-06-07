By setting autocommit to false the jdbc program witholds commiting statements immediately and wait until
 all the transactions are pooled into 1 transaction as opposed to several hundreds, or thousands of 
 transacations. Setting autocommit to true resulted in time of roughly 2 mins to insert into the database
  when  it was empty as opposed to only 7 seconds when setting autocommit to true.

We have created hashmaps to hold genre, movie, and star information which also store information for 
the respective object and inserts an id generated from get_generated_keys method. Utilizing the 
get_generated_keys method saves the id generated during insertion in genre, movie, and stars table. 
By using the generate_key_method we can avoid the use of an additional select statement to retrieve 
the id information from the databases needed to perform inserts on genres_in_movies and stars_in_movie
 This decreases complexity time from O(LogN) to O(1) since we can use the keys generated to retrieve
  information for star_id, movie_id, and genre_id.