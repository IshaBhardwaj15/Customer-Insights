--creating database insights
create database insights
go

--using database insights
use insights
go

--creating schema called insights
create schema insights
go

--creating table country
CREATE TABLE insights.country
(
	country_id INT PRIMARY KEY,
	country_name VARCHAR(50),
	head_office VARCHAR(50)
);

--inserting data into table country
INSERT INTO insights.country
	(country_id, country_name, head_office)
VALUES
(1, 'UK', 'London'),
(2, 'USA', 'New York'),
(3, 'China', 'Beijing');

--creating table customers
CREATE TABLE insights.customers
(
	customer_id INT PRIMARY KEY,
	first_shop DATE,
	age INT,
	rewards VARCHAR(50),
	can_email VARCHAR(50)
);

--inserting data int table customers
INSERT INTO insights.customers
	(customer_id, first_shop, age, rewards, can_email)
VALUES 
(1, '2022-03-20', 23, 'yes', 'no'),
(2, '2022-03-25', 26, 'no', 'no'),
(3, '2022-04-06', 32, 'no', 'no'),
(4, '2022-04-13', 25, 'yes', 'yes'),
(5, '2022-04-22', 49, 'yes', 'yes'),
(6, '2022-06-18', 28, 'yes', 'no'),
(7, '2022-06-30', 36, 'no', 'no'),
(8, '2022-07-04', 37, 'yes', 'yes');

--creating table orders
CREATE TABLE insights.orders
(
	order_id INT PRIMARY KEY,
	customer_id INT,
	date_shop DATE,
	sales_channel VARCHAR(50),
	country_id INT,
	FOREIGN KEY (customer_id) REFERENCES insights.customers(customer_id),
	FOREIGN KEY (country_id) REFERENCES insights.country(country_id)
);

--Inserting data into table orders
INSERT INTO insights.orders
	(order_id, customer_id, date_shop, sales_channel, country_id)
VALUES 
(1, 1, '2023-01-16', 'retail', 1),
(2, 4, '2023-01-20', 'retail', 1),
(3, 2, '2023-01-25', 'retail', 2),
(4, 3, '2023-01-25', 'online', 1),
(5, 1, '2023-01-28', 'retail', 3),
(6, 5, '2023-02-02', 'online', 1),
(7, 6, '2023-02-05', 'retail', 1),
(8, 3, '2023-02-11', 'online', 3);

--creating table products
CREATE TABLE insights.products
(
	product_id INT PRIMARY KEY,
	category VARCHAR(50),
	price NUMERIC(5,2)
);

--inserting data into table products
INSERT INTO insights.products
	(product_id, category, price)
VALUES
(1, 'food', 5.99),
(2, 'sports', 12.49),
(3, 'vitamins', 6.99),
(4, 'food', 0.89),
(5, 'vitamins', 15.99);

--creating table baskets
CREATE TABLE insights.baskets 
(
	order_id INT,
	product_id INT,
	FOREIGN KEY (order_id) REFERENCES insights.orders(order_id),
	FOREIGN KEY (product_id) REFERENCES insights.products(product_id)
);

--inserting data into table baskets
INSERT INTO insights.baskets
	(order_id, product_id)
VALUES 
(1, 1),
(1, 2),
(1, 5),
(2, 4),
(3, 3),
(4, 2),
(4, 1),
(5, 3),
(5, 5),
(6, 4),
(6, 3),
(6, 1),
(7, 2),
(7, 1),
(8, 3),
(8, 3);

--checking how our tables look like
select * from insights.country
select * from insights.customers
select * from insights.orders
select * from insights.products
select * from insights.baskets

--Query 1 What are the names of all the countries in the country table?
select country_name
from insights.country;

--Query 2 What is the total number of customers in the customers table?
select COUNT(distinct customer_id) as no_of_customers
from insights.customers

--Query 3 What is the average age of customers who can receive marketing emails (can_email is set to 'yes')?
select AVG(age) as Average_Age
from insights.customers
where can_email='yes'

--Query 4 How many orders were made by customers aged 30 or older?
select COUNT(o.order_id) as no_of_orders
from insights.orders as o
join insights.customers as c on 
	c.customer_id=o.customer_id
where c.age>=30

--Query 5 What is the total revenue generated by each product category?
select category,SUM(price) as total_revenue
from insights.products
group by category

--Query 6 What is the average price of products in the 'food' category?
select AVG(price) as average_price_for_food_category
from insights.products
where category='food'

--Query 7 How many orders were made in each sales channel (sales_channel column) in the orders table?
select sales_channel,COUNT(order_id) as order_count
from insights.orders
group by sales_channel

--Query 8 What is the date of the latest order made by a customer who can receive marketing emails?
select top 1 o.date_shop as latest_order_date
from insights.orders as o
join insights.customers as c on
	c.customer_id=o.customer_id
where c.can_email='yes'
order by o.date_shop desc

--Query 9 What is the name of the country with the highest number of orders?
select  top 1 c.country_name, COUNT(o.order_id) as order_count
from insights.country as c
join insights.orders as o on
	o.country_id=c.country_id
group by c.country_name
order by order_count desc

--Query 10 What is the average age of customers who made orders in the 'vitamins' product category
select AVG(c.age) as average_age
from insights.orders as o
join insights.customers as c on
	c.customer_id=o.customer_id
join insights.baskets as b on
	b.order_id=o.order_id
join insights.products as p on
	p.product_id=b.product_id
where p.category='vitamins'