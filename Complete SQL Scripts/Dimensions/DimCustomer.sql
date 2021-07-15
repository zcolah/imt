-- ====================================
-- Check if DimCustomer table exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimCustomer' )
BEGIN
	DROP TABLE dbo.DimCustomer;
END
GO

-- ====================================
-- Create DimCustomer table
-- ====================================

CREATE TABLE dbo.DimCustomer(
DimCustomerKey INT IDENTITY(1,1) CONSTRAINT PK_dimCustomer PRIMARY KEY CLUSTERED NOT NULL,
CustomerID [varchar] (40) NOT NULL, --Natural Key
CustomerFullName [varchar] (30) NOT NULL,
CustomerFirstName [varchar] (30) NOT NULL,
CustomerLastName [varchar] (30) NOT NULL,
CustomerGender[varchar] (15) NOT NULL,
Address [varchar] (40) NOT NULL,
City [varchar] (40) NOT NULL,
PostalCode [varchar] (40) NOT NULL,
State_Province [varchar] (40) NOT NULL,
Country [varchar] (40) NOT NULL,
);
GO



-- ====================================
-- Load DimCustomer table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimCustomer')
BEGIN

INSERT INTO dbo.DimCustomer(
	CustomerID,
	CustomerFullName,
	CustomerFirstName, 
	CustomerLastName,
	CustomerGender,
	[Address] ,
	City ,
	PostalCode,
	State_Province,
	Country	)

	SELECT 
		
	dbo.StageCustomer.CustomerID,
	CONCAT(dbo.StageCustomer.FirstName, ' ', dbo.StageCustomer.LastName) AS CustomerFullName,	
	dbo.StageCustomer.FirstName,
	dbo.StageCustomer.LastName,
	dbo.StageCustomer.Gender,
	dbo.StageCustomer.Address,
	dbo.StageCustomer.City,
	dbo.StageCustomer.PostalCode,
	dbo.StageCustomer.StateProvince,
	dbo.StageCustomer.Country
	
	FROM StageCustomer
END


-- =============================
-- Begin load of unknown member
-- =============================
SET IDENTITY_INSERT dbo.dimCustomer ON;

INSERT INTO dbo.dimCustomer
(
	dimCustomerKey,
	CustomerID,
	CustomerFullName,
	CustomerFirstName, 
	CustomerLastName,
	CustomerGender,
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
SET IDENTITY_INSERT dbo.dimCustomer OFF;
GO
