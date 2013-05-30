update jobs
set locked_at = NOW()
where id = (
	select id from jobs  
	where locked_at is null 
	order by id limit 1 
	for update 
)
returning *;
