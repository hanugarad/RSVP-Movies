USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 'director_mapping' AS table_name,
       Count(*)           AS row_count
FROM   director_mapping
UNION ALL
SELECT 'genre'  AS table_name,
       Count(*) AS row_count
FROM   genre
UNION ALL
SELECT 'movie'  AS table_name,
       Count(*) AS row_count
FROM   movie
UNION ALL
SELECT 'names'  AS table_name,
       Count(*) AS row_count
FROM   names
UNION ALL
SELECT 'ratings' AS table_name,
       Count(*)  AS row_count
FROM   ratings
UNION ALL
SELECT 'role_mapping' AS table_name,
       Count(*)       AS row_count
FROM   role_mapping; 

--  director_mapping	3867
-- genre	14662
-- movie	7997
-- names	25735
-- ratings	7997
-- role_mapping	15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 'id'     AS column_name,
       Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie
UNION ALL
SELECT 'title'  AS column_name,
       Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie
UNION ALL
SELECT 'year'   AS column_name,
       Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie
UNION ALL
SELECT 'date_published' AS column_name,
       Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 end)	AS null_count
FROM   movie
UNION ALL
SELECT 'duration' AS column_name,
       Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 end)   AS null_count
FROM   movie
UNION ALL
SELECT 'country' AS column_name,
       Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 end)  AS null_count
FROM   movie
UNION ALL
SELECT 'worlwide_gross_income' AS column_name,
       Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie
UNION ALL
SELECT 'languages' AS column_name,
       Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie
UNION ALL
SELECT 'production_company' AS column_name,
       Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 end) AS null_count
FROM   movie; 

--id	0
--title	0
--year	0
--date_published	0
--duration	0
--country	20
--worlwide_gross_income	3724
--languages	194
--production_company	528






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
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 
--Year  number_of_movies
--2017	3052
--2018	2944
--2019	2001

SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 

--month_num	number_of_movies
--1				804
--2				640
--3				824
--4				680
--5				625
--6				580
--7				493
--8				678
--9				809
--10			801
--11			625
--12			438

-- its shows up and down trend across the year.



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(id) AS number_of_movies
FROM   movie
WHERE  Lower(country) LIKE '%india%'
        OR Lower(country) LIKE '%usa%'
           AND year = 2019; 
-- USA and India produced 1818 movies in total.










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 
-- 13 unique genre









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS movie_count
FROM   genre
GROUP  BY genre
ORDER  BY Count(movie_id) DESC
LIMIT 1; 
-- highest number of movies produced from genre 'Drama' -- 4285









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT genre,
       Count(movie_id)
FROM   genre
WHERE  movie_id IN (SELECT movie_id
                    FROM   genre
                    GROUP  BY movie_id
                    HAVING Count(movie_id) = 1)
GROUP  BY genre
ORDER  BY Count(movie_id) DESC; 








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
SELECT genre,
       Round(Avg(duration),2) AS avg_duration
FROM   movie m
       LEFT JOIN genre g
              ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY Avg(duration) DESC; 

-- Its seems Action and romantic movies are lengthy most and horror and Sci-Fi are relatively very short 






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


SELECT genre,
       Count(movie_id)                    AS movie_count,
       Rank()
         OVER(
           ORDER BY Count(movie_id) DESC) AS genre_rank
FROM   genre
GROUP  BY genre
ORDER  BY Count(movie_id) DESC; 

-- rank for thriller movies is 3







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

SELECT Round(Min(avg_rating)) AS min_avg_rating,
       Round(Max(avg_rating)) AS max_avg_rating,
       Min(total_votes)       AS min_total_votes,
       Max(total_votes)       AS max_total_votes,
       Min(median_rating)     AS min_median_rating,
       Max(median_rating)     AS max_median_rating
FROM   ratings; 




    

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
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rank
     AS (SELECT movie_id,
                avg_rating,
                Dense_rank()OVER(ORDER BY avg_rating DESC) AS movie_rank
         FROM   ratings)
SELECT title,
       avg_rating,
       movie_rank
FROM   movie_rank mr
       JOIN movie m
         ON mr.movie_id = m.id
WHERE  movie_rank < 11; 






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

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY Count(movie_id) DESC; 


-- distribution of movie ratings is nearly normal.  majority of the movies gets ratings in the range of 5 to 8, 





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


SELECT production_company,
       Count(movie_id)                    AS movie_count,
       Dense_rank()
         OVER(
           ORDER BY Count(movie_id) DESC) AS prod_company_rank
FROM   ratings r
       JOIN movie m
         ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company;  

-- Dream Warrior Pictures and National Theatre Live




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

SELECT genre,
       Count(movie_id) AS movie_count
FROM   (SELECT genre,
               g.movie_id,
               Month(date_published),
               year
        FROM   genre g
               JOIN movie m
                 ON g.movie_id = m.id
               JOIN ratings r
                 ON g.movie_id = r.movie_id
        WHERE  Lower(country) LIKE '%usa%'
               AND Month(date_published) = 3
               AND year = 2017
               AND total_votes > 1000)base
GROUP  BY genre
ORDER  BY movie_count DESC; 

--Drama		24
--Comedy	9
--Action	8
--Thriller	8
--Sci-Fi	7
--Crime		6
--Horror	6
--Mystery	4
--Romance	4
--Fantasy	3
--Adventure	3
--Family	1






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

SELECT title,
       avg_rating,
       genre
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
       JOIN genre g
         ON m.id = g.movie_id
WHERE  title LIKE 'The%'
       AND avg_rating > 8
ORDER  BY avg_rating DESC; 







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(movie_id) AS movie_count
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8; 

--361 movies







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT languages,
       Sum(total_votes) AS total_votes
FROM   (SELECT 'German' AS languages,
               total_votes
        FROM   movie m
               JOIN ratings r
                 ON m.id = r.movie_id
        WHERE  Lower(languages) LIKE '%german%')base
GROUP  BY languages
UNION ALL
SELECT languages,
       Sum(total_votes) AS total_votes
FROM   (SELECT 'Italian' AS languages,
               total_votes
        FROM   movie m
               JOIN ratings r
                 ON m.id = r.movie_id
        WHERE  Lower(languages) LIKE '%italian%')base
GROUP  BY languages; 


--German	4421525
--Italian	2559540




-- Answer is Yes

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


SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_nulls
FROM   names; 





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


SELECT NAME,
       Count(dm.movie_id) movie_count
FROM   director_mapping dm
       JOIN names n
         ON dm.name_id = n.id
       JOIN genre g
         ON dm.movie_id = g.movie_id
       JOIN ratings r
         ON dm.movie_id = r.movie_id
WHERE  genre IN (SELECT genre
                 FROM   (SELECT genre,
                                Count(r.movie_id)                    AS
                                movie_count,
                                Row_number()OVER(ORDER BY Count(r.movie_id) DESC) rn
                         FROM   ratings r
                                JOIN genre g
                                  ON r.movie_id = g.movie_id
                         WHERE  avg_rating > 8
                         GROUP  BY genre)base
                 WHERE  rn < 4)
       AND r.avg_rating > 8
GROUP  BY NAME
ORDER  BY Count(dm.movie_id) DESC
LIMIT 3;  






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

SELECT name              AS actor_name,
       Count(r.movie_id) AS movie_count
FROM   ratings r
       JOIN role_mapping rm
         ON r.movie_id = rm.movie_id
       JOIN names n
         ON rm.name_id = n.id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY name
ORDER  BY Count(r.movie_id) DESC
LIMIT 2; 


-- Mammootty and Mohanlal are top 2 actors whose movies have a median rating >= 8




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

 SELECT *
FROM   (SELECT production_company,
               Sum(total_votes)                    AS vote_count,
               Dense_rank()OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
        FROM   ratings r
               JOIN movie m
                 ON r.movie_id = m.id
        GROUP  BY production_company)base
WHERE  prod_comp_rank < 4; 
 
--Marvel Studios			2656967		1
--Twentieth Century Fox		2411163		2
--Warner Bros.				2396057		3






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

WITH actor_altleast_5movies
     AS (SELECT name_id
         FROM   role_mapping
         WHERE  category = 'actor'
         GROUP  BY name_id
         HAVING Count(movie_id) >= 5),
     actor_summary
     AS (SELECT NAME                                             AS actor_name,
                Sum(total_votes)                                 AS total_votes,
                Count(rm.movie_id)                               AS movie_count,
                Sum(avg_rating * total_votes) / Sum(total_votes) AS
                actor_avg_rating
         FROM   actor_altleast_5movies a5m
                JOIN role_mapping rm
                  ON a5m.name_id = rm.name_id
                JOIN names n
                  ON a5m.name_id = n.id
                JOIN movie m
                  ON rm.movie_id = m.id
                JOIN ratings r
                  ON rm.movie_id = r.movie_id
         WHERE  Lower(country) LIKE '%india%'
         GROUP  BY NAME)
SELECT *,
       Rank()OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary; 


--	Vijay Sethupathi	23114	5	8.41673		1
--	Fahadh Faasil		13557	5	7.98604		2
--	Yogi Babu			8500	11	7.83018		3




-- Top actor is Vijay Sethupathi

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


WITH actress_altleast_3movies
     AS (SELECT name_id
         FROM   role_mapping
         WHERE  category = 'actress'
         GROUP  BY name_id
         HAVING Count(movie_id) >= 3),
     actress_summary
     AS (SELECT NAME                                             AS actress_name
                ,
                Sum(total_votes)
                AS total_votes,
                Count(rm.movie_id)                               AS movie_count,
                Sum(avg_rating * total_votes) / Sum(total_votes) AS actress_avg_rating
         FROM   actress_altleast_3movies a3m
                JOIN role_mapping rm
                  ON a3m.name_id = rm.name_id
                JOIN names n
                  ON a3m.name_id = n.id
                JOIN movie m
                  ON rm.movie_id = m.id
                JOIN ratings r
                  ON rm.movie_id = r.movie_id
         WHERE  Lower(country) LIKE '%india%'
                AND Lower(languages) LIKE '%hindi%'
         GROUP  BY NAME)
SELECT *
FROM   (SELECT *,
               Rank()OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
        FROM   actress_summary)base
WHERE  actress_rank <= 5; 






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movie_avg_rating
     AS (SELECT title,
                avg_rating
         FROM   movie m
                JOIN genre g
                  ON m.id = g.movie_id
                JOIN ratings r
                  ON g.movie_id = r.movie_id
         WHERE  genre = 'Thriller')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END movie_category
FROM   thriller_movie_avg_rating; 

-- for count in each category
select movie_category,count(title) as movie_count
from (
WITH thriller_movie_avg_rating
     AS (SELECT title,
                avg_rating
         FROM   movie m
                JOIN genre g
                  ON m.id = g.movie_id
                JOIN ratings r
                  ON g.movie_id = r.movie_id
         WHERE  genre = 'Thriller')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END movie_category
FROM   thriller_movie_avg_rating
)base group by movie_category;


--Superhit movies			39
--One-time-watch movies		786
--Hit movies				166
--Flop movies				493



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

WITH avg_duration
     AS (SELECT genre,
                Round(Avg(duration), 2) AS avg_duration
         FROM   movie m
                JOIN genre g
                  ON m.id = g.movie_id
         GROUP  BY genre)
SELECT *,
       Round(Sum(avg_duration)OVER(ORDER BY avg_duration DESC), 2) running_total_duration,
       Round(Avg(avg_duration)OVER (ORDER BY avg_duration DESC), 2) moving_avg_duration
FROM   avg_duration; 







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

 WITH top3_genre
     AS (SELECT id                                              AS movie_id,
                title                                           AS movie_name,
                year,
                genre,
                worlwide_gross_income,
                Substring_index(worlwide_gross_income, ' ', 1)  AS unit, -- extract first string of complete column value
                Substring_index(worlwide_gross_income, ' ', -1) AS gross_income -- extract last string of complete column value
         FROM   movie m
                JOIN genre g
                  ON m.id = g.movie_id
         WHERE  genre IN (SELECT genre
                          FROM   (SELECT genre,
                                         Count(movie_id)                    AS
                                         movie_count,
                                         Row_number()OVER(ORDER BY Count(movie_id) DESC) rn
                                  FROM   genre
                                  GROUP  BY genre)top3
                          WHERE  rn < 4)),
     inr2doller_conversion
     AS (SELECT movie_name,
                genre,
                worlwide_gross_income,
                year,
                Round(CASE
                        WHEN unit = 'INR' THEN ( gross_income / 80.64 ) -- unit conversion from INR to Doller
                        ELSE gross_income
                      END) AS worldwide_gross_income_doller
         FROM   top3_genre)
SELECT *
FROM   (SELECT genre,
               year,
               movie_name,
               worlwide_gross_income                            AS
                      worldwide_gross_income,
               Row_number()OVER(partition BY year ORDER BY worldwide_gross_income_doller DESC) AS movie_rank
        FROM   inr2doller_conversion)top_5
WHERE  movie_rank <= 5; 








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

SELECT *
FROM   (
                SELECT   production_company,
                         Count(id)                                  AS movie_count,
                         Row_number() over(ORDER BY count(id) DESC) AS prod_comp_rank
                FROM     movie m
                JOIN     ratings r
                ON       m.id = r.movie_id
                WHERE    median_rating >=8
                AND      position(','IN languages)
                AND      production_company IS NOT NULL
                GROUP BY production_company )top2
WHERE  prod_comp_rank < 3;



--Star Cinema				7	1
--Twentieth Century Fox		4	2



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT *
FROM   (SELECT NAME                                 AS actress_name,
               Sum(total_votes)                     AS total_votes,
               Count(r.movie_id)                    AS movie_count,
               Avg(avg_rating)                      AS actress_avg_rating,
               Row_number()OVER(ORDER BY Count(r.movie_id) DESC) AS actress_rank
        FROM   ratings r
               JOIN role_mapping rm
                 ON r.movie_id = rm.movie_id
               JOIN names n
                 ON rm.name_id = n.id
               JOIN genre g
                 ON r.movie_id = g.movie_id
        WHERE  avg_rating > 8
               AND category = 'actress'
               AND genre = 'Drama'
        GROUP  BY NAME)top3
WHERE  actress_rank < 4; 

	
--Parvathy Thiruvothu	4974	2	8.20000	1
--Susan Brown			656		2	8.95000	2
--Amanda Lawrence		656		2	8.95000	3




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
WITH next_movie_date
     AS (SELECT name_id
                AS
                director_id,
                NAME
                AS
                   director_name,
                movie_id,
                date_published,
                COALESCE(Lead(date_published)OVER (partition BY name_id ORDER BY date_published, movie_id), date_published)
                AS
                next_movie_date_published ----COALESCE used to replace null value with date_published
         FROM   director_mapping dm
                JOIN names n
                  ON dm.name_id = n.id
                JOIN movie m
                  ON dm.movie_id = m.id),
     avg_inter_movie_days
     AS (SELECT director_id,
                Round(Avg(Datediff(next_movie_date_published, date_published)),
                2) AS
                avg_inter_movie_days - -- calculated time interval in days between two movies directed by same director
         FROM   next_movie_date
         GROUP  BY director_id)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   (SELECT nmd.director_id,
               director_name,
               Count(nmd.movie_id)                AS number_of_movies,
               avg_inter_movie_days,
               Round(Avg(avg_rating), 2)          AS avg_rating,
               Sum(total_votes)                   AS total_votes,
               Min(avg_rating)                    AS min_rating,
               Max(avg_rating)                    AS max_rating,
               Sum(duration)                      AS total_duration,
               Row_number()
                 OVER(ORDER BY Count(movie_id) DESC) AS dir_rank
        FROM   next_movie_date nmd
               JOIN avg_inter_movie_days avgmvdys
                 ON nmd.director_id = avgmvdys.director_id
               JOIN ratings r
                 ON nmd.movie_id = r.movie_id
               JOIN movie m
                 ON nmd.movie_id = m.id
        GROUP  BY nmd.director_id)top9
WHERE  dir_rank < 10; 