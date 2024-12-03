--auto-increment 
/* sineset ang first num
create sequence manager_id_seq
start with 1 increment by 1;
*/

/*
create sequence manager_id_seq;

alter table manager
alter column id
set default nextval('manager_id_seq');

*/
/*
create sequence utility_id_seq;
create table utility (
	id integer not null primary key default nextval('utility_id_seq'),
	fullname varchar(100) not null	
);	

INSERT INTO utility (fullname)
VALUES ('Alice');

INSERT INTO utility (fullname)
VALUES ('Apo');
*/
/*
create table administrator(
	id integer not null primary key default nextval('utility_id_seq'),
	fullname varchar(100) not null,	
	role varchar(100) not null	
);
*/
/*
insert into utility(fullname) values ('James Reid');
insert into administrator(fullname, role) values ('John Chua', 'CEO');
*/
--merging of columns using UNION then putting a condition in select
select id, fullname from utility where fullname like '%e%' union select id, role from administrator where fullname like '%e%';
--INTERSECT
select id, firstname from manager intersect select id, fullname from utility;
--EXCEPT
select id, firstname from manager except select id, fullname from utility;
--SUBQUERY
select * from manager where supervisors in (select supervisors from manager);
-- CTE
/* 
with statistics as (
     select gender, stddev(salary) "standard deviation", min(salary) as minimum, 
            max(salary) as maximum
     from manager
     group by gender

)
select * from statistics;
*/
--VIEW
create view project_data_view as select * from project a natural join project_members b;
create or replace view project_data_view as select * from project;
--STORED PROC
create or replace procedure helloworld() 
language plpgsql as 
$$ 
begin
	raise notice 'helloworld';
end; 
$$; 

create or replace procedure insert_project_count_sp(id integer, pname varchar(10), pdate date) 
language plpgsql as 
$$ 
begin
	insert into project values(id,pname,pdate);
end; 
$$; 

create or replace procedure insert_project_count_sp(id integer, pname varchar(10), pdate date, inout rcount integer) 
language plpgsql as 
$$ 
begin
	insert into project values(id,pname,pdate);
	
	select count(*) into rcount from manager;
end; 
$$; 

create or replace procedure insert_salary_sp(inc_salary float, local_id integer, inout is_success boolean)
language plpgsql as 
$$ 
declare
	salary_prev float := 0.0;
	salary_after float := 0.0;
begin
	--retrieve prev -> update -> add inc -> set prev to after
	select salary into salary_prev from manager where id = local_id;
	update manager
	set salary = salary + inc_salary where id = local_id;
	select salary into salary_after from manager where id = local_id;
--conditional para sa java, add inout param
	if salary_prev < salary_after
			then is_success := true;
	else is_success := false;
	end if;
	--	raise notice 'Total new salary %', total;

end; 
$$; 
--calling the sp
call insert_salary_sp(10000.00, 102);

create or replace procedure show_projects_join_count_sp()
language plpgsql as 
$$ 
declare
	proj_count integer := 0;
	rec record;
begin
	for rec in select * from project natural join project_members
		loop
			raise notice '% % %', rec.projid, rec.projname, rec.projdate;
	end loop;
	select count(*) into proj_count from project natural join project_members;
	raise notice 'TOTAL JOIN RECORDS: %', proj_count;
end; 
$$; 













