ALTER TABLE  dbo.FactResellerSales  ADD CONSTRAINT [FK_FactResellerSales_SalesTerritoryKey_DimSalesTerritory] FOREIGN KEY ([SalesTerritoryKey])  REFERENCES DimSalesTerritory([SalesTerritoryKey])...