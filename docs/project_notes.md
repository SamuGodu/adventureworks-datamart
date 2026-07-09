### Source Relationship Inference

The sales order line fact table is based on Sales.SalesOrderDetail because the required grain is one row per sales order line.

Sales.SalesOrderDetail contains SalesOrderID, which connects each line item to Sales.SalesOrderHeader. The header table provides OrderDate, CustomerID, and TerritoryID, which are required to connect the fact table to the date, customer, and territory dimensions.

The required source relationships are:
- SalesOrderDetail.SalesOrderID → SalesOrderHeader.SalesOrderID
- SalesOrderHeader.CustomerID → Customer.CustomerID
- SalesOrderHeader.TerritoryID → SalesTerritory.TerritoryID