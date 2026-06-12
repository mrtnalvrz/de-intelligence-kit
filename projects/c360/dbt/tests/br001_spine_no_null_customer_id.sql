-- BR001: Every row in CUSTOMER_360 must have a non-NULL CUSTOMER_ID.
-- A NULL key would indicate the LEFT JOIN spine is broken —
-- a CRM customer was matched without an identifier.
-- Fails for each row where CUSTOMER_ID is NULL.

select customer_id
from {{ source('analytics', 'customer_360') }}
where customer_id is null
