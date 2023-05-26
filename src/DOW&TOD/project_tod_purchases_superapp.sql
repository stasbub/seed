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
		terminal_project as project,
		DATEPART(HOUR, order_created_at) as date_par,
		count(order_id) as num
	from analytics.stg_choco_orders
	where order_created_at >= '2021-12-31 23:59:59'
		and project = 'loyalty'
	group by 1, 2
	order by 1, 2

)

select
	ao.project,
	ao.date_par,
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
