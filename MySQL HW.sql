
use sakila;

-- 1a. 
select first_name, last_name from actor;

-- 1b
ALTER TABLE actor 
ADD COLUMN `Actor Name` VARCHAR(50);
UPDATE actor set `Actor Name` = CONCAT(first_name,' ', last_name);

CREATE TRIGGER insert_trigger
BEFORE INSERT ON actor
FOR EACH ROW
SET new.`Actor Name` = CONCAT(new.first_name, ' ', new.last_name);

CREATE TRIGGER update_trigger
BEFORE UPDATE ON actor
FOR EACH ROW
SET new.`Actor Name` = CONCAT(new.first_name, ' ', new.last_name);


-- 2a.
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b
select actor_id, first_name, last_name from actor
where last_name like "%GEN%";

-- 2c
select * 
from actor
where last_name like '%LI%'
Order by last_name, first_name;

-- 2d
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
Alter table actor
add column middle_name varchar(30)
after first_name;

-- 3b
Alter table actor
modify column middle_name blob;

-- 3c
Alter table actor
drop column middle_name;

-- 4a
-- select last_name
-- from actor;
-- select count(last_name) 
-- from actor;
-- select count(distinct(last_name))
-- from actor;

select last_name, count(last_name)
from actor
group by last_name;

-- 4b
select last_name, count(*) as cnt
from actor
group by last_name
having cnt>1;

-- 4c
Update actor
set first_name = "HARPO"
where `Actor Name` = "GROUCHO WILLIAMS";
-- checking results:
select *
from actor
where `Actor Name` = "HARPO WILLIAMS";

-- 5a
show create table address;

-- 'address', 'CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'

-- 6a
describe staff;
describe address;
select first_name, last_name, address.address
from staff
left outer join address
using (address_id);

-- 6b
describe payment;

select s.staff_id, s.first_name, s.last_name, amount_aug.total
from 
(
SELECT staff_id,
sum(amount) As total
FROM payment p
where payment_date BETWEEN '2005-08-01' AND '2005-08-31'
group by staff_id
) as amount_aug
join 
staff s
using (staff_id);

-- 6c
select film_id, title, actor_cnt
from
film f
join
(
select film_id, count(*) as actor_cnt
from film_actor
group by film_id
) as fa
using (film_id);


-- 6d
select copy
from
(
select film_id, count(*) as copy
from inventory
group by film_id
) as inv_query
where film_id = 
(
select film_id
from film
where title = 'Hunchback Impossible'
) ;

-- 6e
select * 
from customer
join
( 
select customer_id, 
sum(amount) As ttl
from payment
group by customer_id
) as cpay
using (customer_id)
order by last_name;



-- 7a
describe film;
select title 
from film
where title like "K%"
or title like "Q%"; 

-- 7b

select *
from actor
where actor_id IN
(
select actor_id
from film_actor
where film_id =
(
select film_id
from film
where title = "Alone Trip"
)
);

-- 7c
select *
from customer
where address_id in
(
select address_id
from address
where city_id IN
(
select city_id 
from city
where country_id =
(
select country_id
from country
where country = "Canada"
)
)
);

-- 7d
select *
from film
where film_id IN
(
select film_id
from film_category
where category_id = 
(
select category_id
from category
where name = "family"
)
);


-- 7e

select film_id, title, count(film_id) as cnt
from
(
select *
from film
right join 
(
select r.rental_id, r.inventory_id, i.film_id
from rental r
left join inventory i
using (inventory_id)
) as rental_freq
using (film_id)
) as film_rent
group by film_id
order by cnt DESC;



-- 7f
select *
from store s
join
(
select staff_id, sum(amount) as total
from payment
group by staff_id
) as sa
where sa.staff_id = s.manager_staff_id;


-- 7g
select store_city.store_id, store_city.address, store_city.city, country
from country
right join
(
select city_add.store_id, city_id, city_add.address, city, country_id 
from city
right join
(
select store_id, address_id, address, city_id
from store
left join address
using (address_id)
) as city_add
using (city_id)
) as store_city
using(country_id);



-- 7h
select ca.name, sum(amount) as total
from category ca
right join
(
select category_id, film_id, amount
from film_category
right join
(
select film_id, pmt_rnt.amount
from inventory
right join
(
select payment_id, rental_id, rnt.inventory_id, amount
from payment
left join 
rental rnt
using (rental_id)
) as pmt_rnt
using (inventory_id)
)as film_amnt
using (film_id)
) as cate_amnt
using (category_id)
group by name
order by total DESC
Limit 5;


-- 8a
create view top_five_genres
as
select 
ca.name, sum(amount) as total
from category ca
right join
(
select category_id, film_id, amount
from film_category
right join
(
select film_id, pmt_rnt.amount
from inventory
right join
(
select payment_id, rental_id, rnt.inventory_id, amount
from payment
left join 
rental rnt
using (rental_id)
) as pmt_rnt
using (inventory_id)
)as film_amnt
using (film_id)
) as cate_amnt
using (category_id)
group by name
order by total DESC
Limit 5;

-- 8b
show create view top_five_genres;
select * from top_five_genres;

-- 8c
drop view top_five_genres;


