CREATE  TABLE dbo.NewFactCurrencyRate( AverageRate  real IDENTITY(1,1) NULL,
 CurrencyID  nvarchar(3) NULL,
 CurrencyDate  date NULL,
 EndOfDayRate  real NULL,
 CurrencyKey  int NULL,
 DateKey  int NULL)
