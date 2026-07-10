USE AdventureWorks2025;
GO


-- Create Schema
CREATE SCHEMA de_project;


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