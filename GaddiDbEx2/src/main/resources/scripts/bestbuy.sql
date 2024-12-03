create database bestbuy;
\c bestbuy;

create table salesman(
	SALESMAN_ID numeric(5) not null primary key,
	NAME varchar(30) not null,
	CITY varchar(15) not null,
	COMMISSION decimal(10,2) not null
);

create table customer(
	CUSTOMER_ID numeric(5) not null primary key,
	CUST_NAME varchar(30) not null,
	CITY varchar(15) not null,
	GRADE numeric(3),
	SALESMAN_ID numeric(5) not null	
);

create table orders(
	ORD_NO numeric(5) not null primary key, 
	PURCH_AMT decimal(8,2) not null,
	ORD_DATE date not null,
	CUSTOMER_ID numeric(5) not null,
	SALESMAN_ID numeric(5) not null,
	foreign key(SALESMAN_ID) references salesman(SALESMAN_ID) on delete cascade on update cascade,
	foreign key(CUSTOMER_ID) references customer(CUSTOMER_ID) on delete cascade on update cascade
);

--2. Create salesman_seq, customer_seq, and order_seq to generate auto-numbering for salesman_id,
--customer_id, and ord_no, respectively. Update the current sequence to accommodate current IDs of each
--table.

create sequence salesman_seq start with 5001 increment by 1;

alter table salesman
alter column SALESMAN_ID
set default nextval('salesman_seq');

create sequence customer_seq start with 3001 increment by 1;

alter table customer
alter column CUSTOMER_ID
set default nextval('customer_seq');

create sequence order_seq start with 70001 increment by 1;

alter table orders
alter column ORD_NO
set default nextval('order_seq');

--3. Create stored procedures insert_order_sp(), insert_salesman_sp(), and insert_customer_sp() that all
--has INOUT parameter isSuccess, which is set to true when the transaction is successful else false.
--Transaction will insert the following sample data below:

create or replace procedure insert_salesman_sp(
	name varchar(30), 
	city varchar(15), 
	coms decimal(10,2), 
	inout is_success boolean
) 
language plpgsql as 
$$ 
begin
    begin
        insert into salesman (NAME, CITY, COMMISSION)
        values(name, city, coms);
        is_success := true;
        raise notice 'SALESMAN INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;

create or replace procedure insert_customer_sp(
	CUST_NAME varchar(30), 
	CITY varchar(15), 
	GRADE numeric(3), 
	SALESMAN_ID numeric(5), 
	inout is_success boolean
) 
language plpgsql as 
$$ 
begin
    begin
        insert into customer (CUST_NAME, CITY, GRADE, SALESMAN_ID)
        values(CUST_NAME, CITY, GRADE, SALESMAN_ID);
        is_success := true;
        raise notice 'CUSTOMER INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;

create or replace procedure insert_orders_sp(
	PURCH_AMT decimal(8,2), 
	ORD_DATE date, 
	CUSTOMER_ID numeric(5), 
	SALESMAN_ID numeric(5), 
	inout is_success boolean
) 
language plpgsql as 
$$ 
begin
    begin
        insert into orders (PURCH_AMT, ORD_DATE, CUSTOMER_ID, SALESMAN_ID)
        values(PURCH_AMT, ORD_DATE, CUSTOMER_ID, SALESMAN_ID);
        is_success := true;
        raise notice 'ORDER INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;


/*
populate the population
5001 | James Hoog | New York | 0.15
5002 | Nail Knite | Paris | 0.13
5005 | Pit Alex | London | 0.11
5006 | Mc Lyon | Paris | 0.14
5007 | Paul Adam | Rome | 0.13
5003 | Lauson Hen | San Jose | 0.12
*/

call insert_salesman_sp('James Hoog', 'New York', 0.15, true);
call insert_salesman_sp('Nail Knite', 'Paris', 0.13, true);
call insert_salesman_sp('Lauson Hen', 'San Jose', 0.12, true);
select nextval('salesman_seq'); -- 5004 is skipped
call insert_salesman_sp('Pit Alex', 'London', 0.11, true);
call insert_salesman_sp('Mc Lyon', 'Paris', 0.14, true);
call insert_salesman_sp('Paul Adam', 'Rome', 0.13, true);

/*
3001 | rad Guzan | London | | 5005
3002 | Nick Rimando | New York | 100 | 5001
3003 | Jozy Altidor | Moscow | 200 | 5007
3004 | Fabian Johnson | Paris | 300 | 5006
3005 | Graham Zusi | California | 200 | 5002

3007 | Brad Davis | New York | 200 | 5001
3008 | Julian Green | London | 300 | 5002
3009 | Geoff Cameron | Berlin | 100 | 5003
*/
 
call insert_customer_sp('rad Guzan', 'London', NULL, 5005, true);
call insert_customer_sp('Nick Rimando', 'New York', 100, 5001, true);
call insert_customer_sp('Jozy Altidor', 'Moscow', 200, 5007, true);
call insert_customer_sp('Fabian Johnson', 'Paris', 300, 5006, true);
call insert_customer_sp('Graham Zusi', 'California', 200, 5002, true);
select nextval('customer_seq'); -- 3006 is skipped
call insert_customer_sp('Brad Davis', 'New York', 200, 5001, true);
call insert_customer_sp('Julian Green', 'London', 300, 5002, true);
call insert_customer_sp('Geoff Cameron', 'Berlin', 100, 5003, true);
 
/*
70001 150.5 2012-10-05 3005 5002
70002 65.26 2012-10-05 3002 5001
70003 2480.4 2012-10-10 3009 5003
70004 110.5 2012-08-17 3009 5003
70005 2400.6 2012-07-27 3007 5001

70007 948.5 2012-09-10 3005 5002
70008 5760 2012-09-10 3002 5001
70009 270.65 2012-09-10 3001 5005
70010 1983.43 2012-10-10 3004 5006
70011 75.29 2012-08-17 3003 5007
70012 250.45 2012-06-27 3008 5002
70013 3045.6 2012-04-25 3002 5001
*/

call insert_orders_sp(150.5, '2012-10-05', 3005, 5002, true);
call insert_orders_sp(65.26, '2012-10-05', 3002, 5001, true);
call insert_orders_sp(2480.4, '2012-10-10', 3009, 5003, true);
call insert_orders_sp(110.5, '2012-08-17', 3009, 5003, true);
call insert_orders_sp(2400.6, '2012-07-27', 3007, 5001, true);
select nextval('order_seq'); -- 70006 is skipped
call insert_orders_sp(948.5, '2012-09-10', 3005, 5002, true);
call insert_orders_sp(5760, '2012-09-10', 3002, 5001, true);
call insert_orders_sp(270.65, '2012-09-10', 3001, 5005, true);
call insert_orders_sp(1983.43, '2012-10-10', 3004, 5006, true);
call insert_orders_sp(75.29, '2012-08-17', 3003, 5007, true);
call insert_orders_sp(250.45, '2012-06-27', 3008, 5002, true);
call insert_orders_sp(3045.6, '2012-04-25', 3002, 5001, true);

--4. Write a query that will show the total numbers of customers per salesman in New York only?
select s.name, count(*) as num_customers
from salesman s 
join customer c on s.salesman_id = c.salesman_id
where s.city = 'New York'
group by s.name;
--5. Write a sql statement to get the minimum purchase amount of all the orders? Save your records on orderspurchase_view.
create or replace view orderspurchase_view as
select min(purch_amt) as min_purchase_amt
from orders;
select * from orderspurchase_view;
--6. Write a sql statement to find the highest purchase amount with their id and order date, for only those customers who have a higher purchase amount in a day is within the list 2000, 3000, 5760 and 6000?
select ord_no, purch_amt, ord_date
from orders
where purch_amt in (2000, 3000, 5760, 6000)
order by purch_amt desc
limit 1;
--7. Write a query to find those customers with their name and those salesmen with their name and city who live in the same city? Use natural join. Store your records in a view salesmensamecity_view.
create or replace view salesmensamecity_view as
select s.name as salesman_name, c.cust_name as customer_name, s.city
from salesman s natural join customer c
where s.city = c.city;
--8. Write a sql statement to find the names of all customers along with the salesmen who work for them? Use self-join.
select c.cust_name as customer_name, s.name as salesman_name
from customer c
join salesman s on c.salesman_id = s.salesman_id;
--9. Write a sql statement to prepare a list with salesman name, customer name and their cities for the salesmen and customer who belong to the same city? Use natural join.
select s.name as salesman_name, c.cust_name as customer_name, s.city
from salesman s natural join customer c
where s.city = c.city;
--10. Write a sql statement to make a list in ascending order for the customer who holds a grade less than 300 and works either through a salesman or by own? Use left join.
select c.cust_name, s.name as salesman_name, c.grade
from customer c
left join salesman s on c.salesman_id = s.salesman_id
where c.grade < 300
order by c.cust_name asc;
--11. Write a query to find all the orders issued against the salesman who may work for customer whose id is 3007? Use subquery.
select *
from orders
where salesman_id in (select salesman_id from customer where customer_id = 3007);
--12. Write a query to display all the orders which values are greater than the average order value for 10th October 2012? Use subquery.
select *
from orders
where purch_amt > (select avg(purch_amt) from orders where ord_date = '2012-10-10');
--13. Write a query to display all the customers whose id is below 2001 and the salesman id of Mc Lyon? Use subquery.
select cust_name
from customer
where customer_id < 2001 and salesman_id = (
	select salesman_id from salesman where name = 'Mc Lyon'
	);
--14. Create a backup for your bestbuy schemas and name the backup file bestbuy-backup.sql.
exit
pg_dump -U postgres -W -p 5432 bestbuy > bestbuy_backup.sql;
