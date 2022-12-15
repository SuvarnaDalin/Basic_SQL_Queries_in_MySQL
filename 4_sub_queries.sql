use sql_intro;
show tables;
select * from employees;
##### SELECT
-- Get employee with max salary
select Emp_name from employees
where Salary = (select max(Salary) from employees);

-- Get employees with salary less than avg salary of all employees
select Emp_name, Salary from employees
where Salary < (select avg(Salary) from employees);

##### INSERT
create table products 
(product_id int, item varchar(30), sell_price float, product_type varchar(30));

insert into products values
(101, 'Jewellery', 1800, 'Luxury'),
(102, 'T-Shirt', 100, 'Non-Luxury'),
(103, 'Laptop', 1300, 'Luxury'),
(104, 'Table', 400, 'Non-Luxury');

select * from products;
create table orders
(order_id int, product_sold varchar(30), selling_price float);

insert into orders
select product_id, item, sell_price from products
where product_id in (select product_id from products where sell_price > 1000);

select * from orders;

-- UPDATE SUBQUERY
show tables;
-- drop table employees_b;
create table employees_b like employees;
insert into employees_b select * from employees;
select * from employees_b;
SET SQL_SAFE_UPDATES = 0;
update employees
set Salary = Salary * 0.35
where age in (select age from employees_b where age >= 27);

# Delete Subquery
delete from employees
where age in (select age from employees_b where age <= 32);
select * from employees_b;
select * from employees;

##### Excercise on sub queries using sakila database
use sakila;
show tables;

-- Find the full name and email address of all customers that have rented an action movie.
select * from customer;# customer id, storeid, email, lname, fname
select * from rental;# customer id,inventory_id
select * from inventory; # inventory_id, film_id
select * from film_list; # FID, category
select concat(first_name, ' ', last_name) as Cust_name, email from customer
where customer_id in (select customer_id from rental 
where inventory_id in (select inventory_id from inventory
where film_id in (select FID from film_list
where (category = 'Action'))));

-- Find the name of each film, its category, and the aggregate number of films that fall within that category
select * from category; # category_id, name
select * from film_category; # category_id, film_id
select * from film; # title, film_id

select f.title, c.name, new_t.cat_count
from film as f join film_category as fc using(film_id) join category as c using(category_id)
join (select count(*) as cat_count, category_id from film_category group by category_id) as new_t using (category_id);

SELECT film.title, category.name, `count`.count_of_category FROM film 
JOIN film_category USING(film_id) 
JOIN category USING (category_id) 
JOIN (SELECT count(*) AS count_of_category, category_id FROM film_category fc GROUP BY category_id) `count` USING (category_id);

-- Average payment for each customer
select * from payment;
select * from customer;
select concat(c.first_name, ' ', c.last_name) as Customer, avg(p.amount) as avg_payment
from customer as c inner join payment as p
where(c.customer_id = p.customer_id)
group by c.customer_id;

-- All payments that exceed the average for each customer along with the total count of payments exceeding the average.
select * from payment; # cust_id, amount
select * from customer; # cust_id, f_name, l_name
select c.first_name, c.last_name, p.amount, count(p.amount) as count_above_avg 
from customer as c inner join payment as p
where (p.customer_id = c.customer_id and amount > (select avg(amount) from payment as p2 where p2.customer_id = p.customer_id) )
group by c.customer_id;

SELECT customer_id, CONCAT(first_name, " ", last_name) AS name, amount, COUNT(amount) FROM customer 
JOIN payment p1 USING(customer_id) WHERE amount > 
(SELECT AVG(amount) FROM payment p2 WHERE p2.customer_id=p1.customer_id) 
GROUP BY customer_id;

-- Create a new column classifying existing columns as either low or high value transactions based on the amount of payment.
-- low: 0-5, high: >5
select * from payment;
select customer_id, amount,
case when amount>0 and amount<5 then 'Low'
when amount>5 then 'High'
end as category
from payment;
