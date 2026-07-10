/*
STEP 03 - Loading data into staging tables

Purpose:
Loading the data from the source database into our staging tables.
*/

USE AdventureWorks2025;
GO

-- =========================================================
-- Load staging tables
-- =========================================================

-- stg_sales_order_header
-- Insert data into staging table
INSERT INTO de_project.stg_sales_order_header
(
	SalesOrderID,
	OrderDate,
	CustomerID,
	TerritoryID,
	SubTotal,
	TaxAmt,
	Freight,
	TotalDue
)
SELECT
	SalesOrderID,
	OrderDate,
	CustomerID,
	TerritoryID,
	SubTotal,
	TaxAmt,
	Freight,
	TotalDue
FROM Sales.SalesOrderHeader;
GO

-- stg_sales_order_detail
-- Insert data into staging table
INSERT INTO de_project.stg_sales_order_detail
(
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	ProductID,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal
)
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	ProductID,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal
FROM Sales.SalesOrderDetail;
GO

-- stg_customer
-- Insert data into staging table
INSERT INTO de_project.stg_customer
(
	CustomerID,
	PersonID,
	StoreID,
	TerritoryID,
	AccountNumber
)
SELECT
	CustomerID,
	PersonID,
	StoreID,
	TerritoryID,
	AccountNumber
FROM Sales.Customer;
GO

-- stg_sales_territory
-- Insert data into staging table
INSERT INTO de_project.stg_sales_territory
(
	TerritoryID,
	[Name],
	CountryRegionCode,
	[Group]
)
SELECT 
	TerritoryID,
	[Name],
	CountryRegionCode,
	[Group]
FROM Sales.SalesTerritory;
GO