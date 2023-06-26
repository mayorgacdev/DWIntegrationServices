
* Add other sequence container and in your sql task add this code
  Remenber some important the connection is from the DW and the origin data from the database 
  Don't forgot it

```
/* Merge FACT table: Destino */
MERGE INTO Destino
USING (/* Your query from another database */) AS Origen
ON Destino.DimCustomerID = Origen.DimCustomerID
   /* Check the constraints of your dimensions */

/* Update existing records */
WHEN MATCHED AND (
      Destino.Cantidad <> Origen.Cantidad OR
      /* Add conditions for your measures */
   )
THEN UPDATE SET
      Destino.Cantidad = Origen.Cantidad,
      /* Add any additional fields to update */

/* Insert new records */
WHEN NOT MATCHED THEN
   INSERT (/* Specify the properties needed in your fact table */)
   VALUES (/* Provide values for the origin, for example:
               Origen.DimFechaID, Origen.DimEmployeeID, Origen.DimCustomerID,
               Origen.DimShipperID, Origen.Cantidad, Origen.SinDescuento, Origen.Recaudacion */
   );
```
Ok you added the first container for prepare your fact table of your datawarehouse but you need to charge it 

* Add othet sql task in your new container sequence
* Select the datawarehouse connection

 In the sql command you need to allow the constraint so let's go

 
```
EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO
EXEC SP_MSFOREACHTABLE 'ALTER TABLE ? ENABLE TRIGGER ALL'
GO
```

and it's ok all end you need to hace four sequence container with four tables of sql task and other of your dimensions

