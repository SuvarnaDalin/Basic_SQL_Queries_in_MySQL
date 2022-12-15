show databases;
use mysql;
show tables;
use world;
show tables;
select * from city;
describe city;
create database sql_intro;
show databases;


create table emp_details (Name varchar(25), Age int, sex char(1),
doj date, city varchar(15), salary float);
describe emp_details;
insert into emp_details
values("Jimmy", 35, "M", "2005-05-30", "Chicago", 70000),
("Shane", 30, "M", "1999-06-25", "Seattle", 55000),
("Marry", 28, "F", "2009-03-10", "Boston", 62000),
("Dwayne", 37, "M", "2011-07-12", "Austin", 57000),
("Sara", 32, "F", "2017-10-27", "New York", 72000),
("Ammy", 35, "F", "2014-12-20", "Seattle", 80000);
describe emp_details;
select * from emp_details;
select distinct city from emp_details;
select count(name) as count_name from emp_details;
select sum(salary) from emp_details;
select avg(salary) as Avg_Salary from emp_details;
select name, age, city from emp_details;

select * from emp_details where age > 30;
select name, sex, city from emp_details where sex = 'F';
select * from emp_details where 
city = "Chicago" or city = "Austin";
select * from emp_details where salary > 60000;
select * from emp_details where 
city in ('Chicago', 'Austin');
select * from emp_details where 
doj between "2000-01-01" and "2010-12-31";
select * from emp_details where
age>30 and sex="M";
select sex, sum(salary) as Tot_Salary from emp_details 
group by sex;
select * from emp_details order by salary;
select * from emp_details order by salary desc;
select (10+20) as addition;
select (10-20) as subtract;
select length('New Zealand') as total_len;
select repeat('#', 10);
select upper('india');
select lower('INDIA');
select curdate();
select day(curdate());
select now();

# STRING FUNCTIONS
select upper('India') as upper_case;
select lower('NIDIA') as lower_case;
select lcase('NIDIA') as lower_case;
select char_length('NIDIA') as char_len;
select character_length('vbg5%^') as char_len;
select name, char_length(name) as tot_len from emp_details;
select concat('India', ' is', ' in', ' Asia') as merged;
select name, city, concat(name, " : ", age) as name_age 
from emp_details;
select reverse('India');
select reverse(Name) from emp_details;
select replace('Orange is a vegetable', 'vegetable', 'fruit') 
as replaced;
select ltrim("       India   ") as trimmed;
select length(ltrim('   India      ')) as ltrimmed;
select length(rtrim("    India   ")) as rtrimmed;
select position("fruit" in "Orange is a fruit") as fruit_pos;
select ascii('a');
select ascii('4');

# GROUP BY and HAVING
select sex, avg(salary) as Avg_salary from emp_details 
group by sex 
order by Avg_salary desc;

