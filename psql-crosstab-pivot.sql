-- psql
create extension tablefunc;

drop table projects;
create table projects (projectid text, task text, "completion%" integer);

insert into projects values ('P1', 'Task1', 10);
insert into projects values ('P1', 'Task2', 20);
insert into projects values ('P1', 'Task3', 30);
insert into projects values ('P2', 'Task1', 40);
insert into projects values ('P2', 'Task2', 50);
insert into projects values ('P3', 'Task1', 60);
insert into projects values ('P3', 'Task3', 70);
insert into projects values ('P4', 'Task2', 80);
insert into projects values ('P4', 'Task3', 90);
insert into projects values ('P5', 'Task3', 100);

select * from projects;

select * from 
	crosstab(
		'select projectid, task, "completion%" from projects order by 1, 2',
		'select distinct task from projects order by 1'
	)
as ct(projectid text, task1 text, task2 text, task3 text)	
;
	
