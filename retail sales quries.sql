SELECT * FROM retail_sales;
select count(*) from retail_sales;
-- how many sales or customers we have?
select count(customer_id) as No_of_Customers
from retail_sales;
-- how many unique customers we have?
select count(distinct customer_id) as unique_customers from retail_sales;

-- how many unique categories we have?
select count(distinct category) as unique_categories from retail_sales;
select distinct category from retail_sales;

-- how many female / males customers do we have?
select gender, count(*) as num_females
from retail_sales
where gender = 'Female'
group by gender;

select gender, count(*) as num_females
from retail_sales
where gender = 'Male'
group by gender;
-- conclusion female buyers are more than males

--     EDA (data analysis or buisness key problems   --------------------------

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * 
from retail_sales
where sale_date = '2022-11-05';

alter table retail_sales change ï»¿transactions_id transaction_id int;
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 10 in the month of Nov-2022  (to_char(date,'YYYY-mm') is oracle base function)
select *
from retail_sales
where category='Clothing'
and
date_format(sale_date,'%Y-%m') = '2022-11'
and quantity >= 4;
-- in sql server we can do this: FORMAT(sale_date, 'yyyy-MM') = '2022-11'; or CONVERT(varchar(7), sale_date, 120) = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) and total number of orders for each category.
select category,sum(total_sale) as total_sale, count(*) as total_orders
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age_of_cutomers
from retail_sales
where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select count(*) total_orders
from retail_sales
where total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,
count(*) as total_Transactions
from retail_sales
group by category,gender
order by category;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select years,months,average_monthly_sales from 
(	
	select  year(sale_date) as years, month(sale_date) as months, round(avg(total_sale),2) as average_monthly_sales, -- date_format(sale_date,'%Y') as Years,date_format(sale_date,'%m') as Months,round(avg(total_sale),2) as average_monthly_sales
	rank() over(partition by year(sale_date) order by round(avg(total_sale),2) desc) as ranked
	from retail_sales
	group by year(sale_date), month(sale_date) 
) as t1
where ranked = 1;
-- order by average_monthly_sales;  -- date_format(sale_date,'%Y'), date_format(sale_date,'%m')
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as Max_sales
from retail_sales
group by customer_id
order by Max_sales desc
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as unique_Customers 
from retail_sales
group by category;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with time_shifts as
(
	select *,
	case
		when hour(sale_time) < 12 then 'Morning'
		when hour(sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shifts 
	from retail_sales
)
select shifts,count(quantity) as number_of_orders
from time_shifts
group by shifts;
-- group by 
-- case
-- 	when hour(sale_time) < 12 then 'Morning'
--     when hour(sale_time) between 12 and 17 then 'Afternoon'
--     else 'Evening'
-- end;
