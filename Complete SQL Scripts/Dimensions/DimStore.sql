-- ====================================
-- Check if DimStore table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimStore' )
BEGIN
	DROP TABLE dbo.DimStore;
END
GO

-- ====================================
-- Create DimStore table
-- ====================================

CREATE TABLE dbo.DimStore(
DimStoreKey INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimStore PRIMARY KEY CLUSTERED,
StoreID [int] NOT NULL, --Natural Key
StoreNumber [int] NOT NULL, 
StoreManager [varchar] (40) NOT NULL,
[Address] [varchar] (40) NOT NULL,
City [varchar] (40) NOT NULL,
PostalCode [varchar] (40) NOT NULL,
State_Province [varchar] (40) NOT NULL,
Country [varchar] (40) NOT NULL,
);
GO


-- ====================================
-- Load DimStore table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimStore')
BEGIN

INSERT INTO dbo.DimStore(
	StoreID ,
	StoreNumber ,
	StoreManager ,
	[Address] ,
	City ,
	PostalCode,
	State_Province,
	Country	)

	SELECT 
		
	dbo.StageStore.StoreID,
	dbo.StageStore.StoreNumber,
	dbo.StageStore.StoreManager,
	dbo.StageStore.Address,
	dbo.StageStore.City,
	dbo.StageStore.PostalCode,
	dbo.StageStore.StateProvince,
	dbo.StageStore.Country
		
	
	FROM StageStore
END
GO 


-- =============================
-- Begin load of unknown member
-- =============================
SET IDENTITY_INSERT dbo.dimStore ON;

INSERT INTO dbo.dimStore(

	dimStoreKey,
	StoreID ,
	StoreNumber ,
	StoreManager ,
	[Address] ,
	City ,
	PostalCode,
	State_Province,
	Country


)
VALUES
( 
-1,
-1,
-1,
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimStore OFF;
GO

