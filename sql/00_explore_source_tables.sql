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
FROM Sales.SalesOrderHeader as ssoh;

SELECT 
	COUNT(*) as total_rows,
	COUNT(ssod.SalesOrderDetailID) as non_null_sales_order_detail_id,
	COUNT(DISTINCT ssod.SalesOrderDetailID) as distinct_sales_order_detail_id,
	COUNT(*) - COUNT(DISTINCT ssod.SalesOrderDetailID) as duplicate_sales_order_detail_id_count
FROM Sales.SalesOrderDetail as ssod;

SELECT
	COUNT(*) as total_rows,
	COUNT(sc.CustomerID) as non_null_customer_id,
	COUNT(DISTINCT sc.CustomerID) as distinct_customer_id,
	COUNT(*) - COUNT(DISTINCT sc.CustomerID) as duplicate_customer_id
FROM sales.Customer as sc;

SELECT
	COUNT(*) as total_rows,
	COUNT(sst.TerritoryID) as non_null_territory_id,
	COUNT(DISTINCT sst.TerritoryID) as distinct_territory_id,
	COUNT(*) - COUNT(DISTINCT sst.TerritoryID) as duplicate_territory_id
FROM Sales.SalesTerritory as sst;

-- =========================================================
-- 6. Check key relationships
-- =========================================================

-- Check: SalesOrderHeader.CustomerID -> Customer.CustomerID
-- Purpose: Confirm every sales order has a valid customer.
SELECT 
    COUNT(*) AS missing_customer_count
FROM Sales.SalesOrderHeader AS soh
LEFT JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- Check: SalesOrderHeader.TerritoryID -> SalesTerritory.TerritoryID
-- Purpose: Confirm every sales order has a valid sales territory.
SELECT 
    COUNT(*) AS missing_territory_count
FROM Sales.SalesOrderHeader AS soh
LEFT JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE st.TerritoryID IS NULL;


-- Check: SalesOrderDetail.SalesOrderID -> SalesOrderHeader.SalesOrderID
-- Purpose: Confirm every sales order line has a valid order header.
SELECT 
    COUNT(*) AS missing_sales_order_header_count
FROM Sales.SalesOrderDetail AS sod
LEFT JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.SalesOrderID IS NULL;

-- =========================================================
-- 7. Check nulls in required staging columns
-- =========================================================

-- Check: Null values in SalesOrderHeader
SELECT 
	COUNT(*) as total_rows,
	SUM(CASE WHEN ssoh.SalesOrderID IS NULL THEN 1 ELSE 0 END) AS sales_order_id_nulls,
	SUM(CASE WHEN ssoh.OrderDate IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
	SUM(CASE WHEN ssoh.CustomerID IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
	SUM(CASE WHEN ssoh.TerritoryID IS NULL THEN 1 ELSE 0 END) AS territory_id_nulls,
	SUM(CASE WHEN ssoh.SubTotal IS NULL THEN 1 ELSE 0 END) AS subtotal_nulls,
	SUM(CASE WHEN ssoh.TaxAmt IS NULL THEN 1 ELSE 0 END) AS tax_amt_nulls,
	SUM(CASE WHEN ssoh.Freight IS NULL THEN 1 ELSE 0 END) AS freight_nulls,
	SUM(CASE WHEN ssoh.TotalDue IS NULL THEN 1 ELSE 0 END) AS total_due_nulls
FROM Sales.SalesOrderHeader as ssoh;

-- Check: Null values in SalesOrderDetail
SELECT
	COUNT(*) as total_rows,
	SUM(CASE WHEN ssod.SalesOrderID IS NULL THEN 1 ELSE 0 END) AS sales_order_id_nulls,
	SUM(CASE WHEN ssod.SalesOrderDetailID IS NULL THEN 1 ELSE 0 END) AS sales_order_detail_id_nulls,
	SUM(CASE WHEN ssod.OrderQty IS NULL THEN 1 ELSE 0 END) AS order_qty_nulls,
	SUM(CASE WHEN ssod.ProductID IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
	SUM(CASE WHEN ssod.UnitPrice IS NULL THEN 1 ELSE 0 END) AS unit_price_nulls,
	SUM(CASE WHEN ssod.UnitPriceDiscount IS NULL THEN 1 ELSE 0 END) AS unit_price_discount_nulls,
	SUM(CASE WHEN ssod.LineTotal IS NULL THEN 1 ELSE 0 END) AS line_total_nulls
FROM Sales.SalesOrderDetail as ssod;

-- Check: Null Values in Customer
SELECT
	COUNT(*) as total_rows,
	SUM(CASE WHEN sc.CustomerID IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
	SUM(CASE WHEN sc.PersonID IS NULL THEN 1 ELSE 0 END) AS person_nulls,
	SUM(CASE WHEN sc.StoreID IS NULL THEN 1 ELSE 0 END) AS store_nulls,
	SUM(CASE WHEN sc.TerritoryID IS NULL THEN 1 ELSE 0 END) AS territory_id_nulls,
	SUM(CASE WHEN sc.AccountNumber IS NULL THEN 1 ELSE 0 END) AS account_number_nulls
	--SUM(CASE WHEN sc.customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_nulls
FROM Sales.Customer as sc;

-- Check: Null values in Sales Territory
SELECT
	COUNT(*) as total_rows,
	SUM(CASE WHEN sst.TerritoryID IS NULL THEN 1 ELSE 0 END) AS territory_id_nulls,
	SUM(CASE WHEN sst.[Name] IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN sst.CountryRegionCode IS NULL THEN 1 ELSE 0 END) AS country_region_code_nulls,
	SUM(CASE WHEN sst.[Group] IS NULL THEN 1 ELSE 0 END) AS group_nulls
FROM Sales.SalesTerritory AS sst;

-- =========================================================
-- 9. Review order date range
-- =========================================================

SELECT
	MAX(OrderDate) AS max_order_date,
	MIN(OrderDate) AS min_order_date,
	COUNT(DISTINCT OrderDate) AS distinct_order_date
FROM Sales.SalesOrderHeader

-- =========================================================
-- 10. Sales numeric fields
-- =========================================================

-- Check: Order Quantity

SELECT
	COUNT(*) AS total_rows,
	MAX(OrderQty) AS max_ordered_qty,
	MIN(OrderQty) AS min_ordered_qty,
	AVG(OrderQty) AS avg_ordered_qty,
	SUM(CASE WHEN OrderQty < 0 THEN 1 ELSE 0 END) AS negative_order_qty
FROM Sales.SalesOrderDetail;

-- Check: Unit Price

SELECT
	COUNT(*) AS total_rows,
	MAX(UnitPrice) AS max_unit_price,
	MIN(UnitPrice) AS min_unit_price,
	AVG(UnitPrice) AS avg_unit_price,
	SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS negative_unit_price
FROM Sales.SalesOrderDetail;

-- Check: Unit Price Discount

SELECT
	COUNT(*) AS total_rows,
	MAX(UnitPriceDiscount) AS max_unit_price_discount,
	MIN(UnitPriceDiscount) AS min_unit_price_discount,
	AVG(UnitPriceDiscount) AS avg__unit_price_discount,
	SUM(CASE WHEN UnitPriceDiscount < 0 THEN 1 ELSE 0 END) AS negative_unit_price_discount
FROM Sales.SalesOrderDetail

-- Check: Line Total

SELECT
	COUNT(*) AS total_rows,
	MAX(LineTotal) AS max_line_total,
	MIN(LineTotal) AS min_line_total,
	AVG(LineTotal) AS avg_line_total,
	SUM(CASE WHEN LineTotal < 0 THEN 1 ELSE 0 END) AS negative_line_total
FROM Sales.SalesOrderDetail;

-- =========================================================
-- 11. Review customer type logic
-- =========================================================

SELECT
	COUNT(*) AS total_rows,
	SUM(CASE WHEN PersonID IS NOT NULL AND StoreID IS NULL THEN 1 ELSE 0 END) AS individual_customer,
	SUM(CASE WHEN PersonID IS NULL AND StoreID IS NOT NULL THEN 1 ELSE 0 END) AS store_customer,
	SUM(CASE WHEN PersonID IS NULL AND StoreID IS NULL THEN 1 ELSE 0 END) AS unkown_customer,
	SUM(CASE WHEN PersonID IS NOT NULL AND StoreID IS NOT NULL THEN 1 ELSE 0 END) AS both_person_and_store_customer
FROM Sales.Customer;

-- =========================================================
-- 12. Review territory values
-- =========================================================

SELECT
	CountryRegionCode,
	COUNT(*) AS country_region_code_counts
FROM Sales.SalesTerritory
GROUP BY CountryRegionCode;

SELECT
	[Group],
	COUNT(*) AS group_counts
FROM Sales.SalesTerritory
GROUP BY [Group];

SELECT
    TerritoryID,
    Name AS TerritoryName,
    CountryRegionCode,
    [Group] AS TerritoryGroup
FROM Sales.SalesTerritory
ORDER BY [Group], CountryRegionCode, Name;