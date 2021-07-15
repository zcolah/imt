-- ====================================
-- Check if DimChanneltable exists and drop if exists
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimChannel' )
BEGIN
	DROP TABLE dbo.DimChannel;
END
GO

-- ====================================
-- Create DimChannel table
-- ====================================

CREATE TABLE dbo.DimChannel
(
	dimChannelKey INT IDENTITY(1,1) CONSTRAINT PK_dimChannel PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	ChannelID INT NOT NULL, --Natural Key
	ChannelCategoryID INT NOT NULL, --Natural Key
	ChannelName VARCHAR(50) NOT NULL,
	ChannelCategory VARCHAR(50) NOT NULL
);
GO



-- ====================================
-- Load DimChannel table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimChannel')
BEGIN

INSERT INTO dbo.DimChannel(
		ChannelID,
		ChannelCategoryID,
		ChannelName,
		ChannelCategory
	)

	SELECT 
		
		dbo.StageChannel.ChannelID, 
		dbo.StageChannelCategory.ChannelCategoryID, 
		dbo.StageChannel.Channel AS ChannelName, 
		dbo.StageChannelCategory.ChannelCategory
		
	
	FROM StageChannel
	INNER JOIN StageChannelCategory
	ON StageChannel.ChannelCategoryID = StageChannelCategory.ChannelCategoryID

END
GO 



-- =============================
-- Begin load of unknown member
-- =============================

SET IDENTITY_INSERT dbo.DimChannel ON;

INSERT INTO dbo.DimChannel
(
		dimChannelKey,
		ChannelID,
		ChannelCategoryID,
		ChannelName,
		ChannelCategory

)
VALUES
( 
-1,
-1,
-1 ,
'Unknown',
'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimChannel OFF;
GO


