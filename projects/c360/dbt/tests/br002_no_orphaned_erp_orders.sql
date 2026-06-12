-- BR002: Every ERP order must reference a customer that exists in CRM.
-- Join key: ERP.CUST_ID = CRM.CUSTOMER_ID (names differ, values identical).
-- Orphaned orders indicate upstream data quality issues that would cause
-- silent revenue undercount in CUSTOMER_360.
-- Fails for each distinct CUST_ID in ERP with no matching CRM customer.

select distinct e.cust_id
from {{ source('raw_data', 'erp_orders') }} e
left join {{ source('raw_data', 'crm_customers') }} c
    on e.cust_id = c.customer_id
where c.customer_id is null
