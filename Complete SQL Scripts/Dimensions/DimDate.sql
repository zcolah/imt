IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DimDate')
BEGIN
	DROP TABLE dbo.DimDate;
END
GO
-- ====================================
-- Create DimDate table
-- ====================================

CREATE TABLE dbo.DimDate
(
DimDateID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimDate PRIMARY KEY,
FullDate [date] NOT NULL,
DayNumberOfWeek [int] NOT NULL,
DayNameOfWeek [varchar] (9) NOT NULL,
DayNumberOfMonth [int] NOT NULL,
[MonthName] [varchar](9) NOT NULL,
MonthNumberOfYear [int] NOT NULL,
CalendarYear [int] NOT NULL,
);
GO

-- =========================================================================
-- Create Stored Proceudre InsDimDateyearly to load one year of data
-- =========================================================================

IF EXISTS (SELECT name FROM sys.procedures WHERE name = 'InsDimDateYearly')
BEGIN
	DROP PROCEDURE dbo.InsDimDateYearly;
END
GO

CREATE PROC [dbo].[InsDimDateYearly]
( 
	@Year INT=NULL
)
AS
SET NOCOUNT ON;

DECLARE @Date DATE, @FirstDate Date, @LastDate Date;

SELECT @Year=COALESCE(@Year,YEAR(DATEADD(d,1,MAX(DimDateID)))) FROM dbo.DimDate;

SET @FirstDate=DATEFROMPARTS(COALESCE(@Year,YEAR(GETDATE())-1), 01, 01); -- First Day of the Year
SET @LastDate=DATEFROMPARTS(COALESCE(@Year,YEAR(GETDATE())-1), 12, 31); -- Last Day of the Year

SET @Date=@FirstDate;
-- create CTE with all dates needed for load
;WITH DateCTE AS
(
SELECT @FirstDate AS StartDate -- earliest date to load in table
UNION ALL
SELECT DATEADD(day, 1, StartDate)
FROM DateCTE -- recursively select the date + 1 over and over
WHERE DATEADD(day, 1, StartDate) <= @LastDate -- last date to load in table
)

-- load date dimension table with all dates
INSERT INTO dbo.DimDate 
	(
	FullDate 
	,DayNumberOfWeek 
	,DayNameOfWeek 
	,DayNumberOfMonth 
	,[MonthName] 
	,MonthNumberOfYear 
	,CalendarYear 
	)
SELECT 
	 CAST(StartDate AS DATE) AS FullDate
	,DATEPART(dw, StartDate) AS DayNumberOfWeek
	,DATENAME(dw, StartDate) AS DayNameOfWeek
	,DAY(StartDate) AS DayNumberOfMonth
	,DATENAME(mm, StartDate) AS [MonthName]
	,MONTH(StartDate) AS MonthNumberOfYear
	,YEAR(StartDate) AS CalendarYear
FROM DateCTE
OPTION (MAXRECURSION 0);-- prevents infinate loop from running more than once
GO

-- ========================================================================
-- Execute the procedure for 2013 and 2014 (those are the years you need)
-- ========================================================================
EXEC InsDimDateYearly 2013

EXEC InsDimDateYearly 2014

SELECT * FROM DimDate


-- =============================
-- Begin load of unknown member
-- =============================
SET IDENTITY_INSERT dbo.dimDate ON;

INSERT INTO dbo.dimDate
(

DimDateID, 
FullDate,
DayNumberOfWeek, 
DayNameOfWeek,
DayNumberOfMonth,
[MonthName],
MonthNumberOfYear,
CalendarYear

)
VALUES
( 

-1, 
'0000-01-01',
-1,
'Unknown',
-1,
'Unknown',
-1,
0000
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimDate OFF;
GO