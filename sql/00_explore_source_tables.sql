/*
STEP 00 - Explore source tables

Purpose:
Undertanding the AdventureWorks source tables before building staging, dimensions, and fact tables.
*/

-- =========================================================
-- 1. Confirm required source tables
-- =========================================================

USE AdventureWorks2025;
GO

Select 
	TABLE_SCHEMA,
	TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Sales'
	AND TABLE_NAME in (
	'SalesOrderHeader',
	'SalesOrderDetail',
	'Customer',
	'SalesTerritory'
)
ORDER BY TABLE_NAME;

-- =========================================================
-- 2. Preview sample rows
-- =========================================================

SELECT TOP 10 * FROM
Sales.SalesOrderHeader;

SELECT TOP 10 * FROM
Sales.SalesOrderDetail;

SELECT TOP 10 * FROM
Sales.Customer;

SELECT TOP 10 * FROM
Sales.SalesTerritory;

-- =========================================================
-- 3. Describe source tables
-- =========================================================

EXEC sp_help 'Sales.SalesOrderHeader';

EXEC sp_help 'Sales.SalesOrderDetail';

EXEC sp_help 'Sales.Customer';

EXEC sp_help 'Sales.SalesTerritory';

-- =========================================================
-- 4. Count rows in each source table
-- =========================================================

SELECT COUNT(*) as Row_count FROM
Sales.SalesOrderHeader;

SELECT COUNT(*) as Row_count FROM
Sales.SalesOrderDetail;

SELECT COUNT(*) as Row_count FROM
Sales.Customer;

SELECT COUNT(*) as Row_count FROM
Sales.SalesTerritory;

-- =========================================================
-- 5. Check primary/business keys
-- =========================================================

SELECT 
	COUNT(*) as total_rows,
	COUNT(ssoh.SalesOrderID) as non_null_sales_order_id,
	COUNT(DISTINCT ssoh.SalesOrderID) as distinct_sales_order_id,
	COUNT(*) - COUNT(DISTINCT ssoh.SalesOrderID) as duplicate_sales_order_id_count
FROM Sales.SalesOrderHeader as ssoh

SELECT 
	COUNT(*) as total_rows,
	COUNT(ssod.SalesOrderID) as non_null_sales_order_id,
	COUNT(DISTINCT ssod.SalesOrderID) as distinct_sales_order_id,
	COUNT(*) - COUNT(DISTINCT ssod.SalesOrderID) as duplicate_sales_order_id_count
FROM Sales.SalesOrderDetail as ssod

SELECT
	COUNT(*) as total_rows,
	COUNT(sc.CustomerID) as non_null_customer_id,
	COUNT(DISTINCT sc.CustomerID) as distinct_customer_id,
	COUNT(*) - COUNT(DISTINCT sc.CustomerID) as duplicate_sales_order_id_count
FROM sales.Customer as sc

SELECT
	COUNT(*) as total_rows,
	COUNT(sst.TerritoryID) as non_null_territory_id,
	COUNT(DISTINCT TerritoryID) as distinct_territory_id,
	COUNT(*) - COUNT(DISTINCT TerritoryID) as duplicate_territory_id
FROM Sales.SalesTerritory as sst

-- =========================================================
-- 5. Check key relationship
-- =========================================================
