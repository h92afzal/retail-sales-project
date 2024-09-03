drop table if exists retail_sales;
create table retail_sales
(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age	int,
	category varchar(15),	
	quantity	int,
	price_per_unit float,	
	cogs float,
	total_sale float
);