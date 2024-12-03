--WHERE CLAUSE
/*
--operations
select * from manager where salary >= 100.00;
--inclusive conditions
select * from manager where salary between 60000.00 and 99000.00;
--validators using is
select * from stocks where commision is null;
select * from stocks where commision is not null;
select * from stocks where amount <= commision + 1000.00;
select * from stocks where commision is not null and amount <= commision + 1000.00;
select * from stocks where commision is not null or amount <= commision + 1000.00;
*/
/*
--comparison for non-numbers using regex but not the regex, RLike
select * from manager where firstname like 'M%';
select * from manager where firstname like 'H______';
select * from manager where firstname like '%b%';
--case sensitive version or RLike
select * from manager where firstname ~* 'pilar';
--not case sensitive but with regex
select * from manager where firstname ~ '^[a-z]+$';
select * from manager where firstname ~ '^[a-z]+$';
*/
/*
--sorting of table records
select * from manager where firstname ~ '[^M]' order by firstname; --ASCENDING
select * from manager where firstname ~ '[^M]' order by firstname desc; --DESCENDING
--sorting virtual columns
select id, firstname, (salary) as "total bonus" from manager where firstname ~ '[^M]' order by "total bonus" desc; --DESCENDING
--if there are null values, nasa dulo ang null pero null.
select * from stocks order by commision;
-- coalesce mo para di mag-0
select id, coalesce(commision, amount, 0.0) as commision, coalesce(rate,0), amount from stocks order by commision;
*/
/*
--FROM CLAUSE
--table relationship
--JOIN TRANSACTIONS req: refKey, forKey
*/
/*
--using simple references
--parent table
create table project(
	id smallint not null primary key,
	projName varchar(200) not null,
	projDate date not null
);
--child table
--now connect a column of this to the parent using foreign key
--numeric to numeric or string to tring only
-- do not use UUID, date
create table project_members(
	empid integer primary key,
	firstname varchar(60) not null,
	lastname varchar(60) not null,
	projid integer not null,
	foreign key(projid) references project(id) on delete cascade on update cascade
);

insert into project values (1, 'HRMS', '2024-11-11');
insert into project values (2, 'credit card app', '2025-03-25');
insert into project values (3, 'DTR System', '2025-05-05');
insert into project values (4, 'scanner', '2030-12-25');

insert into project_members values (101, 'Juan', 'Luna', 2);
insert into project_members values (102, 'Maria', 'Clara', 2);
insert into project_members values (103, 'Jose', 'Rizal', 1);
insert into project_members values (104, 'Apo', 'Mabini', 3);
*/
/*
--distributes the projName to correspending proj_members
select * from project a inner join project_members b on a.id = b.projid;
select * from project a inner join project_members b on a.id = b.projid where a.id=1;
select * from project a left join project_members b on a.id = b.projid;
select * from project a right join project_members b on a.id = b.projid;

--alter lang natin yung table so di na sya magwowork sa last topics
*/
/*
alter table manager add column supervisor integer not null default 102;
alter table manager set supervisor = 0 where id= 102;
*/
/*
--self join kunwari yung mga boss nakagruoup pa rin sa boss
select * from project a join project_members b on a.id = b.projid; 

select a.supervisor, a.firstname, a.id from manager a inner join manager b on a.id = b.supervisor; 
--cross join
select * from project, project_members;
--natural join
alter table project rename column id to projid;
select * from project a natural join project_members; --inner join shortcut
*/

--no pkey, no ukey, just strata kapag group by
--dapat mag aappear sa group by column mo yung stratified
select gender from manager group by gender;
--group by or mulitple transactions:

--count(*) avg()
--checks what's the average of each gender
select gender, count(gender), avg(salary) from manager group by gender;

/*
insert into manager values (106, 'Jose', 'M', 98, 10000.00, '1929-10-10'),
						   (107, 'Apo', 'M', 70, 60000.00, '2019-10-10');
*/
select gender, count(gender), avg(salary) from manager group by gender;
select gender, supervisors, count(gender), avg(salary), min(age), max(age), sum(salary) from manager group by gender, supervisors;
select gender, stddev(salary), variance(salary) from manager group by gender;

--group by muna before order by, ganyan order kapag mag-stats ka
select gender, stddev(salary), variance(salary) from manager group by gender having stddev(salary) > 2000;
select gender, stddev(salary), variance(salary) from manager group by gender having stddev(salary) in (2000, 100000);
select gender, stddev(salary), variance(salary) from manager where salary >= 10000 group by gender having stddev(salary) between 2000 and 100000;
select gender, stddev(salary), variance(salary) from manager where salary >= 10000 group by gender having stddev(salary) between 2000 and 100000 order by gender;

