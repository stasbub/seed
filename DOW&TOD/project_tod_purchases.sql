with transcard_orders as (

	select terminal_project,
		DATEPART(HOUR, order_created_at) as date_par,
		count(order_id) as num
	from analytics.stg_loyalty_orders
	where terminal_project = 'loyalty'
		and (lower(terminal_name) LIKE '%transcard%' or lower(terminal_name) like '%lrt%')
		and order_created_at >= '2021-12-31 23:59:59'
	group by 1, 2
	order by 1, 2

),

all_orders as (

	select
		COALESCE(terminal_project, project) as project,
		DATEPART(HOUR, order_created_at) as date_par,
		count(order_id) as num
	from analytics.stg_choco_orders
	where order_created_at >= '2021-12-31 23:59:59'
		and (terminal_project in ('digital_rest', 'lensmark', 'loyalty', 'ryadom')
			or terminal_project is null)
	group by 1, 2
	order by 1, 2

),

plus_utc as (

	select
		ao.project,
		case
			when project in ('aviata_air', 'chocotravel_air', 'chocofood', 'railway') then ao.date_par + 6
			else ao.date_par
		end,
		case
			when tor.num is not null then (ao.num - tor.num)
			else ao.num
		end as num 
	from
		all_orders ao
	left join transcard_orders tor
		on ao.project = tor.terminal_project
			and ao.date_par = tor.date_par
	order by 1, 2

)

select
	project,
	case
		when date_par = 24 then 0
		when date_par = 25 then 1
		when date_par = 26 then 2
		when date_par = 27 then 3
		when date_par = 28 then 4
		when date_par = 29 then 5
		else date_par
	end as date_par,
	num
from plus_utc
	
