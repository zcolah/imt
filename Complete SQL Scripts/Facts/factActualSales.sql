-- ====================================
-- Check if factSalesActual table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSalesActual' )
BEGIN
	DROP TABLE factSalesActual;
END
GO
-- ====================================
-- Create factSalesActual table
-- ====================================

CREATE TABLE dbo.factSalesActual(

factSalesActualKey INT IDENTITY(1,1) CONSTRAINT PK_factSalesActual PRIMARY KEY CLUSTERED NOT NULL,
dimProductKey int FOREIGN KEY REFERENCES dimProduct(dimProductKey),
dimStoreKey int FOREIGN KEY REFERENCES dimStore(dimStoreKey),
dimResellerKey int FOREIGN KEY REFERENCES dimReseller(dimResellerKey),
dimCustomerKey int FOREIGN KEY REFERENCES dimCustomer(dimCustomerKey),
dimChannelKey int FOREIGN KEY REFERENCES dimChannel(dimChannelKey),
dimSaleDateKey int FOREIGN KEY REFERENCES dimDate(dimDateID),
SalesHeaderID [varchar] (40) NOT NULL, -- natural key
SalesDetailID [varchar] (40) NOT NULL, -- natural key
SaleQuantity [float] NOT NULL,
SaleAmount [float] NOT NULL
);
GO


----------------
---Load Table
----------------

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSalesActual')
BEGIN
	INSERT INTO dbo.factSalesActual
	(
	dimProductKey, 
	dimChannelKey,
	dimResellerKey,
	dimCustomerKey,
	dimStoreKey,
	SaleQuantity, 
	SaleAmount,
	dimSaleDateKey,
	SalesHeaderID,
	SalesDetailID	
	)
	SELECT 
		ISNULL(dbo.dimProduct.DimProductKey, -1) AS dimProductKey,
		ISNULL(dbo.dimChannel.dimChannelKey, -1) AS dimChannelKey,
		ISNULL(dbo.dimReseller.DimResellerKey, -1)AS dimResellerKey,		
		ISNULL(dbo.dimCustomer.DimCustomerKey, -1) AS dimCustomerKey,
		ISNULL(dbo.dimStore.DimStoreKey, -1)AS dimStoreKey,
		dbo.StageSalesDetail.SalesQuantity AS SaleQuantity, 
		dbo.StageSalesDetail.SalesAmount AS SaleAmount,
		dbo.dimDate.DimDateID AS dimSaleDateKey,
		ISNULL(dbo.StageSalesHeader.SalesHeaderID, -1),
		ISNULL(dbo.StageSalesDetail.SalesDetailID, -1)

	FROM StageSalesHeader
	LEFT JOIN StageSalesDetail ON
	dbo.StageSalesDetail.SalesHeaderID = dbo.StageSalesHeader.SalesHeaderID
	LEFT JOIN dimProduct ON
	dbo.dimProduct.ProductID = dbo.StageSalesDetail.ProductID 
	LEFT JOIN dimChannel ON
	dbo.dimChannel.ChannelID = dbo.StageSalesHeader.ChannelID
	LEFT JOIN dimReseller ON
	dbo.dimReseller.ResellerID = dbo.StageSalesHeader.ResellerID
	LEFT JOIN dimCustomer ON
	dbo.dimCustomer.CustomerID = dbo.StageSalesHeader.CustomerID
	LEFT JOIN dimStore ON
	dbo.dimStore.StoreID = dbo.StageSalesHeader.StoreID
	LEFT JOIN dimDate ON
	dbo.dimDate.FullDate = dbo.StageSalesHeader.[Date]
END
GO 



 
