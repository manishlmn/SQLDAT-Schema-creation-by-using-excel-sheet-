CREATE  TABLE dbo.FactCurrencyRate( CurrencyKey  int IDENTITY(1,1) NOT NULL,
 DateKey  int NOT NULL,
 AverageRate  float NOT NULL,
 EndOfDayRate  float NOT NULL,
 Date  datetime NULL)
