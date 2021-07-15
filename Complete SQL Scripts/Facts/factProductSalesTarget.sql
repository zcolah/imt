-- ====================================
-- Check if factProductSalesTarget table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factProductSalesTarget' )
BEGIN
	DROP TABLE factProductSalesTarget;
END
GO




-- ====================================
-- Create factProductSalesTarget table
-- ====================================

CREATE TABLE dbo.factProductSalesTarget(

factSalesTargetKey INT IDENTITY(1,1) CONSTRAINT PK_factSalesTarget PRIMARY KEY CLUSTERED NOT NULL,
dimProductKey int FOREIGN KEY REFERENCES dimProduct(dimProductKey),
dimTargetDateKey int FOREIGN KEY REFERENCES dimDate(dimDateID),
ProductTargetSalesQuantity [float] NOT NULL

);
GO