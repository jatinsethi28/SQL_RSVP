USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping;
-- Number of total Rows in director_mapping Table = 3867

SELECT COUNT(*) FROM genre;
-- Number of total Rows in genre Table = 14662

SELECT COUNT(*) FROM movie;
-- Number of total Rows in movie Table = 7997

SELECT COUNT(*) FROM names;
-- Number of total Rows in names Table = 25735

SELECT COUNT(*) FROM ratings;
-- Number of total Rows in ratings Table = 7997

SELECT COUNT(*) FROM role_mapping;
-- Number of total Rows in role_mapping Table = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(IF(id IS NULL, 1, 0)) AS id_null_count,
    SUM(IF(title IS NULL, 1, 0)) AS title_null_count,
    SUM(IF(year IS NULL, 1, 0)) AS year_null_count,
    SUM(IF(date_published IS NULL, 1, 0)) AS date_published_null_count,
    SUM(IF(duration IS NULL, 1, 0)) AS duration_null_count,
    SUM(IF(country IS NULL, 1, 0)) AS country_null_count,
    SUM(IF(worlwide_gross_income IS NULL, 1, 0)) AS worlwide_gross_income_null_count,
    SUM(IF(languages IS NULL, 1, 0)) AS languages_null_count,
    SUM(IF(production_company IS NULL, 1, 0)) AS production_company_null_count
FROM movie;

-- ANSWER:- 
-- There are 4 columns with Null values : country, worldwide_gross_income, languages, production_company


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    year, COUNT(id) AS number_of_movies
FROM
    Movie
GROUP BY year;

-- ANSWER:-
-- Highest number of the movies were prduced in 2017(i.e. 3025)
 
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    Movie
GROUP BY MONTH(date_published)
ORDER BY month_num;

-- ANSWER:-
-- Highest number of the movies were produced in March(i.e. 824)



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(DISTINCT id) AS Number_of_movies, year
FROM
    movie
WHERE
    year = 2019
        AND (lower(country) LIKE '%india%'
        OR lower(country) LIKE '%usa%');
        
-- ANSWER:-        
-- In 2019 USA and India Produces 1059 number of Movies


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT genre
FROM  genre; 

-- ANSWER:-
-- Movies belong to 13 genres in the dataset. 
-- Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery and Others



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(movie_id) Number_of_movies
FROM
    genre
GROUP BY genre
ORDER BY Number_of_movies DESC 
LIMIT 1;

-- ANSWER:-
-- "Drama" genre has the highest number of movies produced(i.e. 4285).



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_single_genre AS (
	SELECT 
		movie_id, 
        COUNT(genre) genre_count
	FROM genre
	GROUP BY movie_id
	HAVING COUNT(genre) = 1
)
SELECT count(movie_id) AS No_of_movies_with_sigleGenre 
FROM movies_single_genre;

-- ANSWER:-
-- There are 3289 Movies belongs to single Genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    ROUND(AVG(m.duration),2) AS avg_duration
FROM
    genre g
LEFT JOIN
    movie m ON m.id = g.movie_id
GROUP BY g.genre;

-- ANSWER:-
-- 'Action' has the highest average duration followed by Romace, Crime, Drama and Fantasy



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank AS(
SELECT 
	genre, 
    COUNT(movie_id) movie_count,
	RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank
FROM genre
GROUP BY genre)
SELECT 
	genre, 
	movie_count, 
	genre_rank 
FROM 
genre_rank
WHERE LOWER(genre)='thriller'; 

-- ANSWER:-
-- In terms of number of movies produced, the rank of the ‘thriller’ genre of movies among all the genres  is 3



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) min_avg_rating,
    MAX(avg_rating) max_avg_rating,
    MIN(total_votes) min_total_votes,
    MAX(total_votes) max_total_votes,
    MIN(median_rating) min_median_rating,
    MAX(median_rating) max_median_rating
FROM
    ratings;

-- ANSWER:-
-- min_avg_rating --> 1.0
-- max_avg_rating --> 10.0
-- min_total_votes --> 100
-- max_total_votes --> 725138
-- min_median_rating --> 1
-- max_median_rating --> 10



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH movie_ranks AS (
	SELECT 
		m.title, 
		r.avg_rating , 
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) movie_rank
	FROM ratings r 
	INNER JOIN movie m ON m.id=r.movie_id
    ) 
SELECT * FROM movie_ranks
WHERE movie_rank<=10;

-- ANSWER:-
-- TOP 10 movies are as follow:
-- Kriket(10.0), Love in Kilnerry(10.0), Gini Helida Kathe(9.8), Runam(9.7), Fan(9.6), Android Kunjappan Version 5.25(9.6), Yeh Suhaagraat Impossible(9.5),
-- Safe(9.5), The Brighton Miracle(9.5), Shibu(9.4), Our Little Haven(9.4), Zana(9.4), Family of Thakurganj(9.4), Ananthu V/S Nusrath(9.4)  



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, 
    COUNT(movie_id) movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

-- ANSWER:-
-- movies with median rating 7 are highest in number followed by median rating 6 and median rating 8.



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


WITH t1 AS(
	SELECT 
		m.production_company, 
		COUNT(m.id) AS movie_count, 
		DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) as prod_company_rank 
	FROM movie m 
	INNER JOIN ratings r ON m.id=r.movie_id
	WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL
	GROUP BY m.production_company
    )
SELECT 
	t1.production_company, 
	t1.movie_count, 
	t1.prod_company_rank 
FROM t1
WHERE t1.prod_company_rank=1;

-- ANSWER:-
-- Dream Warrior Pictures and National Theatre Live have produced highest number of hit movies(avg_rating > 8).



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre, 
    COUNT(g.movie_id) movie_count
FROM genre g 
	INNER JOIN movie m ON m.id=g.movie_id
	INNER JOIN ratings r ON r.movie_id=m.id
WHERE 
	MONTH(date_published)=3 AND
    year = 2017 AND
    r.total_votes > 1000 AND
    country LIKE "%USA%"
GROUP BY g.genre
ORDER BY movie_count DESC;

-- ANSWER:-
-- There are 24 movies were released in 'Drama' genre during March 2017 in the USA that had more than 1,000 votes
-- Top 3 genres are Drama, Comedy and Action during March 2017 in the USA and had more than 1,000 votes



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	m.title, 
    r.avg_rating,
    g.genre
FROM genre g 
INNER JOIN movie m ON m.id=g.movie_id
INNER JOIN ratings r ON r.movie_id=m.id
WHERE 
	title LIKE "The%" AND
    avg_rating > 8
ORDER BY genre, avg_rating DESC;

-- ANSWER:-
-- Drama genre dominates with several high-rated films, such as 
-- The Brighton Miracle (9.5), The Colour of Darkness (9.1) and The Blue Elephant (8.8)



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.title) movie_count
FROM movie m 
INNER JOIN ratings r ON r.movie_id=m.id
WHERE 
	(date_published BETWEEN '2018-04-01' AND '2019-04-01') AND 
    r.median_rating = 8;

-- ANSWER:-
-- 361 movies were released between 1 April 2018 and 1 April 2019 having median rating of 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:



WITH votes_info AS
(
SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM
    movie AS m 
	    INNER JOIN
	ratings AS r 
		ON m.id = r.movie_id
)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes_per_movie,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes_per_movie
FROM
    votes_info;
    
-- ANSWER:-
-- Yes, German movies get more votes than Italian movies



/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(IF(name IS NULL, 1, 0)) AS name_nulls,
    SUM(IF(height IS NULL, 1, 0)) AS height_nulls,
    SUM(IF(date_of_birth IS NULL, 1, 0)) AS date_of_birth_nulls,
    SUM(IF(known_for_movies IS NULL, 1, 0)) AS known_for_movies_nulls
FROM 
	names;

-- ANSWER:-
-- Columns with null values are as follow: height, date_of_birth and known_for_movies



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS (
	SELECT g.genre
	FROM genre g
	INNER JOIN ratings r USING(movie_id)
	WHERE r.avg_rating > 8
	GROUP BY g.genre 
	ORDER BY COUNT(g.movie_id) DESC
	LIMIT 3
    )
SELECT
    n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM movie m
INNER JOIN director_mapping d ON m.id = d.movie_id
INNER JOIN names n ON n.id = d.name_id
INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE 
	g.genre IN (SELECT genre FROM top_3_genre)
    AND avg_rating > 8
GROUP BY director_name
ORDER BY Movie_count DESC
LIMIT 3;

-- ANSWER:-
-- Top 3 directors are as follows
-- James Mangold, Anthony Russo and Joe Russo

-- ---------- 2nd Approach -----------------------

WITH top_3_genre AS (
	SELECT g.genre
	FROM genre g
	INNER JOIN ratings r USING(movie_id)
	WHERE r.avg_rating > 8
	GROUP BY g.genre 
	ORDER BY COUNT(g.movie_id) DESC
	LIMIT 3
    )
SELECT 
	n.name director_name, 
	COUNT(m.id) movie_count
FROM names n 
INNER JOIN director_mapping d  ON d.name_id=n.id
INNER JOIN movie m  ON m.id=d.movie_id
INNER JOIN genre g  ON m.id=g.movie_id
INNER JOIN top_3_genre t3  ON t3.genre=g.genre
INNER JOIN ratings r  ON r.movie_id = m.id
WHERE avg_rating > 8 
GROUP BY director_name
ORDER BY movie_count DESC 
LIMIT 3;

-- ANSWER:-
-- Top 3 directors are as follows
-- James Mangold, Anthony Russo and Soubin Shahir


-- NOTE:-
-- Here Joe Russo and Soubin Shahir both has directed same number of movies with top 3 genre having rating>8 (i.e. 3) 
-- so both can be correct answer.



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
	n.name Actor_name, 
	COUNT(m.id) movie_count
FROM names n 
INNER JOIN role_mapping rm ON rm.name_id=n.id
INNER JOIN movie m ON m.id=rm.movie_id
INNER JOIN ratings r ON r.movie_id=m.id
WHERE median_rating >= 8 AND rm.category = "ACTOR"
GROUP BY Actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- ANSWER:-
-- Mammootty and Mohanlal are TOP 2 actors



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT * FROM (
	SELECT m.production_company,
	SUM(r.total_votes) AS vote_count,
	DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) prod_comp_rank
	FROM movie m 
	INNER JOIN ratings r ON r.movie_id=m.id
	GROUP BY m.production_company) t
WHERE prod_comp_rank <=3;

-- ANSWER:-
-- TOP 3 production companies are Marvel Studios, Twentieth Century Fox and Warner Bros.



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	n.name AS actor_name,
    SUM(r.total_votes) total_votes,
    COUNT(rm.movie_id) movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) actor_avg_rating,
    DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, 
								SUM(r.total_votes) DESC) actor_rank
FROM 
	names n
INNER JOIN role_mapping rm ON n.id=rm.name_id
INNER JOIN ratings r ON r.movie_id=rm.movie_id
INNER JOIN movie m ON m.id=r.movie_id
WHERE 
	lower(m.country) LIKE '%india%' AND
    lower(rm.category) = "actor"
GROUP BY n.name
HAVING COUNT(rm.movie_id) >= 5;

-- ANSWER:-
-- Top actors are Vijay Sethupathi followed by Fahadh Fassil and Yogi Babu



-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_info AS(
	SELECT 
		n.name AS actress_name,
		SUM(r.total_votes) total_votes,
		COUNT(rm.movie_id) movie_count,
		ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) actress_avg_rating,
		DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, 
									SUM(r.total_votes) DESC) actress_rank
	FROM 
		names n
	INNER JOIN role_mapping rm ON n.id=rm.name_id
	INNER JOIN ratings r ON r.movie_id=rm.movie_id
	INNER JOIN movie m ON m.id=r.movie_id
	WHERE 
		lower(m.country) LIKE '%india%' AND
		lower(rm.category) = "actress" AND
		lower(m.languages) LIKE '%hindi%'
	GROUP BY n.name
	HAVING COUNT(rm.movie_id) >= 3
    ) 
SELECT * FROM actress_info
WHERE actress_rank<=5;

-- ANSWER:-
-- Top five actresses are as follow : 
-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor and Kriti Kharbanda



/*Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

 SELECT 
	m.title,
    CASE 
		WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
	END AS movie_category
FROM movie m
LEFT JOIN ratings r ON r.movie_id=m.id
LEFT JOIN genre g ON r.movie_id=g.movie_id
WHERE 
	g.genre = 'Thriller' AND 
    r.total_votes >= 25000
ORDER BY r.avg_rating DESC;

-- ANSWER:-    
-- Joker, Andhadhun, Contratiempo and Ah-ga-ssi are superhit movies From Thriller Genre




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	g.genre,
    ROUND(AVG(m.duration)) avg_duration,
    SUM(ROUND(AVG(m.duration),1)) OVER(ORDER BY g.genre 
									 ROWS UNBOUNDED PRECEDING) running_total_duration,
	ROUND(AVG(AVG(m.duration)) OVER(ORDER BY g.genre 
									 ROWS UNBOUNDED PRECEDING),2) moving_avg_duration
FROM genre g
INNER JOIN movie m ON m.id=g.movie_id
GROUP BY g.genre
ORDER BY g.genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS
(
SELECT 
    genre,
    COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre AS g
LEFT JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre
),
top_grossing AS
(
SELECT 
    g.genre,
	year,
	m.title as movie_name,
    worlwide_gross_income,
    RANK() OVER (PARTITION BY g.genre, year
					ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM movie AS m
INNER JOIN genre AS g ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_3_genres WHERE genre_rank<=3)
)
SELECT * 
FROM top_grossing
WHERE movie_rank<=5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH prod_comp_info AS
(SELECT 
	m.production_company,
    COUNT(m.id) movie_count,
    DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) prod_comp_rank
FROM movie m
INNER JOIN 
	ratings r ON m.id=r.movie_id
WHERE 
	r.median_rating >= 8 AND
    m.languages LIKE "%,%" AND
    m.production_company IS NOT NULL
GROUP BY production_company) 
SELECT 
	production_company,
    movie_count,
    prod_comp_rank
FROM prod_comp_info
WHERE prod_comp_rank <=2;

-- ANSWER:-
-- Top 2 production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are as follow:
-- Star Cinema with 7 hit movies(median rating >= 8)
-- Twentieth Century Fox with 4 hit movies(median rating >= 8)




-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:


WITH superhit_movie AS
(SELECT r.movie_id
FROM ratings r
INNER JOIN genre g USING(movie_id)
WHERE LOWER(g.genre) ='drama' AND r.avg_rating > 8)
SELECT 
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER( ORDER BY ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) DESC,
                        SUM(r.total_votes) DESC,
                        n.name) AS actress_rank
FROM
	names n
INNER JOIN 
	role_mapping rm ON rm.name_id=n.id
INNER JOIN 
	ratings r ON rm.movie_id=r.movie_id
INNER JOIN 
	superhit_movie sm ON sm.movie_id=r.movie_id
WHERE rm.category = 'Actress'
GROUP BY n.name
LIMIT 3;

-- ANSWER:-
-- Top 3 actresses are Sangeetha Bhat, Adriana Matoshi and Fatmire Sahiti



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH top_directors AS
(
SELECT 
	n.id as director_id,
    n.name as director_name,
	COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as director_rank
FROM names AS n
INNER JOIN	director_mapping AS d
	ON n.id=d.name_id
INNER JOIN movie AS m
	ON d.movie_id = m.id
GROUP BY n.id
),
movie_info AS
(
SELECT
	n.id as director_id,
    n.name as director_name,
    m.id AS movie_id,
    m.date_published,
	r.avg_rating,
    r.total_votes,
    m.duration,
    LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date_published,
    DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published),date_published) AS inter_movie_days
FROM
	names AS n
	INNER JOIN director_mapping AS d
		ON n.id=d.name_id
	INNER JOIN movie AS m
		ON d.movie_id = m.id
	INNER JOIN ratings AS r
		ON m.id=r.movie_id
WHERE n.id IN (SELECT director_id FROM top_directors WHERE director_rank<=9)
)
SELECT 
	director_id,
	director_name,
	COUNT(DISTINCT movie_id) as number_of_movies,
	ROUND(AVG(inter_movie_days),0) AS avg_inter_movie_days,
	ROUND( SUM(avg_rating*total_votes)	/ SUM(total_votes) ,2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM 
movie_info
GROUP BY director_id
ORDER BY number_of_movies DESC, avg_rating DESC;

-- ANSWER:-
-- Top 9 directors are as follow:
-- A.L. Vijay, Andrew Jones, Steven Soderbergh, Sam Liu, Sion Sono, Jesse V. Johnson, Justin Price, Chris Stokes and Özgür Bakar
