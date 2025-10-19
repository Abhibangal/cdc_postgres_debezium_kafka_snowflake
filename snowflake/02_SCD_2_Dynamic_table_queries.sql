create or replace dynamic table user_changes
target_lag = 'DOWNSTREAM'
refresh_mode = incremental
warehouse = compute_wh
as
select 
record_content:payload:after:user_id::int as user_id, 
record_content:payload:after:first_name::varchar as first_name,
record_content:payload:after:last_name::varchar as last_name,
record_content:payload:after:email::varchar as email,
record_content:payload:after:phone_number::varchar as phone_number,
record_content:payload:after:password_hash::varchar as password_has,
to_timestamp_ntz(record_content:payload:after:created_at::int/1000000) as created_at,
to_timestamp_ntz(record_content:payload:after:last_login::int/1000000) as last_login
from DWH_PROD.ECOMM_SCH.USER_LOGS;

 create or replace dynamic table dim_user
 target_lag = '15 minutes'
refresh_mode = incremental
warehouse = compute_wh
as
with rnk as (
select 
user_id, 
first_name,
last_name,
email,
phone_number,
password_has,
created_at,
last_login,
lead(last_login) over(partition by user_id order by last_login ) as lead_dt,
rank()  over(partition by user_id order by last_login ) as row_rank
from DWH_PROD.ECOMM_SCH.USER_CHANGES
)

select 
user_id, 
first_name,
last_name,
email,
phone_number,
password_has,
created_at,
case when row_rank =  1 then date(created_at) else date(last_login) end as start_dt ,
date(lead_dt)as end_dt
from rnk ;