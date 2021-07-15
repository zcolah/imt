-- ====================================
-- Check if factSalesTarget table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSalesTarget' )
BEGIN
	DROP TABLE factSalesTarget;
END
GO
-- ====================================
-- Create factSalesActual table
-- ====================================

CREATE TABLE dbo.factSalesTarget(

factSalesTargetKey INT IDENTITY(1,1) CONSTRAINT PK_factSalesTarget PRIMARY KEY CLUSTERED NOT NULL,
dimStoreKey int FOREIGN KEY REFERENCES dimStore(dimStoreKey),
dimResellerKey int FOREIGN KEY REFERENCES dimReseller(dimResellerKey),
dimCustomerKey int FOREIGN KEY REFERENCES dimCustomer(dimCustomerKey),
dimChannelKey int FOREIGN KEY REFERENCES dimChannel(dimChannelKey),
dimTargetDateKey int FOREIGN KEY REFERENCES dimDate(dimDateID),
SalesTargetAmount [float] NOT NULL
);
GO