create database sql_joins;
show databases;
use sql_joins;

create table cricket (cricket_id int auto_increment, name varchar(30), 
primary key(cricket_id));
create table football (football_id int auto_increment, name varchar(30), 
primary key(football_id));

insert into cricket (name)
values ('Stuart'), ('Michael'), ('Johnson'), ('Hayden'), ('Fleming');

select * from cricket;

insert into football (name)
values ('Stuart'), ('Johnson'), ('Hayden'), ('Langer'), ('Astle');

select * from football;

select * from cricket as c inner join 
football as f
where c.name = f.name;

# OR
select * from cricket as c inner join
football as f
on c.name = f.name;

# OER

select c.cricket_id, c.name, f.football_id, f.name
from cricket as c inner join football as f
on c.name = f.name;

use sakila;
show tables;

# 1a. Display the first and last names of all actors from the table actor.
select * from actor;
select first_name, last_name from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(first_name, ' ', last_name)) as 'Actor Name' from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN.
select * from actor
where last_name like '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor
where last_name like '%IT%'
order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

# 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
alter table actor add middle_name varchar(25) after first_name;
select * from actor;

# 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
alter table actor modify column middle_name blob;

-- 3c. Now delete the middle_name column. 
alter table actor drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as last_name_count from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(last_name) as last_name_count from actor
group by last_name
having last_name_count > 1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husbands yoga teacher. Write a query to fix the record.
update actor set first_name = 'HARPO'
where (first_name = 'GROUCHO' and last_name = 'WILLIAMS');
select * from actor;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
update actor set first_name = case
when first_name = 'HARPO' then 'GROUCHO'
else first_name = 'MUCHO GROUCHO'
end
where actor_id = 172;
select * from actor;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;
select * from address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from staff;
select s.first_name, s.last_name, a.address 
from staff as s inner join address as a
where s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select * from payment;
select s.first_name, s.last_name, sum(p.amount) as Tot_amt
from staff as s inner join payment as p
where (s.staff_id = p.staff_id and month(p.payment_date) = 8 and year(p.payment_date) = 2005)
group by s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(fa.actor_id) as actor_count
from film as f inner join film_actor as fa
on (f.film_id = fa.film_id)
group by f.title
order by actor_count desc;

# Alphabetical order of titles
SELECT f.title, COUNT(a.actor_id) AS 'Number of Actors' 
FROM film f INNER join film_actor a 
ON (f.film_id = a.film_id) 
GROUP BY f.title ORDER BY 'Number of Actors' DESC;

select * from film_actor;
select * from film;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select f.title, count(i.film_id) as film_count
from film as f inner join inventory as i
where (f.film_id = i.film_id and f.title = 'Hunchback Impossible')
group by i.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select * from payment;
select * from customer;

select c.last_name, c.first_name, sum(p.amount) as tot_paid
from customer as c inner join payment as p
where(c.customer_id = p.customer_id)
group by c.last_name
order by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title, l.name
from film as f inner join language as l
on (f.language_id = l.language_id)
where (f.title like 'K%' or f.title like 'Q%' and l.name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film_list;
select title, actors from film_list
where (title = 'Alone Trip');

-- OR

select * from actor; # actor_id
select * from film_actor; # actor_id, film_id
select * from film; # film_id

select a.first_name, a.last_name 
from actor as a inner join film_actor as fa inner join film as f
where (a.actor_id = fa.actor_id and fa.film_id = f.film_id and f.title = 'Alone Trip');

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
select * from customer_list; #name, country, ID
select * from customer; #customer_id, email, first, last
select cl.name, c.email
from customer_list as cl inner join customer as c
where (cl.ID = c.customer_id and cl.country = 'Canada');

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
select * from film_list;
select title, category from film_list
where (category = 'Family');

-- 7e. Display the most frequently rented movies in descending order.
select * from film; # film_id, title
select * from inventory; # film_id, inventory_id
select * from rental; # inventory_id, count(inventory_id)
select f.title, count(f.title) as rentals
from film as f inner join inventory as i inner join rental as r
where (f.film_id = i.film_id and i.inventory_id = r.inventory_id)
group by f.title
order by rentals desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from rental;#rental_id, inventory_id
select * from payment; #rental_id, amount
select * from inventory;#inventory_id, store_id
select i.store_id, sum(p.amount) as tot_dollars
from inventory as i inner join rental as r inner join payment as p
on (i.inventory_id = r.inventory_id and r.rental_id = p.rental_id)
group by i.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select * from store; #store_id, address_id
select * from address; # address_id, city_id
select * from city; # city_id, city, country_id
select * from country; # country_id, country

select store.store_id, city.city, country.country
from store inner join address inner join city inner join country
where (store.address_id = address.address_id and address.city_id = city.city_id and city.country_id = country.country_id)
group by store.store_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category; #name, category_id
select * from film_category; # category_id, film_id
select * from inventory; # film_id, inventory_id
select * from rental; # inventory_id, rental_id
select * from payment; # rental_id, amount

select c.name as 'Genre', sum(p.amount) as Gross_revenue
from category as c inner join film_category as fc inner join inventory as i inner join rental as r inner join payment as p
where(c.category_id = fc.category_id and fc.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id = p.rental_id)
group by c.name
order by Gross_revenue desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you havent solved 7h, you can substitute another query to create a view.
create view Top_5_Genres as 
select c.name as 'Genre', sum(p.amount) as Gross_revenue
from category as c inner join film_category as fc inner join inventory as i inner join rental as r inner join payment as p
where(c.category_id = fc.category_id and fc.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id = p.rental_id)
group by c.name
order by Gross_revenue desc
limit 5;

-- 8b. How would you display the view that you created in 8a?
# View the created View
select * from Top_5_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view Top_5_Genres;




