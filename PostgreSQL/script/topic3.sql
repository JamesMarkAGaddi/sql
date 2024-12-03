--single row transactions

--record per record ang transaction, line per line

--selection
select *  from manager;
--projection center column using lpad and rpad
select id, lpad(rpad(firstname, length(firstname) + (20 - length(firstname))/2 ), 20) as firstname, salary from manager;
--using alias with column names
select id, upper(firstname), length(firstname) as "firstname length" from manager; 
--concat 
--select id, concat(firstname, ' ', gender) as 'firstname and gender' from manager;
select id, firstname || ' ' || gender as "firstname and gender"from manager;
--convert String to_date and to_number
select id, firstname, to_date('2010 December 10', 'YYYY Month DD') as "bday" from manager;
select id, firstname, to_number('2,934.5050','9G999D99999') as salary from manager;
--NUMBER FUNCTIONS
select id, firstname, firstname || ' ' || gender || ' ' || to_char(salary,'999G999D000') as "firstname with gender and salary" from manager;
set client_encoding = 'UTF8';
select id, firstname, firstname || ' ' || gender || ' ' || CHR()||to_char(salary,'FM999G999D000') as "firstname with gender and salary" from manager;
select id, firstname, abs(CAST(salary + 10230.21433 as numeric(10,2))) as salary from manager;
select id, firstname, round(CAST(salary + 10230.21433 as numeric(10,2)),2) as salary, age::numeric(10,2), birthday::varchar(100)from manager;

--TEMPORAL FUNCTIONS
select to_char(birthday, 'MONTH DD, YYYY') as date from manager;
select date_part('year', birthday) as "birthday year" from manager;
select date_part('month', birthday) as "birthday month" from manager;
select date_part('day', birthday) as "birthday day" from manager;
select now();
select now() - birthday as life from manager;
select age(now(), birthday) as age from manager;
select age(cast(now() as date), birthday) as age from manager;
select birthday - INTERVAL '3 years 5 months 6 days' as difference from manager; 
select cast(now() as date) > birthday as equal from manager;

create table stocks(
	id smallint not null primary key,
	commision float,
	rate float,
	amount float not null default 1.0);
	
insert into stocks values(1, NULL, NULL, 10);
insert into stocks values(2, 500.00, 0.10, 10);
insert into stocks values(3, 1000.00, 0.20, 1000);

--validators sa table 
--coalescing - traversing through the list of objects to give a not null one
--syempre di mo pagsasamahin yung minumultiply mo sa isang coalesce, mali na formula lol
select id, amount + (commision * rate) as "total profit" from stocks;
select id, amount + (coalesce(commision, amount, 0.0) * coalesce(rate, 0.0)) as total_profit from stocks;
-- if nagdistinct ka na wag ka na gumamit ng pkey or uniquekey
select distinct firstname from manager; 
 
 with stocks_cte as (
    select id, amount + (COALESCE(commision, amount, 0.0) * COALESCE(rate, 0.0)) as "total profit"
    from stocks
)

select 
    id,"total profit",
    case 
        when "total profit" > 1000.00 then 'WIN' 
        when "total profit" = 1000.00 then 'BALIK TAYA' 
        else 'LUGI'
    end as "profile analysis"
from stocks_cte;

