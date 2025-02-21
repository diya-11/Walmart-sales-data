SELECT * FROM walmart;

--DROP TABLE walmart;

SELECT COUNT(*) FROM walmart;

-- which payment method took the most place
SELECT 
    payment_method,
	COUNT(*)
FROM walmart
GROUP BY payment_method

--count branch
SELECT
    COUNT(DISTINCT branch)
FROM walmart;

-- Max and min quantity
SELECT MAX(quantity) FROM walmart;

SELECT MIN(quantity) FROM walmart;

-- Business Problems

--1. What are the different payment methods, and how many transactions and items were sold with each method?
SELECT
    payment_method,
	COUNT(*) as no_of_payments,
	SUM(quantity) as no_of_item_sold
FROM walmart
GROUP BY payment_method

-- 2. Which category received the highest average rating in each branch?
-- Average rating
SELECT *
FROM
(   SELECT
        branch,
		category,
		AVG(rating) as avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
     FROM walmart
	 GROUP BY 1, 2
)
WHERE rank = 1

-- 3. What is the busiest day of the week for each branch based on transaction volume?
SELECT *
FROM
   (SELECT
      branch,
	  TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
	  COUNT(*) as no_of_transactions,
	  RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1, 2
	)
WHERE rank = 1


-- 4. How many items were sold through each payment method?
SELECT
    payment_method,
	SUM(quantity) as no_of_item_sold
FROM walmart
GROUP BY payment_method


-- 5. What are the average, minimum, and maximum ratings for each category in each city?
SELECT
    city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2


-- 6. What is the total profit for each category, ranked from highest to lowest?
-- unti price * quantity * profit margin
-- list category and total_profit, ordered from highest to lowest profit
SELECT
    category,
	SUM(total) as total_revenue,
	SUM(total * profit_margin) as profit
FROM walmart
GROUP BY 1


-- 7. What is the most frequently used payment method in each branch?
-- using window function
WITH cte
AS
(SELECT
    branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1, 2
)
SELECT *
FROM cte
WHERE rank = 1


-- 8. How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
SELECT
    branch,
CASE
       WHEN EXTRACT(HOUR FROM(time::time))<12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
	   ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC

