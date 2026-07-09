# Project Notes

## Source Exploration Notes

### Source tables reviewed

The project source exploration focused on the four required AdventureWorks sales/customer tables:

- `Sales.SalesOrderHeader`
- `Sales.SalesOrderDetail`
- `Sales.Customer`
- `Sales.SalesTerritory`

These tables support the project scope defined in the guide: sales orders, sales order lines, customers, territories, and date-based reporting.

### Source table purpose

- `Sales.SalesOrderHeader` provides order-level context, including `SalesOrderID`, `OrderDate`, `CustomerID`, `TerritoryID`, `SubTotal`, `TaxAmt`, `Freight`, and `TotalDue`.
- `Sales.SalesOrderDetail` provides line-level sales activity, including `SalesOrderDetailID`, `SalesOrderID`, `OrderQty`, `ProductID`, `UnitPrice`, `UnitPriceDiscount`, and `LineTotal`.
- `Sales.Customer` provides customer identifiers and fields used to derive customer type, including `CustomerID`, `PersonID`, `StoreID`, `TerritoryID`, and `AccountNumber`.
- `Sales.SalesTerritory` provides geographic context for reporting, including `TerritoryID`, `Name`, `CountryRegionCode`, and `Group`.

### Source row counts

Captured source row counts before building staging tables:

| Source table | Row count |
|---|---:|
| `Sales.SalesOrderHeader` | 31,465 |
| `Sales.SalesOrderDetail` | 121,317 |
| `Sales.Customer` | 19,820 |
| `Sales.SalesTerritory` | 10 |

These counts will be used later to validate that the staging tables loaded the expected number of rows.

### Primary and business key observations

Primary/business key checks confirmed that the expected identifier columns are populated and unique where required:

| Source table | Key column | Total rows | Distinct key count | Duplicate count |
|---|---|---:|---:|---:|
| `Sales.SalesOrderHeader` | `SalesOrderID` | 31,465 | 31,465 | 0 |
| `Sales.SalesOrderDetail` | `SalesOrderDetailID` | 121,317 | 121,317 | 0 |
| `Sales.Customer` | `CustomerID` | 19,820 | 19,820 | 0 |
| `Sales.SalesTerritory` | `TerritoryID` | 10 | 10 | 0 |

`SalesOrderDetailID` uniquely identifies each sales order line. `SalesOrderID` is expected to repeat in `Sales.SalesOrderDetail` because one sales order can contain multiple line items.

### Key relationship observations

Validated the required source relationships using orphan checks:

- `Sales.SalesOrderHeader.CustomerID` connects to `Sales.Customer.CustomerID`
- `Sales.SalesOrderHeader.TerritoryID` connects to `Sales.SalesTerritory.TerritoryID`
- `Sales.SalesOrderDetail.SalesOrderID` connects to `Sales.SalesOrderHeader.SalesOrderID`

No orphan records were found in the required source relationships:

| Relationship check | Missing records |
|---|---:|
| Sales order headers without matching customer | 0 |
| Sales order headers without matching territory | 0 |
| Sales order details without matching order header | 0 |

This confirms that the source tables can be safely joined to build the sales order line fact table with customer, territory, and date context.

### Null value observations

Null checks were performed on the required staging columns.

No nulls were found in the required `SalesOrderHeader` fields:

- `SalesOrderID`
- `OrderDate`
- `CustomerID`
- `TerritoryID`
- `SubTotal`
- `TaxAmt`
- `Freight`
- `TotalDue`

No nulls were found in the required `SalesOrderDetail` fields:

- `SalesOrderID`
- `SalesOrderDetailID`
- `OrderQty`
- `ProductID`
- `UnitPrice`
- `UnitPriceDiscount`
- `LineTotal`

No nulls were found in the critical `Sales.Customer` fields:

- `CustomerID`
- `TerritoryID`
- `AccountNumber`

The `Sales.Customer` table contains nulls in `PersonID` and `StoreID`, which is expected because those fields are used to derive customer type:

| Field | Null count |
|---|---:|
| `PersonID` | 701 |
| `StoreID` | 18,484 |

No nulls were found in the required `SalesTerritory` fields:

- `TerritoryID`
- `Name`
- `CountryRegionCode`
- `Group`

### Date range observations

The sales order date range was reviewed to support creation of `dim_date`.

| Metric | Value |
|---|---|
| Minimum `OrderDate` | 2022-05-30 |
| Maximum `OrderDate` | 2025-06-29 |
| Distinct order dates | 1,124 |

The date dimension should be built from distinct `OrderDate` values in staged sales order headers.

### Sales numeric field observations

Sales numeric fields were reviewed because they will be used later to calculate fact table measures.

| Field | Minimum | Maximum | Average | Negative count |
|---|---:|---:|---:|---:|
| `OrderQty` | 1 | 44 | 2 | 0 |
| `UnitPrice` | 1.3282 | 3578.27 | 465.0934 | 0 |
| `UnitPriceDiscount` | 0.00 | 0.40 | 0.0028 | 0 |
| `LineTotal` | 1.3740 | 27893.6190 | 905.4492 | 0 |

No negative values were found in the reviewed sales fields. Discounts range from 0.00 to 0.40, which appears reasonable for the later discount calculation.

These fields will support the fact table calculations:

- `gross_sales_amount`
- `discount_amount`
- `net_sales_amount`
- `source_line_total`

### Customer type observations

Reviewed `PersonID` and `StoreID` in `Sales.Customer` to validate how `CustomerType` can be derived for `dim_customer`.

| Customer classification pattern | Count |
|---|---:|
| `PersonID IS NOT NULL AND StoreID IS NULL` | 18,484 |
| `PersonID IS NULL AND StoreID IS NOT NULL` | 701 |
| `PersonID IS NULL AND StoreID IS NULL` | 0 |
| `PersonID IS NOT NULL AND StoreID IS NOT NULL` | 635 |

The presence of 635 customers with both `PersonID` and `StoreID` populated means the customer type logic needs to be explicitly defined when loading `dim_customer`.

Planned customer type logic needs to account for:

- Individual customers
- Store customers
- Customers with both person and store references
- Unknown customers, if both values are null

### Territory value observations

Reviewed territory values to support `dim_sales_territory` and territory-level reporting.

Country/region distribution:

| CountryRegionCode | Territory count |
|---|---:|
| AU | 1 |
| CA | 1 |
| DE | 1 |
| FR | 1 |
| GB | 1 |
| US | 5 |

Territory group distribution:

| Territory group | Territory count |
|---|---:|
| Europe | 3 |
| North America | 6 |
| Pacific | 1 |

The territory dimension will provide geographic reporting context using territory name, country/region code, and territory group.