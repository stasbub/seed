select
	project,
	date_part(dayofweek, order_created_at) as num_day,
	to_char(order_created_at, 'Day') as name_day,
	count(order_id) as num
from analytics.stg_choco_orders
where order_created_at >= '2021-12-31 23:59:59'
group by 1, 2, 3
order by 1, 2