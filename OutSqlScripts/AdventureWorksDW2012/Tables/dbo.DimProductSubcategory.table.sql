CREATE  TABLE dbo.DimProductSubcategory( ProductSubcategoryKey  int IDENTITY(1,1) NOT NULL,
 ProductSubcategoryAlternateKey  int NULL,
 EnglishProductSubcategoryName  nvarchar(50) NOT NULL,
 SpanishProductSubcategoryName  nvarchar(50) NOT NULL,
 FrenchProductSubcategoryName  nvarchar(50) NOT NULL,
 ProductCategoryKey  int NULL)
