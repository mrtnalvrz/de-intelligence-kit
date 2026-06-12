-- BR002: Every CRM customer must appear exactly once in CUSTOMER_360.
-- The LEFT JOIN spine guarantees no CRM row is lost regardless of
-- whether that customer has orders or tickets.
-- Fails for each CUSTOMER_ID present in CRM but absent from the view.

select c.customer_id
from {{ source('raw_data', 'crm_customers') }} c
left join {{ source('analytics', 'customer_360') }} v
    on c.customer_id = v.customer_id
where v.customer_id is null
