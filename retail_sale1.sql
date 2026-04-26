-- TABLE CREATION
CREATE TABLE retailsales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE ,
    sale_time TIME ,
    customer_id INT ,
    gender VARCHAR(20),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

--DATA CLEANING (Removing missing value)
SELECT COUNT(*) FROM retailsales 
SELECT * FROM retailsales 
	WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM retailsales 
	WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- HOW MANY UNIQUE CUSTOMER ARE THERE

SELECT COUNT (DISTINCT customer_id) FROM retailsales

-- HOW MANY UNIQUE CATEGORY ARE THERE

SELECT DISTINCT category FROM retailsales


--DATA ANALYSIS 

--Q1 SQL query to retrive all columns for sales all column for sales made on '2022-11-05'
SELECT * FROM retailsales
	WHERE sale_date = '2022-11-05'

--Q2 SQL query to retrive all the transcantion where the category in 'clothing' and quantity sold more than 2 
-- in the month of Nov 2022
SELECT * FROM retailsales
	WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantity>2

--Q3 SQL query to calculate the total_sales from each category
SELECT
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) as total_order
	FROM retailsales
	GROUP BY 1

--Q4 SQL to find the average age of the customer who purchased item form the 'Beauty' category
SELECT 
	ROUND(AVG(age),2) as avg_age 
	FROM retailsales
	WHERE category = 'Beauty'

--Q5 SQL query to find all the transaction where the total_sale in greater the 1000
SELECT * FROM retailsales
	WHERE total_sale>1000
	ORDER BY total_sale;

--Q6 SQL query to find the total number of transactions made by each gender in each category
SELECT
	category,
	gender,
	COUNT(transactions_id) AS total_transactions
	FROM retailsales
	GROUP BY category, gender
	ORDER BY category

--Q7 SQL query to calculate average sales for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retailsales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q8 SQL query to find top 5 customers based on highest total_sales
SELECT
	customer_id,
	SUM(total_sale) as highest_sale
	FROM retailsales
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

--Q9 SQL query to find the number of unique customers who purchased item from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as distinct_customer
	FROM retailsales
	GROUP BY category

--Q10 SQL query to create each shift and number of orders (Example Morning<=12, Afternoon Between 12 & 17, Evening>17)
WITH hourly_sale as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retailsales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--End of Poject
