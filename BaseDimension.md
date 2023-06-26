Steps for build dimensions with Integration services

First Create the dim table
* Remenber to add the unique DimId for the table
* Create the project (Integration services project) -n DWVeldaxETL
* Open your tools you are going to see SSIS toolbox
* At the right part of your editor you'll see the connections
  (Select the OLEDB connection type)
  (Connect two databases the datawarehouse and your origin database)
IMPORTANT: SELECT THE SEQUENCE CONTAINER

* select the sequence container for charge your dimensions
 (Change the name = Start proccess)
* Select SQL task and put in the sequence container
* In the configuration tool of your task put the DWVeldax connection
  (Select the sql statement) and put
  
  ```
  EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
  GO
  EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? NOCHECK TRIGGER ALL'
  GO
  ```
  (OK)
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
* In your derivative column click over EndDate and update 
as ```(DT_DBDATE)GetDate()```
* Double click in your OLE DB Command
and update the section of SqlCommand go to definition
* Update with

```
UDPATE 
  [SCHEME].[YOURDIM] 
SET [STARTDATE]=?WHERE [BUSINESSKEY]=?
AND [ENDDATE]='9999-12-31'
```
* Go to derivative column 
and update again the StarDate as GetDate() and the EndDate as
'9999-12-31'
* Double clik in Insert Destination an set the EndDate as 
the property you configured it

