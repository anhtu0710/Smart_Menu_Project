-- ====================================================================
-- KỊCH BẢN TẠO C CƠ SỞ DỮ LIỆU SMART MENU CHO MICROSOFT SQL SERVER
-- ====================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SmartMenuDB')
BEGIN
    CREATE DATABASE SmartMenuDB;
END
GO

USE SmartMenuDB;
GO

-- 1. Users
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
CREATE TABLE Users (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    FullName NVARCHAR(255),
    Phone NVARCHAR(20),
    AvatarUrl NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE()
);
GO

-- 2. Restaurants
IF OBJECT_ID('Restaurants', 'U') IS NOT NULL DROP TABLE Restaurants;
CREATE TABLE Restaurants (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserId BIGINT NOT NULL,
    RestaurantName NVARCHAR(255),
    BusinessType NVARCHAR(100),
    Address NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Restaurants_Users
    FOREIGN KEY(UserId) REFERENCES Users(Id)
);
GO

-- 3. MenuAnalysisSessions
IF OBJECT_ID('MenuAnalysisSessions', 'U') IS NOT NULL DROP TABLE MenuAnalysisSessions;
CREATE TABLE MenuAnalysisSessions (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    RestaurantId BIGINT NOT NULL,
    Status NVARCHAR(50) DEFAULT 'UPLOADED',
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Sessions_Restaurants
    FOREIGN KEY(RestaurantId) REFERENCES Restaurants(Id)
);
GO

-- 4. UploadedFiles
IF OBJECT_ID('UploadedFiles', 'U') IS NOT NULL DROP TABLE UploadedFiles;
CREATE TABLE UploadedFiles (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    FileName NVARCHAR(MAX),
    FilePath NVARCHAR(MAX),
    FileType NVARCHAR(50),
    FileCategory NVARCHAR(50),
    FileSize BIGINT,
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Files_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 5. RawExcelData
IF OBJECT_ID('RawExcelData', 'U') IS NOT NULL DROP TABLE RawExcelData;
CREATE TABLE RawExcelData (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    FileId BIGINT NOT NULL,
    SheetName NVARCHAR(MAX),
    RowNumber INT,
    ColumnName NVARCHAR(MAX),
    ColumnValue NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_RawData_Files
    FOREIGN KEY(FileId) REFERENCES UploadedFiles(Id)
);
GO

-- 6. DataMapping
IF OBJECT_ID('DataMapping', 'U') IS NOT NULL DROP TABLE DataMapping;
CREATE TABLE DataMapping (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    OriginalColumn NVARCHAR(MAX),
    MappedField NVARCHAR(100),
    Confidence FLOAT,
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Mapping_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 7. ProcessedBusinessData
IF OBJECT_ID('ProcessedBusinessData', 'U') IS NOT NULL DROP TABLE ProcessedBusinessData;
CREATE TABLE ProcessedBusinessData (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    AnalysisPayload NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Processed_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 8. MenuImageAnalysis
IF OBJECT_ID('MenuImageAnalysis', 'U') IS NOT NULL DROP TABLE MenuImageAnalysis;
CREATE TABLE MenuImageAnalysis (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    ExtractedText NVARCHAR(MAX),
    LayoutResult NVARCHAR(MAX),
    DesignResult NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_MenuImage_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 9. BusinessMetrics
IF OBJECT_ID('BusinessMetrics', 'U') IS NOT NULL DROP TABLE BusinessMetrics;
CREATE TABLE BusinessMetrics (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    TotalRevenue DECIMAL(18,2),
    TotalQuantity INT,
    EstimatedProfit DECIMAL(18,2),
    MenuScore INT,
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Metrics_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 10. ProductAnalysis
IF OBJECT_ID('ProductAnalysis', 'U') IS NOT NULL DROP TABLE ProductAnalysis;
CREATE TABLE ProductAnalysis (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    ProductName NVARCHAR(MAX),
    AnalysisType NVARCHAR(50),
    Reason NVARCHAR(MAX),
    Metrics NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_ProductAnalysis_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 11. RevenueCategoryAnalysis
IF OBJECT_ID('RevenueCategoryAnalysis', 'U') IS NOT NULL DROP TABLE RevenueCategoryAnalysis;
CREATE TABLE RevenueCategoryAnalysis (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    CategoryName NVARCHAR(MAX),
    Revenue DECIMAL(18,2),
    Percentage FLOAT,
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_RevenueCategory_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 12. AIAnalysisResults
IF OBJECT_ID('AIAnalysisResults', 'U') IS NOT NULL DROP TABLE AIAnalysisResults;
CREATE TABLE AIAnalysisResults (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    Insight NVARCHAR(MAX),
    Recommendation NVARCHAR(MAX),
    Strategy NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_AIResults_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 13. MenuStrategy
IF OBJECT_ID('MenuStrategy', 'U') IS NOT NULL DROP TABLE MenuStrategy;
CREATE TABLE MenuStrategy (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    OptimizeCategory NVARCHAR(MAX),
    StrategyContent NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Strategy_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 14. GeneratedMenus
IF OBJECT_ID('GeneratedMenus', 'U') IS NOT NULL DROP TABLE GeneratedMenus;
CREATE TABLE GeneratedMenus (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    MenuImageUrl NVARCHAR(MAX),
    PdfUrl NVARCHAR(MAX),
    GenerationData NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_GeneratedMenu_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- 15. MenuComparison
IF OBJECT_ID('MenuComparison', 'U') IS NOT NULL DROP TABLE MenuComparison;
CREATE TABLE MenuComparison (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    SessionId BIGINT NOT NULL,
    OldMenuUrl NVARCHAR(MAX),
    NewMenuUrl NVARCHAR(MAX),
    ComparisonResult NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_MenuComparison_Sessions
    FOREIGN KEY(SessionId) REFERENCES MenuAnalysisSessions(Id)
);
GO

-- INDEXES
CREATE INDEX IX_Restaurants_UserId ON Restaurants(UserId);
CREATE INDEX IX_Sessions_RestaurantId ON MenuAnalysisSessions(RestaurantId);
CREATE INDEX IX_Files_SessionId ON UploadedFiles(SessionId);
CREATE INDEX IX_RawExcel_FileId ON RawExcelData(FileId);
CREATE INDEX IX_AIResults_SessionId ON AIAnalysisResults(SessionId);
GO

PRINT N'=== THÀNH CÔNG: TẠO CSDL SMARTMENU SCHEMA 15 BẢNG HOÀN TẤT! ===';
