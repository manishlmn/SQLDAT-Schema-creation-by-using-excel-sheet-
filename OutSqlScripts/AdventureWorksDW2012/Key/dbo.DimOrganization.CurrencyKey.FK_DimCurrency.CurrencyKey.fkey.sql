ALTER TABLE  dbo.DimOrganization  ADD CONSTRAINT [FK_DimOrganization_CurrencyKey_DimCurrency] FOREIGN KEY ([CurrencyKey])  REFERENCES DimCurrency([CurrencyKey])...