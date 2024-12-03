--/*
select 'Hello world'; 
-- lowercase mo na kasi ilolowercase din naman to sa likod
-- lowercase alaso your names for vars, tables, etc

-- data definition languange DDL
-- ito yung mga operations when creating schema: table, database, view, sp, sf, ds, truncate

*/

create database hrms;
/*
-- this is how you drop database
drop database hrms;
*/

-- connect to the database
-- \c hrms

--table structure varName varType
create table manager(
	id integer not null primary key,   	-- 11 digits kaya buong integer
	firstname varchar(100) not null,	-- max no. of characters, varying chars
	gender char(1) not null default 'F',
	age integer not null check (age >= 0),
	salary float not null,
	birthday date not null check (birthday >= '1920-01-01')	
);

--value in ascending order
create table data_types (
--integer types
	age smallint not null, 
	empId int not null, 
	popSize bigint not null,
--real number types
	salary double precision not null,
	accountAmount real,
	donation decimal not null,
--for varying value under real numbers (total_digits, decimal places)
	mortgage numeric(10,3) not null,
--text-based
	nickname char(10) not null,
	position varchar(200) not null,
	comment text not null,
--boolean
	isEmployed boolean not null,
--temporal types
	timeIn time not null,
	birthday date not null,
	dateResigned timestamp not null,
	moneyTxDate timestamptz not null,
--auto-increment
	id serial not null,
--monetray
	amount money not null,
-- binary types
	isTurnOff bit not null
);

--drop table data_types;

--default nilalagay after ng not null kasi kapag walang value di mage-error kasi ilalagay nya yung default value mo
--check is used para may restrictions lalo sa mga big datatypes

create table developer(
--auto-increment
--isa lang ang hahawak ng primary key ha
	id serial not null primary key,
--pwede sya maging group keys, pwede sya ipartner sa pKey para strong sila pero mahina kapag mag-isa
	empId integer not null unique,
--you will use reference key para matawag mo para syang method
	devId integer references manager(id)
);

--this is how to alter tables
--adding column to the last column
alter table developer add column firstname varchar(100) not null default '';
--deleting column
alter table developer drop column firstname;
--modifying data type
alter table developer alter column empId type smallint;
--rename 
alter table developer rename column empId to employeeId;
--adding minor constraints (default, restrictions)
alter table developer alter column devId set default 1;;
alter table developer alter column devId set not null;
alter table developer add constraint devId check(devId>=1);
alter table data_types add constraint empId unique(empId);

--DATA ENTRY RULES
--what if dalawa ang primary key mo?

create table insurance(
	policyId integer not null,
	id serial not null,
	primary key(policyId, id)
);

-- you may use this combination better to
create table allowance(
	allowanceId integer not null primary key,
	id serial not null unique
);