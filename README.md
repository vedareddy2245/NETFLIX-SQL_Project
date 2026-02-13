# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix logo](https://github.com/vedareddy2245/NETFLIX-SQL_Project/blob/main/logo.png)

# Overview
This project involves analyzing the Netflix Movies and TV Shows dataset using SQL to extract meaningful insights about content distribution, trends, and patterns on Netflix.The project demonstrates SQL querying skills, including filtering, aggregation, grouping, and date-based analysis on a real-world dataset.The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

# Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- Understand content based on release years, countries, durations and recent additions.
- Explore and categorize content based on specific criteria and keywords.\

# Dataset
The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** Movies Dataset(https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

# Schema
```sql
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
```

# Business Problems and Solutions
# 1. Count the Number of Movies vs TV Shows
```sql
SELECT 
      type,
      COUNT(type) 
FROM netflix
GROUP BY type;
```
**Objective:** Determine the distribution of content types on Netflix.

# 2. Find the Most Common Rating for Movies and TV Shows
```sql
SELECT  type,rating FROM (
            SELECT 
               type,
               rating,
               COUNT(rating) as total_rating,
               RANK() over(partition by type order by COUNT(rating) desc) as rank
            FROM netflix
            GROUP BY rating,type)t
WHERE rank=1;
```
**Objective:** Identify the most frequently occurring rating for each type of content.

# 3. List All Movies Released in a Specific Year (e.g., 2020)
``` sql
SELECT * 
FROM netflix
WHERE type='movie' AND 
      release_year=2020;
```
**Objective:** Retrieve all movies released in a specific year.

# 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT TRIM(s.value),
       COUNT(show_id) AS total_shows 
FROM netflix
CROSS APPLY STRING_SPLIT(country,',') s
GROUP BY TRIM(s.value)
ORDER BY  COUNT(show_id) DESC;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

# 5. Identify the Longest Movie
```sql
SELECT * FROM netflix
WHERE type='movie' and
      duration=(SELECT duration=max(duration) from netflix);
```
**Objective:** Find the movie with the longest duration.

# 6. Find Content Added in the Last 5 Years
``` sql
SELECT * FROM netflix
WHERE YEAR(date_added)<=DATEADD(year,-5,getdate());
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

# 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```
**Objective:**  List all content directed by 'Rajiv Chilaka'.

# 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT * FROM netflix
WHERE type ='TV Show' and
      duration > '5 seasons';
```
**Objective:** Identify TV shows with more than 5 seasons.

# 9. Count the Number of Content Items in Each Genre
```sql
SELECT TRIM(s.value),
       count(show_id) 
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in,',') s
GROUP BY TRIM(s.value);
```
**Objective:** Count the number of content items in each genre.

# 10.Find each year and the average numbers of content release in India on netflix.Return top 5 year with highest avg content release!
```sql
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
```
**Objective:** Calculate and rank years by the average number of content releases by India.

# 11. List All Movies that are Documentaries
``` sql
SELECT *
FROM netflix
WHERE listed_in like '%Documentaries%'
```
**Objective:** Retrieve all movies classified as documentaries.

# 12. Find All Content Without a Director
```sql
SELECT *
FROM netflix
WHERE director is null;
```
**Objective:** List content that does not have a director.

# 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * FROM netflix
WHERE cast LIkE '%salman khan%'and 
      release_year>=year(GETDATE())-10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

# 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT TOP 10 
       TRIM(s.value),
       COUNT(*)
FROM netflix
CROSS APPLY string_split(cast,',') as s
WHERE country like'%India'
GROUP BY TRIM(s.value)
ORDER BY COUNT(*) DESC;
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

# 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
WITH NEW_TABLE as 
       (SELECT * ,
           CASE
               WHEN description like '%kill%' or description like '%violence%' then 'Bad_content'
               ELSE 'Good_content'
               END AS Category
           from netflix)
SELECT Category,COUNT(*) from NEW_TABLE
GROUP BY Category;
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion
- Content Distribution: The dataset contains a wide range of Movies and TV Shows with different genres and ratings.
- Ratings Analysis: Common ratings help understand the target audience for Movies and TV Shows.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Time-Based Trends: Content additions have increased in recent years, showing Netflix’s rapid growth.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
- People Analysis: Certain directors and actors appear frequently, showing their strong presence on the platform.
- Data Quality: Some records contain missing director information, reflecting real-world data challenges.
- This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
