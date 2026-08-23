-- ====================================================================
-- Project: DataCo Supply Chain & Risk Intelligence DWH
-- Script: 02_analytics_views.sql
-- Description: Analytical Views (Data Marts) for Power BI Consumption.
-- ====================================================================

-- 1. Sales & Margin Mart
CREATE OR REPLACE VIEW analytics.v_sales_margin_analysis AS
SELECT 
    f.order_item_id,
    f.order_id,
    f.order_date,
    c.customer_id,
    c.customer_fname || ' ' || c.customer_lname AS customer_name,
    c.customer_segment,
    p.product_name,
    p.category_name,
    p.department_name,
    g.market,
    g.order_region,
    f.sales,
    f.order_item_profit,
    f.order_item_discount_rate,
    CASE WHEN f.order_item_profit < 0 THEN 1 ELSE 0 END AS is_unprofitable_order
FROM core.fact_order_items f
JOIN core.dim_customers c ON f.customer_id = c.customer_id
JOIN core.dim_products p ON f.product_card_id = p.product_card_id
JOIN core.dim_geography g ON f.geography_id = g.geography_id;

-- 2. Supply Chain & Logistics Mart
CREATE OR REPLACE VIEW analytics.v_supply_chain_logistics AS
SELECT 
    f.order_item_id,
    f.order_id,
    f.order_date,
    s.shipping_mode,
    s.delivery_status,
    g.order_region,
    g.market,
    p.category_name,
    c.customer_segment,
    f.days_for_shipping_real,
    f.days_for_shipment_scheduled,
    f.late_delivery_risk,
    (f.days_for_shipping_real - f.days_for_shipment_scheduled) AS delivery_delay_days,
    f.sales
FROM core.fact_order_items f
JOIN core.dim_shipping s ON f.shipping_id = s.shipping_id
JOIN core.dim_geography g ON f.geography_id = g.geography_id
JOIN core.dim_products p ON f.product_card_id = p.product_card_id
JOIN core.dim_customers c ON f.customer_id = c.customer_id;

-- 3. Risk & Fraud Monitoring Mart
CREATE OR REPLACE VIEW analytics.v_risk_fraud_monitoring AS
SELECT 
    f.order_item_id,
    f.order_id,
    f.order_date,
    s.shipping_mode,
    s.order_status,
    g.order_country,
    g.order_region,
    g.market,
    c.customer_segment,
    f.sales AS fraud_loss_amount,
    1 AS fraud_incident_count
FROM core.fact_order_items f
JOIN core.dim_shipping s ON f.shipping_id = s.shipping_id
JOIN core.dim_geography g ON f.geography_id = g.geography_id
JOIN core.dim_customers c ON f.customer_id = c.customer_id
WHERE s.order_status = 'SUSPECTED_FRAUD';