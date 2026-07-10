/*
STEP 02 - Create Staging tables

Purpose:
Create Staging tables with its corresponding columns and datatypes
*/

USE AdventureWorks2025;
GO

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

-- stg_sales_order_detail
-- Create Table 
CREATE TABLE de_project.stg_sales_order_detail
(
	SalesOrderID INT NOT NULL,
	SalesOrderDetailID INT NOT NULL,
	OrderQty SMALLINT NOT NULL,
	ProductID INT NOT NULL,
	UnitPrice MONEY NOT NULL,
	UnitPriceDiscount MONEY NOT NULL,
	LineTotal NUMERIC NOT NULL
);
GO

-- stg_customer
-- Create Table
CREATE TABLE de_project.stg_customer
(
	CustomerID INT NOT NULL,
	PersonID INT NULL,
	StoreID INT NULL,
	TerritoryID INT NOT NULL,
	AccountNumber VARCHAR(10) NOT NULL
);
GO

-- stg_sales_territory
-- Create Table
CREATE TABLE de_project.stg_sales_territory
(
	TerritoryID INT NOT NULL,
	[Name] NAME NOT NULL,
	CountryRegionCode NVARCHAR(6) NOT NULL,
	[Group] NVARCHAR(100) NOT NULL
);
GO
