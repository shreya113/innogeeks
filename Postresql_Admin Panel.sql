--Tables Creation
create table staff(
	emp_id Serial primary key,
	emp_name varchar(100),
	emp_role varchar(100)
)

create table role_audit(
	role_audit_id serial primary key,
	emp_id int not null,
	emp_role varchar(100),
	edit_date timestamp not null
);

create table product(
	prod_id serial primary key,
	prod_name varchar(100),
	quantity int,
	quality_chk boolean
)

create table orders(
	ord_id serial primary key,
	ord_date date,
	cus_name varchar(100)
)
create table order_audit(
	ord_audit_id serial primary key,
	ord_date date,
	edit_ord_date timestamp not null
)

--Data Insertion
insert into staff(emp_name,emp_role) values ('Raman', 'Sales Engineer');
insert into staff(emp_name,emp_role) values ('Soniya','Product Manager');
insert into staff(emp_name,emp_role) values ('Lalit','Quality Analyst');
insert into staff(emp_name,emp_role) values ('Raj','Salesperson');
insert into staff(emp_name,emp_role) values ('Simran','Salesperson');

insert into product(prod_name,quantity,quality_chk) values('Tablet',45,true);
insert into product(prod_name,quantity,quality_chk) values('Monitor',78,false)
insert into product(prod_name,quantity,quality_chk) values('Mouse',67,true);
insert into product(prod_name,quantity,quality_chk) values('Keyboard',35,true);
insert into product(prod_name,quantity,quality_chk) values('Earphone',23,false);

insert into orders(ord_date,cus_name) values('2021-09-08','Ramesh');
insert into orders(ord_date,cus_name) values('2022-11-17','Anjali');

--Table Viewing
select * from staff
select * from role_audit
select * from product
select * from orders
select * from order_audit

--Function to monitor role update
create or replace function fn_role_change()
returns trigger
language plpgsql
as $$
begin
if new.emp_role <> old.emp_role then
insert into role_audit(emp_id,emp_role,edit_date) values (old.emp_id,old.emp_role,now());
end if;
return new;
end;
$$

--Trigger to monitor role update
create trigger trigger_role_update
before update
on staff
for each row 
execute procedure fn_role_change(); 

update staff set emp_role = 'Sales Leader' where emp_id = 2;


--Function to check order
create or replace function fn_order_chk()
returns trigger
language plpgsql
as $$
begin
if new.ord_date <> old.ord_date then
insert into order_audit(ord_date,edit_ord_date) values (old.ord_date,now());
update product set quantity = quantity - 1 where prod_id = new.ord_id;
end if;
return new;
end;
$$

--Trigger to check order
create trigger trigger_odr_chk
before update
on orders
for each row 
execute procedure fn_order_chk(); 


update orders set ord_date = '2022-11-20' where ord_id = 2;


--View for Final Bill
create view final_reciept as
select p.prod_name, p.quantity, p.quality_chk, o.ord_date, o.cus_name
from product p
inner join orders o
on p.prod_id = o.ord_id;

select prod_name, quantity, quality_chk, ord_date, cus_name
from final_reciept
