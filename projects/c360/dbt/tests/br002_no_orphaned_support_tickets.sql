-- BR002: Every support ticket must reference a customer that exists in CRM.
-- Join key: SUPPORT.CUSTOMER_REF = CRM.CUSTOMER_ID (names differ, values identical).
-- Orphaned tickets would cause at-risk signals to be silently discarded —
-- a customer could have an open critical ticket that never surfaces.
-- Fails for each distinct CUSTOMER_REF in support with no matching CRM customer.

select distinct t.customer_ref
from {{ source('raw_data', 'support_tickets') }} t
left join {{ source('raw_data', 'crm_customers') }} c
    on t.customer_ref = c.customer_id
where c.customer_id is null
