use sakila;
show tables;
-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select * from actor;
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

-- Find all actors whose last name contain the letters GEN
select concat(first_name, ' ', last_name) from actor
where last_name like '%GEN%';

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor 
-- named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant)
alter table actor add column description blob;
select * from actor;

-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop column description;

-- List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as lastname_count from actor
group by last_name
order by lastname_count desc;

-- Find ratio of rental revenue to number of actors for each film. You are supposed to list number of actors per film as well its 
-- accumulative rental revenue. 
-- Sort the records in descending order of rental revenue to number of actors ratio (revenue/actors).
select * from film; #film_id, title
select * from film_actor; #film_id, actor_id
select * from inventory; #film_id, inv_id
select * from rental; #inv_id, rental_id
select * from payment; #rental_id, amount

select f.title, act.actor_count, rev.revenue, rev.revenue/act.actor_count as rev_ratio
from (select film_id, count(actor_id) as actor_count from film_actor group by actor_id) as act join
(select i.film_id, sum(p.amount) as revenue from inventory i join rental r using(inventory_id) join payment p using(rental_id) group by i.film_id) as rev using (film_id) join
film as f using(film_id) group by rev.revenue/act.actor_count;

-- Number of customers who never rented BREAKING HOME
select * from film; #film_id, title
select * from inventory; #film_id, inv_id
select * from rental; #inv_id, rental_id
select count(r.customer_id) - breaking_cust.num_break_customers as num_customers
from film as f join inventory as i using (film_id) join rental as r using (inventory_id) join
(select count(r.customer_id) as num_break_customers
from film as f join inventory as i using (film_id) join rental as r using (inventory_id) where (f.title = 'BREAKING HOME')) as breaking_cust;

-- List accumulative replacement cost of the movies that were never rented
show tables;

-- Find out customers who have rented movies from each category
select * from customer; #customer_id, store_id
select * from inventory;# film_id, inv_id, store_id
select * from film_category;# film_id, category_id
select * from category; # category_id, name(category)
select * from rental;# inv_id, customer_id

select c.customer_id, ct.name 
from customer as c join inventory as i using (store_id) 
join film_category as fc using (film_id) join category as ct using (category_id)
group by ct.category_id;



-- List total revenue of each film with 10 or more actors playing the act. Sort the output on descending order of the revenue
