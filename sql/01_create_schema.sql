/*
STEP 01 - Create schema

Purpose:
Create and load the staging tables
*/

USE AdventureWorks2025;
GO


-- =========================================================
-- Create Schema
-- =========================================================
CREATE SCHEMA de_project;


-- =========================================================
-- Create staging tables
-- =========================================================

-- stg_sales_order_header
-- Create Table 
CREATE TABLE de_project.stg_sales_order_header
(
	SalesOrderID INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	CustomerID INT NOT NULL,
	TerritoryID INT NOT NULL,
	SubTotal MONEY NOT NULL,
	TaxAmt MONEY NOT NULL,
	Freight MONEY NOT NULL,
	TotalDue MONEY NOT NULL
);
GO

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

-- Validate tables
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
-- Create Table 
CREATE TABLE de_project.stg_sales_order_detail
(