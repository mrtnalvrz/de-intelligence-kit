-- BR001: CUSTOMER_360 must contain exactly 15 rows — one per CRM customer.
-- The CRM_CUSTOMERS table has 15 rows and is the LEFT JOIN spine.
-- Any deviation means a customer was lost or duplicated in the join.
-- Fails (returns 1 row) when actual count != 15.

select
    'row count mismatch'      as failure_reason,
    count(*)                  as actual_count,
    15                        as expected_count
from {{ source('analytics', 'customer_360') }}
having count(*) != 15
