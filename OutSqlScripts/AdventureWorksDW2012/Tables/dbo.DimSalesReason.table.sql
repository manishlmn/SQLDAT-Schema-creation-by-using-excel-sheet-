CREATE  TABLE dbo.DimSalesReason( SalesReasonKey  int IDENTITY(1,1) NOT NULL,
 SalesReasonAlternateKey  int NOT NULL,
 SalesReasonName  nvarchar(50) NOT NULL,
 SalesReasonReasonType  nvarchar(50) NOT NULL)
