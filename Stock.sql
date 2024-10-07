drop  schema assignment;

# creating new database schema
create schema assignment;

Set sql_safe_updates=0;
set sql_mode='';
    
select count(*) from bajaj;
select count(*) from Eicher;
select count(*) from Hero;
select count(*) from infosys;
select count(*) from tcs;
select count(*) from tvs;

    
# ................(1)..............................
#(a) Create a new table named'bajaj1' containing date, close price,20 day ma and 50 day ma.
 
create table bajaj1 as 
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `bajaj`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE bajaj1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `bajaj`) - 20 ;

UPDATE bajaj1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `bajaj`) - 50 ;

ALTER TABLE bajaj1 DROP ronum ;

select * from bajaj1;  

# 1(b) Create a new table named'eicher1' containing date, close price,20 day ma and 50 day ma.
 
create table eicher1 as 
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `eicher`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE eicher1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `eicher`)-20;

UPDATE eicher1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `eicher`) - 50;

ALTER TABLE eicher1 DROP ronum ;


select * from eicher1;

# 1(c) Create a new table named'hero1' containing date, close price,20 day ma and 50 day ma.
 
create table hero1 as 
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `hero`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE hero1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `hero`)-20;

UPDATE hero1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `hero`) - 50;

ALTER TABLE hero1 DROP ronum ;

select * from hero1;

#1(d) Create a new table named'infosys1'containing date, close price,20 day ma and 50 day ma.
 
create table infosys1 as
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `infosys`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE infosys1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `infosys`)-20;

UPDATE infosys1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `infosys`) - 50;

ALTER TABLE infosys1 DROP ronum ;

select * from infosys1;

#1(e)Create a new table named'tcs1' containing date, close price,20 day ma and 50 day ma.
 
create table tcs1 as
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `tcs`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE tcs1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `tcs`)-20;

UPDATE tcs1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `tcs`) - 50;

ALTER TABLE tcs1 DROP ronum ;

select * from tcs1;


    
#1(f)Create a new table named'tvs1' containing date, close price,20 day ma and 50 day ma.
 
create table tvs1 as
SELECT `Date`, `Close Price`, ROW_NUMBER() OVER () ronum,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 19 FOLLOWING) AS `20 Day MA` ,
AVG(`Close Price`) OVER ( ROWS BETWEEN 0 preceding AND 49 FOLLOWING) AS `50 Day MA`
FROM  `tvs`;

# filling the values for oldest 20 and 50 rows with null because we want moving average of 20 and 50 days.

UPDATE tvs1 SET `20 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `tvs`)-20;

UPDATE tvs1 SET `50 Day MA` = NULL
WHERE ronum > (SELECT COUNT(*) FROM `tvs`) - 50;

select * from tvs1;
ALTER TABLE tvs1 DROP ronum ;

#---------------------------------------------------------------


#(2) Create a master table containing the date and close price of all the six stocks. Column header for the price is the name of the stock 

CREATE TABLE master_table AS
SELECT b.`Date`, b.`Close Price` as Bajaj, 
		tc.`Close Price`	AS TCS, 
		tv.`Close Price`	AS TVS, 
		i.`Close Price`		AS Infosys, 
		e.`Close Price` 	AS Eicher, 
		h.`Close Price`		AS Hero
FROM bajaj1 b INNER JOIN tcs1 tc ON 	b.`Date` = tc.`Date`
			  INNER JOIN tvs1 tv ON 	b.`Date` = tv.`Date`
			  INNER JOIN infosys1 i ON  b.`Date` = i.`Date`
			  INNER JOIN eicher1 e ON	b.`Date` = e.`Date`
			  INNER JOIN hero1 h ON     b.`Date` = h.`Date` ;
SELECT * FROM master_table;

#(3)Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'. Perform this operation for all stocks.

CREATE TABLE bajaj2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from bajaj1 ;

select * from bajaj2;

CREATE TABLE eicher2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from eicher1 ;

select * from eicher2;

CREATE TABLE hero2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from hero1 ;
select * from hero2;

CREATE TABLE infosys2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from infosys1 ;
select * from infosys2;

CREATE TABLE tcs2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from tcs1 ;
select * from tcs2;


CREATE TABLE tvs2 AS
select `Date`, `Close Price`,
	case
		when (`20 Day MA` > `50 Day MA`)   then 'Buy'
		when (`20 Day MA` < `50 Day MA`)   then 'Sell'
		else 'Hold'
	end as `Signal`
from tvs1 ;
select * from tvs2;



delimiter $$
CREATE FUNCTION generate_signal( dt char(20))
RETURNS char(20)
DETERMINISTIC
BEGIN
RETURN (SELECT `Signal` FROM bajaj2 WHERE `Date` = dt);
END $$
delimiter ;

-- sample query to generate a signal
SELECT generate_signal('30-July-2018') AS Signal_generated;
SELECT generate_signal('30-June-2017') AS Signal_generated;



#for inferences 
#bajaj
select `date`,`close price`
from bajaj2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from bajaj2
where `signal` = 'sell'
order by 'close price' desc
limit 1;


#eicher
select `date`,`close price`
from eicher2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from eicher2
where `signal` = 'sell'
order by 'close price' desc
limit 1;

#hero
select `date`,`close price`
from hero2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from hero2
where `signal` = 'sell'
order by 'close price' desc
limit 1;


#infosys2
select `date`,`close price`
from infosys2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from infosys2
where `signal` = 'sell'
order by 'close price' desc
limit 1;


#tcs
select `date`,`close price`
from tcs2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from tcs2
where `signal` = 'sell'
order by 'close price' desc
limit 1;



#Tvs
select `date`,`close price`
from tvs2
where `signal` = 'Buy'
order by 'close price'
limit 1;


select `date`,`close price`
from tvs2
where `signal` = 'sell'
order by 'close price' desc
limit 1;
