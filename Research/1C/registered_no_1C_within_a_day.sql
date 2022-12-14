with auth_completed as (
	select
		account_created_at,
		user_id
	from analytics."stg_chocoaccount_users"
), dif_table as (
select
	ac.user_id,
	ac.account_created_at,
	sco.order_id,
	sco.order_created_at,
	DATEDIFF(day, account_created_at, order_created_at) as dif_col
from auth_completed ac
left join analytics.stg_choco_orders sco
	on ac.user_id = sco.order_id
)
select
	to_char(account_created_at, 'yyyy-mm') as month_time,
	count(distinct user_id) as num_users
from dif_table
where (dif_col >= 1 or dif_col is null)
group by 1
having num_users != 1