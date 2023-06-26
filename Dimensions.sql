
USE [Veldax]
GO

/****** Object:  View [dbo].[DimCompany]    Script Date: 6/25/2023 6:05:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimCompany */
ALTER VIEW [dbo].[DimCompany] AS
SELECT CC.CompanyId,
       IU.Id,
       CS.SubscriptionPlanId,
       CS.SubscriptionName,
       CS.SubscriptionDescription,
       CC.CompanyName,
       CC.ShortName,
       CC.Address,
       CC.Email,
       CC.PhoneNumber,
       CC.Description,
       CC.RegistrationDate
FROM Core.Company AS CC
         INNER JOIN [Identity].[Users] AS IU
                    ON CC.ApplicationUserId = IU.Id
         INNER JOIN Core.SubscriptionPlan AS CS
                    ON CS.CompanyId = CC.CompanyId
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimCreditCard]    Script Date: 6/25/2023 6:06:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimCreditCard */
ALTER VIEW [dbo].[DimCreditCard] AS 
SELECT SC.CreditCardId,
       IUS.ID,
       SCC.CardType,
       SCC.CardNumber,
       SCC.ExpMonth,
       SCC.ExpYear,
       SCC.ModifiedAt
FROM Sales.CustomerCreditCard AS SC
         INNER JOIN [Identity].[Users] AS IUS
                    ON SC.ApplicationUserId = IUS.Id
         INNER JOIN Sales.CreditCard AS SCC
                    ON SC.CreditCardId = SCC.CreditCardId
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimCustomer]    Script Date: 6/25/2023 6:06:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimCustomer */
ALTER VIEW [dbo].[DimCustomer] AS
SELECT IUS.Id,
       IUS.DisplayName,
       IUS.UserName,
       IUS.Email,
       IUS.PhoneNumber,
       IUSA.City,
       IUSA.FieldOne,
       IUSA.FieldTwo,
       IUSA.Street,
       IUSA.State,
       IUSA.ZipCode
FROM [Identity].[Users] AS IUS
         INNER JOIN [Identity].[UserAddress] AS IUSA
                    ON IUS.Id = IUSA.ApplicationUserId
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimDate]    Script Date: 6/25/2023 6:06:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimDate */
ALTER VIEW [dbo].[DimDate] AS
SELECT 
	   D.OrderDate						AS [Date key],
	   DATEPART(WEEKDAY, d.OrderDate)   AS [Day number of week],
       DATENAME(WEEKDAY, d.OrderDate)   AS [Day name],
       DATEPART(DAY, d.OrderDate)       AS [Day number of month],
       DATEPART(DAYOFYEAR, d.OrderDate) AS [Day number of year],
       DATEPART(WEEK, d.OrderDate)         [Week number of year],
       DATENAME(MONTH, d.OrderDate)     AS [Month name],
       DATEPART(MONTH, d.OrderDate)     AS [Month number of year],
       DATEPART(QUARTER, d.OrderDate)   AS [Calendar quarter],
       DATEPART(YEAR, d.OrderDate)      AS [Calendar year],
       CASE
           WHEN DATEPART(MONTH, d.OrderDate) <= 6 THEN 1
           ELSE 2
           END AS [Calendar semester]

FROM (SELECT DISTINCT SO.OrderDate
      FROM Sales.[Order] AS SO
      UNION
      SELECT DISTINCT SP.EntryDate
      FROM Sales.Product AS SP
      UNION
      SELECT DISTINCT SM.DeliveryStart
      FROM Sales.DeliveryMethod AS SM
      UNION
      SELECT DISTINCT SM.DeliveryEnd
      FROM Sales.DeliveryMethod AS SM
      UNION
      SELECT DISTINCT CC.RegistrationDate
      FROM Core.Company AS CC) AS D 
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimDeliveryMethod]    Script Date: 6/25/2023 6:07:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[DimDeliveryMethod] AS
SELECT DM.DeliveryMethodId,
       DM.OrderId,
       DC.DeliveryCompanyName,
       DC.DeliveryCompanyDescription,
	   DM.Description,
       DM.Price,
       DM.DeliveryStart,
       DM.DeliveryEnd
FROM Core.DeliveryCompany AS DC
         INNER JOIN Sales.DeliveryMethod AS DM
                    ON DC.DeliveryCompanyId = DM.DeliveryCompanyId
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimProduct]    Script Date: 6/25/2023 6:07:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimProduct */
ALTER VIEW [dbo].[DimProduct] AS
SELECT ProductId,
       ProductSubCategoryId,
       Name,
       Description,
       UnitPrice,
       TotalPrice,
       IsActive,
       Ranking
FROM Sales.Product
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimSubCategory]    Script Date: 6/25/2023 6:07:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimSubCategory */
ALTER VIEW [dbo].[DimSubCategory] AS
SELECT PS.ProductSubCategoryId, PS.Name AS [Sub category], PCT.CategoryName FROM Core.ProductSubCategory AS PS 
INNER JOIN CORE.ProductCategory AS PCT
ON PS.ProductCategoryId = PCT.ProductCategoryId
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[DimSupplier]    Script Date: 6/25/2023 6:07:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* DimSupplier */
ALTER VIEW [dbo].[DimSupplier] AS
SELECT * FROM Core.Supplier
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[FactInventory]    Script Date: 6/25/2023 6:07:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[FactInventory] AS
SELECT [P].[ProductId]                                                                AS [Product key],
       [P].[SupplierId]                                                               AS [Supplier key],
       [P].[CompanyId]                                                                AS [Company key],
       [P].[EntryDate]                                                                AS [Entry date of products],
       [O].[Order date]                                                               AS [Last order date],
       [P].[UnitsInStock]                                                             AS [Units in stock],
       [P].[UnitsInOrder]                                                             AS [Units in order],
       SUM([P].[ProfitPorcentage])                                                    AS [Total profit porcentage],
       SUM([P].[Tax])                                                                 AS [Total tax],
       [P].[UnitPrice]                                                                AS [Unit price],
       [P].[TotalPrice]                                                               AS [Price for customers],
       SUM([P].[UnitPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder]))               AS [Investment without taxes],
       [P].[UnitsInOrder] + [P].[UnitsInStock]                                        AS [Total units],
       SUM([P].[UnitPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder])
           + [P].[UnitPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder]) * [P].[Tax]) AS [Investment plus taxes],
       SUM([P].[TotalPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder]))              AS [Expected Money],
       SUM([P].[TotalPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder]) -
           ([P].[UnitPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder])
               + [P].[UnitPrice] * ([P].[UnitsInStock] + [P].[UnitsInOrder]) *
                 [P].[Tax]))                                                          AS [Revenue],
       [P].[UnitsInOrder] * [P].[TotalPrice]                                          AS [Sales],
       [P].[UnitsInStock] * [P].[TotalPrice]                                          AS [Expected money in inventory]
FROM [Sales].[Product] AS [P]
         LEFT JOIN (SELECT [SI].[ProductId], MAX([SO].[OrderDate]) AS [Order date]
                    FROM [Sales].[Order] AS [SO]
                             INNER JOIN [Sales].[OrderItem] AS [SI] ON [SI].[OrderId] = [SO].[OrderId]
                    GROUP BY [SI].[ProductId]) AS [O] ON [P].[ProductId] = [O].[ProductId]
GROUP BY [P].[ProductId], [P].[UnitsInStock], [P].[UnitsInOrder], [P].[SupplierId], [P].[CompanyId], [P].[EntryDate],
         [O].[Order date], [P].[TotalPrice], [P].[UnitPrice]
GO


USE [Veldax]
GO

/****** Object:  View [dbo].[FactSales]    Script Date: 6/25/2023 6:08:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[FactSales] AS
SELECT [O].[OrderId]                                  AS [Order key],
       [O].[OrderDate]                                AS [Order date key],
       [O].ApplicationUserId                          AS [Customer key],
       [O].[Status],
       [SD].[DeliveryMethodId]                        AS [Delivery method key],
       [O].[CreditCardId]                             AS [Credit card key],
       ROUND((SUM([OI].[SubTotal]) + SD.Price), 2)    AS [Sub total Order],
       ROUND((SUM([OI].[SubTotal]) - SUM([OI].
           [Total])) / SUM([OI].[SubTotal]), 2) * 100 AS [Discount],
       SUM([OI].[Total]) + SD.Price                   AS [Total order],
       [SD].[DeliveryStart]                           AS [Delivery start],
       [SD].[DeliveryEnd]                             AS [Delivery end]
FROM Sales.DeliveryMethod AS SD
         INNER JOIN Sales.[Order] AS O
                    ON SD.OrderId = O.OrderId
         INNER JOIN Sales.OrderItem AS OI
                    ON OI.OrderId = O.OrderId
GROUP BY O.OrderId,
         O.Status,
         O.ApplicationUserId,
         SD.DeliveryMethodId,
         SD.Price,
         O.OrderDate,
         SD.DeliveryStart,
         SD.DeliveryEnd,
         O.CreditCardId
GO


