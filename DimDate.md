* Create the table of your DimDate
* Add the sequence container
* Add two Task into the sequence container
* Double click in ETL DimDate
* Select the connection for your DWVeldax
* Go to the sql statement
```
EXEC SP_MSFOREACHTABLE 
'BEGIN  TRY 
TRUNCATE TABLE dbo.DimDate
 END TRY 
BEGIN CATCH 
  DELETE FROM DimDate
 END CATCH
'
GO
```
* In the dimensions container charge connect the dim with the other
* Double click in your Dimdate CHARGE DIMENSIONS
* Select the origin OLEDB of sources
* Select the OLEDB and connect with your origin database
* Put your query in sql command and ok select distinct orderdate as idfech...
* And now something most interesting the destiny of your query
* Select the OLE DB destiny
* Select your datawarehouse
* select the table in this case the dim date


and all it's ok


