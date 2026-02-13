CREATE DATABASE Netflix_db;

USE Netflix_db;

CREATE TABLE netflix
(
        show_id VARCHAR(10) PRIMARY KEY,
        type VARCHAR(20),
        title VARCHAR(150),
        director VARCHAR(210),
        cast VARCHAR(1000),
        country VARCHAR(150),
        date_added VARCHAR(50),
        release_year INT,
        rating VARCHAR(10),
        duration VARCHAR(15),
        listed_in VARCHAR(200),
        description VARCHAR(250)
);

INSERT INTO netflix
SELECT * FROM netflix_titles

DROP TABLE netflix_titles

SELECT * FROM netflix

SELECT 
    COUNT(*) AS total_content
FROM netflix;

SELECT DISTINCT type FROM netflix

--1.Count the number of movies vs tv shows
SELECT type,
      COUNT(type) 
FROM netflix
GROUP BY type

--2.Find the most common rating for Movies and TV shows
SELECT * FROM (
            SELECT 
               type,
               rating,
               COUNT(rating) as total_rating,
               RANK() over(partition by type order by COUNT(rating) desc) as rank
            FROM netflix
            GROUP BY rating,type)t
WHERE rank=1

--3.List all movies released in specific year(like 2020)
SELECT * 
FROM netflix
WHERE type='movie' AND 
      release_year=2020

--4.Find the top 5 countries with the most content on netflix
SELECT TRIM(s.value),COUNT(show_id) AS total_shows FROM netflix
CROSS APPLY STRING_SPLIT(country,',') s
GROUP BY TRIM(s.value)
ORDER BY  COUNT(show_id) DESC

--5.Identify the longest movie
SELECT * FROM netflix
WHERE type='movie' and duration=(SELECT duration=max(duration) from netflix)

--6.Find the content added in the last 5 years
SELECT * FROM netflix
WHERE YEAR(date_added)<=DATEADD(year,-5,getdate())

--7.Find all the movies/sjows by director rajiv chilaka
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'

--8.List all the tv shows with more than 5 seasons
SELECT * FROM netflix
WHERE type ='TV Show' and duration > '5 seasons'

--9.Count number of content items in each genre
SELECT TRIM(s.value),count(show_id) FROM netflix
CROSS APPLY STRING_SPLIT(listed_in,',') s
GROUP BY TRIM(s.value)

--10.Find each year and the average numbers of content release by india on netflix.Return top 5 year with highest avg content release
SELECT
    YEAR(TRY_CONVERT(date, date_added,107)) AS release_year,
    COUNT(*) *100/
    (
        SELECT COUNT(*)
        FROM netflix
        WHERE country = 'India'
          AND TRY_CONVERT(date, date_added, 107) IS NOT NULL
    ) AS avg_content
FROM netflix
WHERE country = 'India'
GROUP BY YEAR(TRY_CONVERT(date, date_added, 107))
ORDER BY release_year;

--11.List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in like '%Documentaries%'

--12.Find all content without a director
SELECT * FROM netflix
WHERE director is null

--13.Find how many movies actor salman khan appeared in last 10 years
SELECT * FROM netflix
WHERE cast LIkE '%salman khan%'and 
      release_year>=year(GETDATE())-10

--14.Find the top 10 actors who have appeared in the highest number of movies produced in india
SELECT TOP 10 
       TRIM(s.value),
       COUNT(*)
FROM netflix
CROSS APPLY string_split(cast,',') as s
WHERE country like'%India'
GROUP BY TRIM(s.value)
ORDER BY COUNT(*) DESC

--15.Categorize the contents based on the presence of keywords 'kill' and 'violence' in the description field.
--Label content containing these words as bad and all other contents as good.count how many items fall into each category
WITH NEW_TABLE as 
       (SELECT * ,
           CASE
               WHEN description like '%kill%' or description like '%violence%' then 'Bad_content'
               ELSE 'Good_content'
               END AS Category
           from netflix)
SELECT Category,COUNT(*) from NEW_TABLE
GROUP BY Category
     




































