ALTER TABLE  dbo.FactResellerSales  ADD CONSTRAINT [FK_FactResellerSales_ProductKey_DimProduct] FOREIGN KEY ([ProductKey])  REFERENCES DimProduct([ProductKey])...