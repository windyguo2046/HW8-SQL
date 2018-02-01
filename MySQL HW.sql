
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

SELECT * FROM payment 
WHERE payment_date BETWEEN '2015-08-01' AND '2015-08-31';






