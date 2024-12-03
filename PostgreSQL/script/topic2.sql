/*
--data maniputaltion language DML
insert, delete, update
*/

--SINGLE INSERTION
insert into manager values (101, 'Juan', 'M', 80, 60000.00, '1999-10-10');

--MULTIPLE INSERTION
insert into manager values (102, 'Mark', 'M', 32, 60000.00, '1929-10-10'),
						   (103, 'Pilar', 'F', 70, 60000.00, '2019-10-10'),
						   (104, 'Honggoy', 'M', 120, 60000.00, '1999-10-10');

--IN ANY ORDER INSERTION 
insert into manager(birthday, firstname, age, id, salary, gender)
values('1929-10-10', 'Lorna', 220, 105, 99000.00, '');

--try double pKey
--insert into insurance values(1,3);

--try pkey x unique
insert into allowance values(1,1);
insert into allowance values(2,2);

--UPDATE RECORDS
update manager set gender = 'F' where id ='105';
update manager set firstname = 'Caloy' where id = '101';

--UPSERT 
insert into manager values (101, 'Juan', 'M', 80, 60000.00, '1999-10-10') on conflict(id) do nothing;
insert into manager values (101, 'Juan', 'M', 80, 60000.00, '1999-10-10') on conflict(id) do update set age = 60, salary = 10000;

--DELETE
delete from manager where id=101;

/*
-- TRANSACATION MANAGEMENT (commit and rollback)

begin transaction; 
--ayan papasok ka na sa bubble magkakasterisk yung config 
delete from manager;
--call rollback kapag nagkamali ka kaso maaalis ka na sa bubble
rollback;
*/
/*
--terminal rollback
hrms=# begin transaction;
--BEGIN
hrms=*# update manager set age = 88 where id = 102;
--UPDATE 1
hrms=*# savepoint marker2;
--SAVEPOINT
hrms=*# insert into insurance values(15,15);
--INSERT 0 1
hrms=*# savepoint marker3;
--SAVEPOINT
hrms=*# delete from manager;
--DELETE 4
hrms=*# rollback to marker2;
--ROLLBACK
hrms=*# commit;
--COMMIT
*/
