ALTER TABLE  dbo.FactCurrencyRate  ADD CONSTRAINT [FK_FactCurrencyRate_DateKey_DimDate] FOREIGN KEY ([DateKey])  REFERENCES DimDate([DateKey])...