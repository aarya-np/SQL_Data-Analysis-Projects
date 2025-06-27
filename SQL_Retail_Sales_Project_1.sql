select top 10 * from SQL_Retail_Sales_Analysis_utf;


select * from SQL_Retail_Sales_Analysis_utf;

select count(*) as total_rows from SQL_Retail_Sales_Analysis_utf;

--------------DATA CLEANIING----------------------------------------------------

select * from SQL_Retail_Sales_Analysis_utf 
where category is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null
;

--no null values present

---------------DATA EXPLORATION----------------------------

--how many customers do we have? 
select count(distinct(customer_id)) from SQL_Retail_Sales_Analysis_utf;
-- we have 155 unique customers. They made multiple purchases making out dataset of size 2000

--how many categories do we have?
select distinct(category) from SQL_Retail_Sales_Analysis_utf;
--we have 3 unique categories namely beauty, Electronics and Clothing.

---------------DATA ANALYSIS AND BUSINESS KEY PROBLEMS----------------

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from SQL_Retail_Sales_Analysis_utf where sale_date = '2022-11-05';

-- a total of 11 sales were made.

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to 4 in the month of Nov-2022:
select * from SQL_Retail_Sales_Analysis_utf where category = 'Clothing' and sale_date like '2022-11-%' and quantiy=4;

--3. Write a SQL query to calculate the total sales (total_sale) for each category.
select category, SUM(TRY_CAST(total_sale as INT)) as total_sales_cat, count(*) as total_orders from SQL_Retail_Sales_Analysis_utf group by category;

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select category, AVG(TRY_CAST(age as INT)) as average_age from SQL_Retail_Sales_Analysis_utf where category = 'Beauty' group by category;

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from SQL_Retail_Sales_Analysis_utf where total_sale>1000;

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select gender, count(transactions_id) as total_transactions, category from SQL_Retail_Sales_Analysis_utf group by gender, category;

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

create table #temp_table; 

select MONTH(sale_date) as months,
YEAR(sale_date) as years, 
avg(TRY_CAST(total_sale as INT))as total_sales
into #temp_table
from SQL_Retail_Sales_Analysis_utf 
group by MONTH(sale_date), YEAR(sale_date)
order by total_sales DESC


select years, max(total_sales) from #temp_table group by years

--8. Write a SQL query to find the top 5 customers based on the highest total sales
select top 5 customer_id, sum(TRY_CAST(total_sale as INT)) as total_saless from SQL_Retail_Sales_Analysis_utf group by customer_id order by total_saless DESC;


--9. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct(customer_id)) from SQL_Retail_Sales_Analysis_utf group by category;

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select count(transactions_id),
case
when DATEPART(HOUR, CAST(sale_time AS TIME))<12 then 'Morning'
when DATEPART(HOUR, CAST(sale_time AS TIME))>=12 and DATEPART(HOUR, CAST(sale_time AS TIME))<=17  then 'Afternoon'
else 'Evening'
end as shifts
from SQL_Retail_Sales_Analysis_utf
group by 
case
when DATEPART(HOUR, CAST(sale_time AS TIME))<12 then 'Morning'
when DATEPART(HOUR, CAST(sale_time AS TIME))>=12 and DATEPART(HOUR, CAST(sale_time AS TIME))<=17  then 'Afternoon'
else 'Evening'
end;

--OR

with cte_table as 
(select *, 
case
when DATEPART(HOUR, CAST(sale_time AS TIME))<12 then 'Morning'
when DATEPART(HOUR, CAST(sale_time AS TIME))>=12 and DATEPART(HOUR, CAST(sale_time AS TIME))<=17  then 'Afternoon'
else 'Evening'
end as shifts
from SQL_Retail_Sales_Analysis_utf)
select shifts, count(transactions_id) from cte_table group by shifts
