-- ============================================================
-- MODERN PROMETHEUS — CUSTOMER 360 DEMO
-- FILE: 00_seed_data_duckdb.sql
-- TARGET: DuckDB (local)
-- ============================================================
-- DuckDB notes:
--   • No CREATE DATABASE — the .db file IS the database
--   • No CREATE WAREHOUSE — no compute layer needed
--   • TIMESTAMP instead of TIMESTAMP_NTZ
--   • Everything else is standard ANSI SQL
-- ============================================================

CREATE SCHEMA IF NOT EXISTS RAW_DATA;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

-- ── SOURCE TABLES ─────────────────────────────────────────────

CREATE OR REPLACE TABLE RAW_DATA.CRM_CUSTOMERS (
    CUSTOMER_ID         VARCHAR(10)     NOT NULL,
    FIRST_NAME          VARCHAR(50),
    LAST_NAME           VARCHAR(50),
    EMAIL               VARCHAR(100),
    PHONE               VARCHAR(30),
    COMPANY             VARCHAR(100),
    INDUSTRY            VARCHAR(50),
    CITY                VARCHAR(50),
    STATE               VARCHAR(10),
    COUNTRY             VARCHAR(10),
    SIGNUP_DATE         DATE,
    ACCOUNT_STATUS      VARCHAR(20),
    ANNUAL_REVENUE_USD  DECIMAL(15,2),
    SALES_REP           VARCHAR(50)
);

CREATE OR REPLACE TABLE RAW_DATA.ERP_ORDERS (
    ORDER_ID            VARCHAR(15)     NOT NULL,
    CUST_ID             VARCHAR(10),
    ORDER_DATE          DATE,
    PRODUCT_CODE        VARCHAR(20),
    PRODUCT_NAME        VARCHAR(100),
    CATEGORY            VARCHAR(50),
    QUANTITY            INTEGER,
    UNIT_PRICE_USD      DECIMAL(12,2),
    DISCOUNT_PCT        DECIMAL(5,2),
    TOTAL_AMOUNT_USD    DECIMAL(15,2),
    ORDER_STATUS        VARCHAR(20),
    REGION              VARCHAR(30),
    WAREHOUSE_CODE      VARCHAR(10)
);

CREATE OR REPLACE TABLE RAW_DATA.SUPPORT_TICKETS (
    TICKET_ID               VARCHAR(15)     NOT NULL,
    CUSTOMER_REF            VARCHAR(10),
    CREATED_AT              TIMESTAMP,
    RESOLVED_AT             TIMESTAMP,
    PRIORITY                VARCHAR(20),
    CATEGORY                VARCHAR(30),
    SUBJECT                 VARCHAR(200),
    STATUS                  VARCHAR(20),
    SATISFACTION_SCORE      DECIMAL(3,0),
    AGENT_NAME              VARCHAR(50),
    RESOLUTION_TIME_HRS     DECIMAL(10,2)
);

-- ── SEED DATA ─────────────────────────────────────────────────

INSERT INTO RAW_DATA.CRM_CUSTOMERS
    (CUSTOMER_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,COMPANY,INDUSTRY,CITY,STATE,COUNTRY,SIGNUP_DATE,ACCOUNT_STATUS,ANNUAL_REVENUE_USD,SALES_REP)
VALUES
('C001','James','Whitfield','j.whitfield@acmecorp.com','+1-312-555-0101','Acme Corp','Manufacturing','Chicago','IL','US','2021-03-15','active',4200000,'Sarah Lin'),
('C002','Maria','Santos','m.santos@globalretail.com','+1-305-555-0202','Global Retail Inc','Retail','Miami','FL','US','2020-11-02','active',8750000,'Tom Reed'),
('C003','David','Kim','d.kim@techdyne.io','+1-415-555-0303','TechDyne','Technology','San Francisco','CA','US','2022-01-20','active',1500000,'Sarah Lin'),
('C004','Patricia','Okafor','p.okafor@finservcorp.com','+1-212-555-0404','FinServ Corp','Financial Services','New York','NY','US','2019-06-10','active',22000000,'Marcus Webb'),
('C005','Robert','Chen','r.chen@healthsys.org','+1-617-555-0505','HealthSys','Healthcare','Boston','MA','US','2021-08-30','active',9100000,'Tom Reed'),
('C006','Angela','Torres','a.torres@mediaplex.com','+1-310-555-0606','MediaPlex','Media','Los Angeles','CA','US','2022-05-14','active',3300000,'Sarah Lin'),
('C007','William','Patel','w.patel@logistixco.com','+1-469-555-0707','Logistix Co','Logistics','Dallas','TX','US','2020-04-22','churned',1800000,'Marcus Webb'),
('C008','Lisa','Nakamura','l.nakamura@cloudbase.io','+1-206-555-0808','CloudBase','Technology','Seattle','WA','US','2023-02-01','active',2700000,'Sarah Lin'),
('C009','Carlos','Mendez','c.mendez@agroprime.com','+55-11-555-0909','AgroPrime','Agriculture','Sao Paulo','SP','BR','2021-10-15','active',5600000,'Diego Rios'),
('C010','Jennifer','Walsh','j.walsh@insurenet.com','+1-312-555-1010','InsureNet','Insurance','Chicago','IL','US','2020-07-18','active',14500000,'Marcus Webb'),
('C011','Kevin','Osei','k.osei@retailplus.com','+1-404-555-1111','RetailPlus','Retail','Atlanta','GA','US','2022-09-05','active',3900000,'Tom Reed'),
('C012','Sandra','Kowalski','s.kowalski@manufact.com','+1-312-555-1212','ManufaCT','Manufacturing','Chicago','IL','US','2019-12-01','at_risk',7200000,'Marcus Webb'),
('C013','Michael','Okonkwo','m.okonkwo@bankwest.com','+1-713-555-1313','BankWest','Financial Services','Houston','TX','US','2020-02-14','active',31000000,'Marcus Webb'),
('C014','Rachel','Goldberg','r.goldberg@pharmaco.com','+1-215-555-1414','PharmaCo','Healthcare','Philadelphia','PA','US','2021-05-22','active',18000000,'Tom Reed'),
('C015','Thomas','Andrade','t.andrade@energycorp.com','+55-21-555-1515','EnergyCorp','Energy','Rio de Janeiro','RJ','BR','2022-11-30','active',9800000,'Diego Rios');

INSERT INTO RAW_DATA.ERP_ORDERS
    (ORDER_ID,CUST_ID,ORDER_DATE,PRODUCT_CODE,PRODUCT_NAME,CATEGORY,QUANTITY,UNIT_PRICE_USD,DISCOUNT_PCT,TOTAL_AMOUNT_USD,ORDER_STATUS,REGION,WAREHOUSE_CODE)
VALUES
('ORD-10001','C001','2023-01-10','PRD-A100','Data Pipeline Pro','Software',3,12000.0,0.1,32400.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10002','C002','2023-01-15','PRD-B200','Analytics Suite','Software',5,8500.0,0.15,36125.0,'delivered','SOUTH','WH-MIA'),
('ORD-10003','C004','2023-01-22','PRD-C300','Enterprise AI Platform','Software',10,25000.0,0.2,200000.0,'delivered','NORTHEAST','WH-NYC'),
('ORD-10004','C003','2023-02-05','PRD-A100','Data Pipeline Pro','Software',2,12000.0,0.0,24000.0,'delivered','WEST','WH-SFO'),
('ORD-10005','C005','2023-02-14','PRD-D400','HIPAA Compliance Module','Software',4,15000.0,0.1,54000.0,'delivered','NORTHEAST','WH-BOS'),
('ORD-10006','C001','2023-02-20','PRD-E500','Data Governance Pack','Software',1,9000.0,0.05,8550.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10007','C010','2023-03-01','PRD-C300','Enterprise AI Platform','Software',8,25000.0,0.2,160000.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10008','C013','2023-03-10','PRD-C300','Enterprise AI Platform','Software',15,25000.0,0.25,281250.0,'delivered','SOUTH','WH-HOU'),
('ORD-10009','C006','2023-03-18','PRD-B200','Analytics Suite','Software',3,8500.0,0.0,25500.0,'delivered','WEST','WH-LAX'),
('ORD-10010','C008','2023-04-02','PRD-A100','Data Pipeline Pro','Software',4,12000.0,0.1,43200.0,'delivered','WEST','WH-SEA'),
('ORD-10011','C002','2023-04-10','PRD-F600','Real-Time Streaming Add-on','Software',5,6000.0,0.1,27000.0,'delivered','SOUTH','WH-MIA'),
('ORD-10012','C014','2023-04-20','PRD-D400','HIPAA Compliance Module','Software',6,15000.0,0.15,76500.0,'delivered','NORTHEAST','WH-PHI'),
('ORD-10013','C004','2023-05-05','PRD-F600','Real-Time Streaming Add-on','Software',10,6000.0,0.2,48000.0,'delivered','NORTHEAST','WH-NYC'),
('ORD-10014','C011','2023-05-15','PRD-B200','Analytics Suite','Software',2,8500.0,0.05,16150.0,'delivered','SOUTH','WH-ATL'),
('ORD-10015','C009','2023-05-25','PRD-A100','Data Pipeline Pro','Software',3,12000.0,0.0,36000.0,'delivered','LATAM','WH-SAO'),
('ORD-10016','C013','2023-06-01','PRD-E500','Data Governance Pack','Software',12,9000.0,0.2,86400.0,'delivered','SOUTH','WH-HOU'),
('ORD-10017','C005','2023-06-12','PRD-C300','Enterprise AI Platform','Software',5,25000.0,0.15,106250.0,'delivered','NORTHEAST','WH-BOS'),
('ORD-10018','C003','2023-06-25','PRD-F600','Real-Time Streaming Add-on','Software',2,6000.0,0.0,12000.0,'delivered','WEST','WH-SFO'),
('ORD-10019','C015','2023-07-05','PRD-C300','Enterprise AI Platform','Software',6,25000.0,0.1,135000.0,'delivered','LATAM','WH-RIO'),
('ORD-10020','C010','2023-07-14','PRD-E500','Data Governance Pack','Software',3,9000.0,0.1,24300.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10021','C001','2023-08-01','PRD-C300','Enterprise AI Platform','Software',2,25000.0,0.1,45000.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10022','C012','2023-08-10','PRD-A100','Data Pipeline Pro','Software',2,12000.0,0.05,22800.0,'delivered','NORTH_CENTRAL','WH-CHI'),
('ORD-10023','C007','2023-08-20','PRD-B200','Analytics Suite','Software',1,8500.0,0.0,8500.0,'cancelled','SOUTH','WH-DAL'),
('ORD-10024','C014','2023-09-02','PRD-C300','Enterprise AI Platform','Software',4,25000.0,0.2,80000.0,'delivered','NORTHEAST','WH-PHI'),
('ORD-10025','C004','2023-09-15','PRD-E500','Data Governance Pack','Software',8,9000.0,0.15,61200.0,'delivered','NORTHEAST','WH-NYC'),
('ORD-10026','C008','2023-10-01','PRD-B200','Analytics Suite','Software',3,8500.0,0.05,24225.0,'delivered','WEST','WH-SEA'),
('ORD-10027','C002','2023-10-12','PRD-C300','Enterprise AI Platform','Software',4,25000.0,0.2,80000.0,'delivered','SOUTH','WH-MIA'),
('ORD-10028','C013','2023-11-01','PRD-F600','Real-Time Streaming Add-on','Software',20,6000.0,0.25,90000.0,'delivered','SOUTH','WH-HOU'),
('ORD-10029','C009','2023-11-15','PRD-B200','Analytics Suite','Software',4,8500.0,0.1,30600.0,'delivered','LATAM','WH-SAO'),
('ORD-10030','C010','2023-12-01','PRD-C300','Enterprise AI Platform','Software',6,25000.0,0.2,120000.0,'delivered','NORTH_CENTRAL','WH-CHI');

INSERT INTO RAW_DATA.SUPPORT_TICKETS
    (TICKET_ID,CUSTOMER_REF,CREATED_AT,RESOLVED_AT,PRIORITY,CATEGORY,SUBJECT,STATUS,SATISFACTION_SCORE,AGENT_NAME,RESOLUTION_TIME_HRS)
VALUES
('TKT-5001','C001','2023-01-25 09:15:00',  '2023-01-25 14:30:00','high','integration','Pipeline connection timeout on AWS Glue','resolved',5,'Ana Perez',5.25),
('TKT-5002','C004','2023-02-01 11:00:00',  '2023-02-03 16:00:00','critical','billing','Invoice discrepancy on Enterprise AI Platform','resolved',3,'James Fort',53.0),
('TKT-5003','C002','2023-02-08 14:20:00',  '2023-02-09 10:00:00','medium','feature','Request: scheduled report export to S3','resolved',4,'Ana Perez',19.67),
('TKT-5004','C005','2023-02-20 08:00:00',  '2023-02-20 12:00:00','high','compliance','HIPAA audit log format question','resolved',5,'Maria Souza',4.0),
('TKT-5005','C003','2023-03-05 16:30:00',  '2023-03-07 09:00:00','medium','performance','Dashboard slow on large dataset queries','resolved',4,'James Fort',40.5),
('TKT-5006','C010','2023-03-12 10:45:00',  '2023-03-12 15:00:00','high','integration','Snowflake connector authentication error','resolved',5,'Ana Perez',4.25),
('TKT-5007','C013','2023-03-20 09:00:00',  NULL,'critical','security','Suspected unauthorized API access','open',NULL,'Maria Souza',NULL),
('TKT-5008','C001','2023-04-01 14:00:00',  '2023-04-02 11:30:00','medium','feature','Custom dashboard widget request','resolved',5,'James Fort',21.5),
('TKT-5009','C006','2023-04-10 11:15:00',  '2023-04-11 09:00:00','low','general','User onboarding assistance','resolved',5,'Ana Perez',21.75),
('TKT-5010','C014','2023-04-18 08:30:00',  '2023-04-19 17:00:00','high','compliance','PHI data masking configuration','resolved',4,'Maria Souza',32.5),
('TKT-5011','C008','2023-05-02 13:00:00',  '2023-05-02 17:00:00','medium','performance','API rate limiting affecting ingestion','resolved',4,'James Fort',4.0),
('TKT-5012','C004','2023-05-10 09:00:00',  '2023-05-15 18:00:00','critical','integration','Oracle CDC connector data loss incident','resolved',2,'Ana Perez',129.0),
('TKT-5013','C002','2023-05-22 15:30:00',  '2023-05-23 12:00:00','medium','feature','Multi-tenant dashboard access controls','resolved',5,'Maria Souza',20.5),
('TKT-5014','C011','2023-06-05 10:00:00',  '2023-06-05 14:30:00','low','general','Password reset and MFA setup','resolved',5,'James Fort',4.5),
('TKT-5015','C005','2023-06-14 08:00:00',  '2023-06-16 17:00:00','high','compliance','Audit trail gaps in HIPAA report','resolved',3,'Ana Perez',57.0),
('TKT-5016','C013','2023-06-20 11:00:00',  '2023-06-21 09:00:00','high','performance','Query timeout on large FSI dataset join','resolved',4,'Maria Souza',22.0),
('TKT-5017','C009','2023-07-03 14:00:00',  '2023-07-04 11:00:00','medium','integration','Databricks connection from Brazil region','resolved',4,'James Fort',21.0),
('TKT-5018','C015','2023-07-10 09:30:00',  '2023-07-12 18:00:00','high','integration','Private cloud deployment assistance','resolved',5,'Ana Perez',56.5),
('TKT-5019','C003','2023-08-05 10:00:00',  '2023-08-05 16:00:00','medium','general','New user seat provisioning','resolved',5,'Maria Souza',6.0),
('TKT-5020','C010','2023-08-15 13:00:00',  NULL,'high','billing','Renewal pricing negotiation','open',NULL,'James Fort',NULL),
('TKT-5021','C012','2023-09-01 09:00:00',  '2023-09-03 17:00:00','critical','performance','Data pipeline failure - production down','resolved',2,'Ana Perez',56.0),
('TKT-5022','C004','2023-09-20 14:00:00',  '2023-09-21 12:00:00','high','integration','SQL Server on-prem connector setup','resolved',4,'Maria Souza',22.0),
('TKT-5023','C008','2023-10-05 11:00:00',  '2023-10-06 10:00:00','medium','feature','Slack alerting integration request','resolved',5,'James Fort',23.0),
('TKT-5024','C002','2023-10-18 09:00:00',  '2023-10-18 13:00:00','high','performance','Real-time streaming lag spike','resolved',4,'Ana Perez',4.0),
('TKT-5025','C013','2023-11-05 10:00:00',  '2023-11-07 18:00:00','critical','security','PII data exposure in test environment','resolved',3,'Maria Souza',56.0);

-- ── VERIFY ────────────────────────────────────────────────────
SELECT 'CRM_CUSTOMERS'   AS source_table, COUNT(*) AS rows_loaded FROM RAW_DATA.CRM_CUSTOMERS
UNION ALL
SELECT 'ERP_ORDERS',      COUNT(*) FROM RAW_DATA.ERP_ORDERS
UNION ALL
SELECT 'SUPPORT_TICKETS', COUNT(*) FROM RAW_DATA.SUPPORT_TICKETS;
-- Expected: 15 / 30 / 25

SELECT 'Seed complete. Ready for Modern Prometheus mission.' AS status;
