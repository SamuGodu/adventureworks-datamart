/*
STEP 04 - Validate data

Purpose:
Review the data previously loaded into the staging tables to confirm they contain the same information as the source tables
*/

USE AdventureWorks2025;
GO

-- =========================================================
-- Validate staging tables
-- =========================================================

-- stg_sales_order_header
-- Row Count
SELECT COUNT(*) AS row_count_stg
FROM de_project.stg_sales_order_header;

SELECT COUNT(*) AS row_count_src
FROM Sales.SalesOrderHeader;

-- Check Nulls
SELECT 
	COUNT(*) as total_rows,
	SUM(CASE WHEN SalesOrderID IS NULL THEN 1 ELSE 0 END) AS sales_order_id_nulls,
	SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
	SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
	SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS territory_id_nulls,
	SUM(CASE WHEN SubTotal IS NULL THEN 1 ELSE 0 END) AS subtotal_nulls,
	SUM(CASE WHEN TaxAmt IS NULL THEN 1 ELSE 0 END) AS tax_amt_nulls,
	SUM(CASE WHEN Freight IS NULL THEN 1 ELSE 0 END) AS freight_nulls,
	SUM(CASE WHEN TotalDue IS NULL THEN 1 ELSE 0 END) AS total_due_nulls
FROM de_project.stg_sales_order_header;

-- stg_sales_order_detail
-- Row Count
SELECT COUNT(*) AS row_count_stg
FROM de_project.stg_sales_order_detail;

SELECT COUNT(*) AS row_count_src
FROM Sales.SalesOrderDetail;

-- Check Nulls
SELECT
	COUNT(*) as total_rows,
	SUM(CASE WHEN SalesOrderID IS NULL THEN 1 ELSE 0 END) AS sales_order_id_nulls,
	SUM(CASE WHEN SalesOrderDetailID IS NULL THEN 1 ELSE 0 END) AS sales_order_detail_id_nulls,
	SUM(CASE WHEN OrderQty IS NULL THEN 1 ELSE 0 END) AS order_qty_nulls,
	SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
	SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS unit_price_nulls,
	SUM(CASE WHEN UnitPriceDiscount IS NULL THEN 1 ELSE 0 END) AS unit_price_discount_nulls,
	SUM(CASE WHEN LineTotal IS NULL THEN 1 ELSE 0 END) AS line_total_nulls
FROM de_project.stg_sales_order_detail;

-- stg_customer
-- Row Count
SELECT COUNT(*) AS row_count_stg
FROM de_project.stg_customer;

SELECT COUNT(*) AS row_count_src
FROM Sales.Customer;

-- Check Nulls
SELECT
	COUNT(*) as total_rows,
	SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
	SUM(CASE WHEN PersonID IS NULL THEN 1 ELSE 0 END) AS person_nulls,
	SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS store_nulls,
	SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS territory_id_nulls,
	SUM(CASE WHEN AccountNumber IS NULL THEN 1 ELSE 0 END) AS account_number_nulls
	--SUM(CASE WHEN customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_nulls
FROM de_project.stg_customer;

-- stg_sales_territory
-- Row Count
SELECT COUNT(*) AS row_count_stg
FROM de_project.stg_sales_territory;

SELECT COUNT(*) AS row_count_src
FROM Sales.SalesTerritory;

-- Check Nulls
SELECT
	COUNT(*) as total_rows,
	COUNT(TerritoryID) as non_null_territory_id,
	COUNT(DISTINCT TerritoryID) as distinct_territory_id,
	COUNT(*) - COUNT(DISTINCT TerritoryID) as duplicate_territory_id
FROM de_project.stg_sales_territory;