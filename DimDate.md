* Create the table of your DimDate
* Add the sequence container
* Add a Task into the sequence container
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

**And now add other sequence container for charge de dimension Date**
Due to the dimension doesn't need the historical change so you can use a ```ORIGIN OLDB Source``` and a 
Other ```Destination Source``` : )

and all it's ok


