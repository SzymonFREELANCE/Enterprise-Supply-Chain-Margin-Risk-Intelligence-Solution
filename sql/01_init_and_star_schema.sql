-- ====================================================================
-- Project: DataCo Supply Chain & Risk Intelligence DWH
-- Script: 01_init_and_star_schema.sql
-- Description: DWH Initialization, Schema Setup, Staging, and Star Schema Model.
-- ====================================================================

-- 1. Create Architecture Schemas
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS analytics;

-- 2. Dimension: Customers
CREATE TABLE IF NOT EXISTS core.dim_customers (
    customer_id INT PRIMARY KEY,
    customer_fname VARCHAR(100),
    customer_lname VARCHAR(100),
    customer_segment VARCHAR(50),
    customer_city VARCHAR(100),
    customer_state VARCHAR(50),
    customer_country VARCHAR(100),
    customer_zipcode VARCHAR(20)
);

-- 3. Dimension: Products
CREATE TABLE IF NOT EXISTS core.dim_products (
    product_card_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category_id INT,
    category_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100),
    product_price NUMERIC(10, 2)
);

-- 4. Dimension: Geography (Markets & Regions)
CREATE TABLE IF NOT EXISTS core.dim_geography (
    geography_id SERIAL PRIMARY KEY,
    order_city VARCHAR(100),
    order_state VARCHAR(100),
    order_country VARCHAR(100),
    order_region VARCHAR(100),
    market VARCHAR(100),
    CONSTRAINT uq_geography UNIQUE (order_city, order_state, order_country, order_region, market)
);

-- 5. Dimension: Shipping & Order Status
CREATE TABLE IF NOT EXISTS core.dim_shipping (
    shipping_id SERIAL PRIMARY KEY,
    shipping_mode VARCHAR(50),
    delivery_status VARCHAR(50),
    order_status VARCHAR(50),
    CONSTRAINT uq_shipping UNIQUE (shipping_mode, delivery_status, order_status)
);

-- 6. Fact: Order Items
CREATE TABLE IF NOT EXISTS core.fact_order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    order_date TIMESTAMP,
    shipping_date TIMESTAMP,
    customer_id INT REFERENCES core.dim_customers(customer_id),
    product_card_id INT REFERENCES core.dim_products(product_card_id),
    geography_id INT REFERENCES core.dim_geography(geography_id),
    shipping_id INT REFERENCES core.dim_shipping(shipping_id),
    sales NUMERIC(12, 2),
    order_item_profit NUMERIC(12, 2),
    order_item_discount NUMERIC(12, 2),
    order_item_discount_rate NUMERIC(5, 4),
    order_item_quantity INT,
    product_price NUMERIC(10, 2),
    days_for_shipping_real INT,
    days_for_shipment_scheduled INT,
    late_delivery_risk INT
);