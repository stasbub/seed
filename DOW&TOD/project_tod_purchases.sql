select
	project,
	DATEPART(HOUR, order_created_at),
	count(order_id) as num
from analytics.stg_choco_orders
group by 1, 2
order by 1