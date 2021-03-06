--JSON:
select * from books

update books set bookinfo = bookinfo || '{"author":"Author_1"}'
where bookId = 1

select bookid,bookinfo, bookinfo->>'author' as author from books

insert into books(bookinfo) values('{"title":"Book 4","author":"Author1"}')
insert into books(bookinfo) values('{"title":"Book 3"}')
select '{
"title":"iron man"


}':: jsonb


select '{"title":"iron man"}':: TEXT


--JOINS:
select m.movie_name, m.movie_length, a.first_name, a.last_name, a.actor_id,m.movie_id
from movies m 
inner join
actors a
on m.movie_id = a.actor_id

select m.movie_name, m.movie_length, a.first_name, a.last_name, a.actor_id,m.movie_id
from movies m 
left join
actors a
on m.movie_id = a.actor_id

select m.movie_name, m.movie_length, a.first_name, a.last_name, a.actor_id,m.movie_id
from movies m 
right join
actors a
on m.movie_id = a.actor_id

select m.movie_name, m.movie_length, a.first_name, a.last_name, a.actor_id,m.movie_id
from movies m 
full join
actors a
on m.movie_id = a.actor_id



--TRIGGERS:
create table player(
	player_id serial primary key,
	name varchar(100)
);

create table players_audits(
	player_audit_id serial primary key,
	player_id int not null,
	name varchar(100),
	edit_date timestamp not null
);


insert into player(name) values ('virat kohli')
insert into player(name) values ('mahendra dhoni')
insert into player(name) values ('sachin tandulkar')

select * from player
select * from players_audits

drop function fn_player_name_changes_log

create or replace function fn_player_name_changes_log()
returns trigger
language PLPGSQL
as $$
begin
if new.name <> old.name then
insert into players_audits(player_id,name,edit_date) values (old.player_id,old.name,now());
end if;
return new;
end;
$$

create trigger trigger_players_name_changes
before update
on player
for each row
execute procedure fn_player_name_changes_log();

insert into player(name) values ('yuvraj singh')
update player set name = 'sourav ganguly' where player_id = 1

update player set name = 'mahendra singh dhoni' where player_id = 2




--SELF BUILT TRIGGER:
create table player1(
	player_id serial primary key,
	name varchar(100),
	trophy int
);

create table players_audit_2(
player_audit_id serial primary key,
	player_id int not null,
	name varchar(100),
	edit_time timestamp not null
);


insert into player1(name,trophy) values ('virat kohli',2);
insert into player1(name,trophy) values ('mahendra dhoni',5);
insert into player1(name,trophy) values ('sachin tandulkar',7);

select * from player1;
select * from players_audit_2;

drop function fn_player_trophy_insert_log
create or replace function fn_player_trophy_insert_log()
returns trigger
language PLPGSQL
as $$
begin
if new.trophy <> old.trophy then
insert into player_audits_2(player_id,name,trophy,edit_time) values (new.player_id,new.name,old.trophy,now());
end if;
return new;
end;
$$

create trigger trigger_for_trophy
after insert
on player1
for each row 
execute procedure fn_player_trophy_insert_log();


update player1 set trophy = 9 where player_id = 2
