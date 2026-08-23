-- ====================================================================
-- Project: DataCo Supply Chain & Risk Intelligence DWH
-- Script: 03_data_quality_reconciliation.sql
-- Description: Automated row count verification across Raw, Core (Star Schema),
--              and Analytics Marts to ensure zero data loss during ETL/ELT.
-- ====================================================================

SELECT 
    '1. Raw Layer: Staging DataCo' AS layer_name, 
    COUNT(*) AS total_rows 
FROM raw.staging_dataco

UNION ALL

SELECT 
    '2. Core Dimensions: Customers', 
    COUNT(*) 
FROM core.dim_customers

UNION ALL

SELECT 
    '2. Core Dimensions: Products', 
    COUNT(*) 
FROM core.dim_products

UNION ALL

SELECT 
    '2. Core Dimensions: Geography', 
    COUNT(*) 
FROM core.dim_geography

UNION ALL

SELECT 
    '2. Core Fact: Order Items', 
    COUNT(*) 
FROM core.fact_order_items

UNION ALL

SELECT 
    '3. Analytics Mart: Sales & Margin View', 
    COUNT(*) 
FROM analytics.v_sales_margin_analysis

UNION ALL

SELECT 
    '3. Analytics Mart: Supply Chain Logistics View', 
    COUNT(*) 
FROM analytics.v_supply_chain_logistics

UNION ALL

SELECT 
    '3. Analytics Mart: Risk & Fraud Monitoring View', 
    COUNT(*) 
FROM analytics.v_risk_fraud_monitoring;