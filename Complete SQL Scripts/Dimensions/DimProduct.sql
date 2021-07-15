-- ====================================
-- Check if DimProduct table exisits and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimProduct' )
BEGIN
	DROP TABLE dbo.DimProduct;
END
GO

-- ====================================
-- Create DimProduct table
-- ====================================

CREATE TABLE dbo.DimProduct
(
DimProductKey INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimProduct PRIMARY KEY CLUSTERED,
ProductID [int] NOT NULL, --Natural Key
ProductTypeID [int] NOT NULL, --Natural Key
ProductCategoryID [int] NOT NULL, --Natural Key
ProductName [varchar] (40) NOT NULL,
ProductType [varchar] (40) NOT NULL,
ProductCategory [varchar] (40) NOT NULL,
ProductRetailPrice [float] NOT NULL,
ProductWholesalePrice [float] NOT NULL,
ProductCost [float] NOT NULL,
ProductRetailProfit [float] NOT NULL,
ProductWholesaleProfit [float] NOT NULL,
ProductProfitMarginUnitPercent [float] NOT NULL
);
GO

-- ====================================
-- Load DimProduct table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimProduct')
BEGIN

INSERT INTO dbo.DimProduct(
		ProductID,
		ProductTypeID,
		ProductCategoryID,
		ProductName,
		ProductType,
		ProductCategory,
		ProductRetailPrice,
		ProductWholesalePrice,
		ProductCost,
		ProductRetailProfit,
		ProductWholesaleProfit,
		ProductProfitMarginUnitPercent 
	)

	SELECT 
		
		dbo.StageProduct.ProductID AS ProductID,
		dbo.StageProductType.ProductTypeID AS ProductTypeID,
		dbo.StageProductCategory.ProductCategoryID AS ProductCategoryID,
		dbo.StageProduct.Product AS ProductName,
		dbo.StageProductType.ProductType AS ProductType,
		dbo.StageProductCategory.ProductCategory AS ProductCategory,
		dbo.StageProduct.Price AS ProductRetailPrice,
		dbo.StageProduct.WholesalePrice AS ProductWholesalePrice,
		dbo.StageProduct.Cost AS ProductCost,
		dbo.StageProduct.Price - dbo.StageProduct.Cost AS ProductRetailProfit,
		dbo.StageProduct.WholesalePrice - dbo.StageProduct.Cost AS ProductWholsesaleProfit,
		(100*(dbo.StageProduct.Price - dbo.StageProduct.Cost))/(dbo.StageProduct.Price) AS ProfitMarginUnitPercent
		
	
	FROM StageProduct
	INNER JOIN StageProductType
	ON StageProduct.ProductTypeID = StageProductType.ProductTypeID
	INNER JOIN StageProductCategory
	ON StageProductType.ProductCategoryID= StageProductCategory.ProductCategoryID;

END
GO 





-- =============================
-- Begin load of unknown member
-- =============================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimProduct')

BEGIN

SET IDENTITY_INSERT dbo.dimProduct ON;

INSERT INTO dbo.dimProduct
(
		DimProductKey,
		ProductID,
		ProductTypeID,
		ProductCategoryID,
		ProductName,
		ProductType,
		ProductCategory,
		ProductRetailPrice,
		ProductWholesalePrice,
		ProductCost,
		ProductRetailProfit,
		ProductWholesaleProfit,
		ProductProfitMarginUnitPercent 
)
VALUES
( 

		-1,
		-1,
		-1,
		-1,
		'Unknown',
		'Unknown',
		'Unknown',
		0.0,
		0.0,
		0.0,
		0.0,
		0.0,
		0.0
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimProduct OFF;

END

GO




