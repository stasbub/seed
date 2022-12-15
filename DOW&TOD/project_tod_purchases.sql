select
	COALESCE(terminal_project, project) as project,
	DATEPART(HOUR, order_created_at),
	count(order_id) as num
from analytics.stg_choco_orders
where order_created_at >= '2021-12-31 23:59:59'
	and (terminal_project in ('digital_rest', 'lensmark', 'loyalty', 'ryadom')
		or terminal_project is null)
group by 1, 2
order by 1, 2