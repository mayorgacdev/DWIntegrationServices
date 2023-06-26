Steps for build dimensions with Integration services

**Sometime some interesting that i don't take in count is that is really important the constraint**



First Create the dim table

I need to preapare de Datawarehouse and put in nocheck the tables could be a good option 
for the massive data

So Add a Sql Task in your first container and put the next for your DataWarehouse
in the `SQL COMMAND`
  
  ```
EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? DISABLE TRIGGER ALL'
GO
  ```

* We already up the Datawarehouse and now We are going to create
Dimensions Charge with other container sequence
 (Connect the container sequences)

* Add other container sequence
* Put an flow data task inside the container
  (Rename the flow with the name of your dimension)
* double click in your dimension flow task. Will Appear a new menu
* Select the OLEDB Origin from "Other Servers"
  and select the db origin in this case Veldax
  
  **In the mapping section we can rename the columns**
* OK and close
* Select the Slowly varietion (Dimensión de variación lenta) from common
 (Double click)
* Select the Datawarehouse and your dim table next and
select the Business Key as well Continue and 
select the historical columns and 
(VARIABLE TO SET DATA VALUES = System::StartTime) 
UNCHECK => the enabled inferred member support
next and FINISH
* In your variability dimension go to the properties
and update you 'CurrentRowWhere' and put 

```
[STARTDATE] IS NOT NULL 
AND [ENDATE]='9999-12-31'
```
* In your derived column click over EndDate and update 
as ```(DT_DBDATE)GetDate()```
* Double click in your OLE DB Command
and update the section of SqlCommand go to definition
* Update with  `JUST UPDATE THE DATE` haha *='9999-12-31'*

```
UDPATE 
  [SCHEME].[YOURDIM] 
SET [STARTDATE]=?WHERE [BUSINESSKEY]=?
AND [ENDDATE]='9999-12-31'
```
* Go to derivative column 
and update again the StarDate as ```(DT_DBDATE)GetDate()``` and the EndDate as
```(DT_DBDATE)"9999-12-31"```

* Double clik in Insert Destination an set the EndDate as 
the property you configured it

