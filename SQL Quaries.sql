----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STA 

-- Create table "CallData"
CREATE TABLE [CallData] (
    [CallTimestamp] nvarchar(50),
    [Call Type] nvarchar(50),
    [EmployeeID] nvarchar(50),
    [CallDuration] nvarchar(50),
    [WaitTime] nvarchar(50),
    [CallAbandoned] nvarchar(50)
)

-- Create table "CallCharges"
CREATE TABLE [STA CallCharges] (
    [Call Type ] varchar(50),
    [Call Charges (2018)] varchar(50),
    [Call Charges (2019)] varchar(50),
    [Call Charges (2020)] varchar(50),
    [Call Charges (2021)] varchar(50)
)

-- Create table "USStates"
CREATE TABLE [USStates] (
    [StateCD] varchar(50),
    [Name] varchar(50),
    [Region] varchar(50)
)

-- Create table "CallTypes"
CREATE TABLE [CallTypes] (
    [CallTypeID] varchar(50),
    [CallTypeLabel] varchar(50)
)


-- Create table "Employees"
CREATE TABLE [Employees] (
    [EmployeeID] varchar(50),
    [EmployeeName] varchar(50),
    [Site] varchar(50),
    [ManagerName] varchar(50)
)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ODS

-- Create table "Employees"
CREATE TABLE [Employees] (
    [EmployeeID] nvarchar(10),
    [EmployeeFirstName] nvarchar(50),
    [EmployeeLastName] nvarchar(50),
    [ManagerFirstName] nvarchar(50),
    [ManagerLastName] nvarchar(50),
    [StateCode] nvarchar(2),
    [City] nvarchar(50),
    [StateName] nvarchar(50),
    [Region] nvarchar(50)
)

-- Create table "Calls"
CREATE TABLE [Calls] (
    [CallTypeID] nvarchar(1),
    [EmployeeID] nvarchar(10),
	[ChargeID] nvarchar(10),
    [CallDate] date,
    [CallYear] int,
    [CallTime] datetime,
	[CallDuration] int,
	[WaitTime] int,
	[SLAStatus] nvarchar(11),
    [CallAbandoned] bit
)

-- Create Unpivot Table "CallCharges"
CREATE TABLE [CallCharges] (
    [ChargeID] nvarchar(10),
	[CallTypeID] nvarchar(1),
    [CallTypeName] nvarchar(20),
    [Year] int,
    [CallCharge] numeric(2,1)
)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DWH

-- Create table "DimCallCharges"
CREATE TABLE [dbo].[DimCallCharges](
	[CallChargeKey] INT IDENTITY(1,1) PRIMARY KEY,	-- Technical Key 
    [ChargeID] nvarchar(10),                        -- Source Key
	[CallTypeID] nvarchar(1),
    [CallTypeName] nvarchar(20),
    [Year] int,
    [CallCharge] numeric(2,1)	
) 

-- Updating this table in the SQL Command
UPDATE [dbo].[DimCallCharges] 
SET [CallTypeID] = ?,
	[CallTypeName] = ?,
    [Year] = ?,
	[CallCharge] = ?
WHERE [ChargeID] = ?



-- Create table DimEmployees
CREATE TABLE [dbo].[DimEmployees](
    [EmployeeKey] INT IDENTITY(1,1) PRIMARY KEY,    -- Technical Key
    [EmployeeID] nvarchar(10),                      -- Source Key
    [EmployeeFirstName] nvarchar(50),
    [EmployeeLastName] nvarchar(50),
    [ManagerFirstName] nvarchar(50),
    [ManagerLastName] nvarchar(50),
    [StateCode] nvarchar(2),
    [City] nvarchar(50),
    [StateName] nvarchar(50),
    [Region] nvarchar(50),
    [CurrentFlag] int,
    [StartDate] date,
    [EndDate] date
)

-- Updating this table in the SQL Command
UPDATE DimEmployees
SET CurrentFlag = 0, 
	EndDate = GETDATE()-1 
WHERE EmployeeID = ? 
AND CurrentFlag = 1

-- Create table "FactCalls"
CREATE TABLE [FactCalls] (
    [CallChargeKey] int,
    [EmployeeKey] int,
	[DateKey] int,
    [CallDuration] int,
    [WaitTime] int,
    [SLAStatus] nvarchar(11),
	[CallAbandoned] bit
)

-- Create table "DimDate"
CREATE TABLE dbo.DimDate (
   DateKey INT NOT NULL PRIMARY KEY,
   [Date] DATE NOT NULL,
   [Day] TINYINT NOT NULL,
   [DaySuffix] CHAR(2) NOT NULL,
   [Weekday] TINYINT NOT NULL,
   [WeekDayName] VARCHAR(10) NOT NULL,
   [WeekDayName_Short] CHAR(3) NOT NULL,
   [WeekDayName_FirstLetter] CHAR(1) NOT NULL,
   [DOWInMonth] TINYINT NOT NULL,
   [DayOfYear] SMALLINT NOT NULL,
   [WeekOfMonth] TINYINT NOT NULL,
   [WeekOfYear] TINYINT NOT NULL,
   [Month] TINYINT NOT NULL,
   [MonthName] VARCHAR(10) NOT NULL,
   [MonthName_Short] CHAR(3) NOT NULL,
   [MonthName_FirstLetter] CHAR(1) NOT NULL,
   [Quarter] TINYINT NOT NULL,
   [QuarterName] VARCHAR(6) NOT NULL,
   [Year] INT NOT NULL,
   [MMYYYY] CHAR(6) NOT NULL,
   [MonthYear] CHAR(7) NOT NULL,
   IsWeekend BIT NOT NULL,
   )

  
   GO


   SET NOCOUNT ON

TRUNCATE TABLE DimDate

DECLARE @CurrentDate DATE = '2018-01-01'
DECLARE @EndDate DATE = '2021-12-31'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO [dbo].[DimDate] (
      [DateKey],
      [Date],
      [Day],
      [DaySuffix],
      [Weekday],
      [WeekDayName],
      [WeekDayName_Short],
      [WeekDayName_FirstLetter],
      [DOWInMonth],
      [DayOfYear],
      [WeekOfMonth],
      [WeekOfYear],
      [Month],
      [MonthName],
      [MonthName_Short],
      [MonthName_FirstLetter],
      [Quarter],
      [QuarterName],
      [Year],
      [MMYYYY],
      [MonthYear],
      [IsWeekend]
      )
   SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      [DaySuffix] = CASE 
         WHEN DAY(@CurrentDate) = 1
            OR DAY(@CurrentDate) = 21
            OR DAY(@CurrentDate) = 31
            THEN 'st'
         WHEN DAY(@CurrentDate) = 2
            OR DAY(@CurrentDate) = 22
            THEN 'nd'
         WHEN DAY(@CurrentDate) = 3
            OR DAY(@CurrentDate) = 23
            THEN 'rd'
         ELSE 'th'
         END,
      WEEKDAY = DATEPART(dw, @CurrentDate),
      WeekDayName = DATENAME(dw, @CurrentDate),
      WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)),
      WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1),
      [DOWInMonth] = DAY(@CurrentDate),
      [DayOfYear] = DATENAME(dy, @CurrentDate),
      [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [Month] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [Year] = YEAR(@CurrentDate),
      [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
            OR DATENAME(dw, @CurrentDate) = 'Saturday'
            THEN 1
         ELSE 0
         END

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ADM

-- Create table "Technical_Rejects"
CREATE TABLE [dbo].[TechnicalRejects] (
    [RejectDate] datetime,
    [RejectPackageAndTask] nvarchar(255),
    [RejectColumn] nvarchar(255),
    [RejectDescription] nvarchar(520)
)

-- Create table "Functional_Rejects"
CREATE TABLE [dbo].[Functional_Rejects] (
    [RejectDate] datetime,
    [RejectPackageAndTask] nvarchar(255),
    [RejectColumn] nvarchar(255),
    [RejectDescription] nvarchar(520),
    [Nb_Rows] int
)