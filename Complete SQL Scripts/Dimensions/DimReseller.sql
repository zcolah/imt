-- ====================================
-- Check if DimReseller table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimReseller' )
BEGIN
	DROP TABLE dbo.DimReseller;
END
GO

-- ====================================
-- Create DimReseller table
-- ====================================

CREATE TABLE dbo.DimReseller(
DimResellerKey INT IDENTITY(1,1)CONSTRAINT PK_dimReseller PRIMARY KEY CLUSTERED NOT NULL,

ResellerID [varchar] (40) NOT NULL, --Natural Key

ResellerName [varchar] (30) NOT NULL,
ContactName [varchar] (30) NOT NULL,
PhoneNumber [varchar] (15) NOT NULL,
Email [varchar] (40) NOT NULL,

[Address] [varchar] (40) NOT NULL,
City [varchar] (40) NOT NULL,
PostalCode [varchar] (40) NOT NULL,
State_Province [varchar] (40) NOT NULL,
Country [varchar] (40) NOT NULL,

);
GO

-- ====================================
-- Load DimReseller Table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimReseller')
BEGIN

INSERT INTO dbo.DimReseller(

	ResellerID,
	ResellerName, 
	ContactName,
	PhoneNumber,
	Email,


	[Address] ,
	City ,
	PostalCode,
	State_Province,
	Country	)

	SELECT 
		
	dbo.StageReseller.ResellerID,

	dbo.StageReseller.ResellerName AS ResellerName,
	dbo.StageReseller.ResellerName AS ContactName,


	dbo.StageReseller.PhoneNumber,
	dbo.StageReseller.EmailAddress as Email,

	dbo.StageReseller.Address,
	dbo.StageReseller.City,
	dbo.StageReseller.PostalCode,
	dbo.StageReseller.StateProvince,
	dbo.StageReseller.Country
	
	FROM StageReseller
END


-- =============================
-- Begin load of unknown member
-- =============================
SET IDENTITY_INSERT dbo.dimReseller ON;

INSERT INTO dbo.dimReseller(
	dimResellerKey,
	ResellerID,
	ResellerName, 
	ContactName,
	PhoneNumber,
	Email,


	[Address] ,
	City ,
	PostalCode,
	State_Province,
	Country



)
VALUES
( 
-1, 
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimReseller OFF;
GO



