# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_DA_1`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_DA_1' and the csv file is imported using Import Data feature in Microsoft SQL Server Management Studio. 

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select count(*) as total_rows from SQL_Retail_Sales_Analysis_utf;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
   select * from SQL_Retail_Sales_Analysis_utf where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to 4 in the month of Nov-2022**:
```sql
select * from SQL_Retail_Sales_Analysis_utf where category = 'Clothing' and sale_date like '2022-11-%' and quantiy=4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category, SUM(TRY_CAST(total_sale as INT)) as total_sales_cat, count(*) as total_orders from SQL_Retail_Sales_Analysis_utf group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select category, AVG(TRY_CAST(age as INT)) as average_age from SQL_Retail_Sales_Analysis_utf where category = 'Beauty' group by category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from SQL_Retail_Sales_Analysis_utf where total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender, count(transactions_id) as total_transactions, category from SQL_Retail_Sales_Analysis_utf group by gender, category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
create table #temp_table; 

select MONTH(sale_date) as months,
YEAR(sale_date) as years, 
avg(TRY_CAST(total_sale as INT))as total_sales
into #temp_table
from SQL_Retail_Sales_Analysis_utf 
group by MONTH(sale_date), YEAR(sale_date)
order by total_sales DESC


select years, max(total_sales) from #temp_table group by years
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
select top 5 customer_id, sum(TRY_CAST(total_sale as INT)) as total_saless from SQL_Retail_Sales_Analysis_utf group by customer_id order by total_saless DESC;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select category, count(distinct(customer_id)) from SQL_Retail_Sales_Analysis_utf group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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

```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
