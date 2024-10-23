create database retail;

use retail;

create table sales(
transaction_id int primary key,
sales_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(30),
quantity int,
price_per_unit int,
cogs float,
total_sales float
);

show tables;

select * from sales;

select * from sales 
limit 5;

select count(*) from sales;

-- Data Cleaning

select * from sales
where transaction_id is null;

select * from sales
where sales_date is null;

select * from sales
where sale_time is null;

select * from sales
where
transaction_id is null
or
sales_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sales is null;

select count(*) from sales;

delete from sales 
where
transaction_id is null
or
sales_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sales is null;

select count(*) from sales;

-- Data Exploration

-- How many sales we have?
select count(*) from sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_members from sales;

-- How many unique category's we have?
select distinct category from sales;


-- Data Analysis & Business key Problems and Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from sales
where sales_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is Clothing
-- and the quantity sold is more than 5 in the month of Nov-2022

select * from sales
where 
category = 'Clothing'
and
quantity >=4
and
sales_date >= '2022-11-01'
and
sales_date <= '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sales) from sales 
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items 
-- from the 'Beauty' category.
select avg(age) from sales;
select round(avg(age),2) as avg_age from sales
where category="Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from sales
where total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by 
-- each gender in each category.
select category,gender,count(transaction_id) from sales
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best 
-- selling month in each year
select 
year,
month,
avg_sale
from
(
select 
extract(year from sales_date) as year,
extract(month from sales_date) as month,
avg(total_sales) as avg_sale,
rank() over(partition by extract(year from sales_date) order by avg(total_sales) desc) as r
from sales
group by 1,2
) as t1
where r=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sales) from sales
group by 1
order by 2
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) from sales
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hour_sale
as 
(
select *,
case
when extract(hour from sale_time) < 12 then "Morning"
when extract(hour from sale_time) between 12 and 17 then "Afternoon"
else "Evening"
end as shift
from sales
)
select 
shift,count(*) as total_orders
from hour_sale
group by shift