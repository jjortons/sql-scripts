do $$
declare
	curs_movies cursor 
	for select * from movies
	order by random()
	;

	v_movie movies%rowtype;

	curs_actors cursor 
	for select a.* from actors a
		join movies_actors ma on (ma.actor_id = a.actor_id)
	where ma.movie_id = v_movie.movie_id;
 
	v_actor actors%rowtype;

begin
	open curs_movies;
	loop
		fetch next from curs_movies into v_movie;
		exit when not found;
		
		raise notice '%', v_movie.movie_name;

		open curs_actors;
		loop
			fetch next from curs_actors into v_actor;
			exit when not found;

			raise notice '- % %', v_actor.first_name, v_actor.last_name; 
		end loop;
		close curs_actors;

	end loop;
	close curs_movies;
end;
$$ language plpgsql;




drop table t_revenues;
create table t_revenues (movieid int, domestic_revenue numeric(10,2));

truncate table t_revenues;

do $$
declare
	curs_movies cursor for
	select * from movies;

	v_movie movies%rowtype;

	curs_revenues cursor (p_movie_id int) for
	select * from movies_revenues
	where movie_id = p_movie_id;

	v_revenues movies_revenues%rowtype;
	
	v_domestic_revenue numeric(10,2) := 0;

begin
	open curs_movies;
	loop
		fetch next from curs_movies into v_movie;
		exit when not found;
		
		raise notice '%', v_movie.movie_name;

		open curs_revenues(v_movie.movie_id);
		loop
			fetch next from curs_revenues into v_revenues;
			exit when not found;
			
			raise notice '- %', v_revenues.revenues_domestic + v_revenues.revenues_international;

			v_domestic_revenue := coalesce(v_revenues.revenues_domestic, 0);
			if  v_domestic_revenue <> 0 then
				insert into t_revenues (movieid, domestic_revenue) 
					values (v_movie.movie_id, v_domestic_revenue);
			end if;
		end loop;
		close curs_revenues;
		
	end loop;
	close curs_movies;
end;
$$ language plpgsql;

select * from t_revenues;