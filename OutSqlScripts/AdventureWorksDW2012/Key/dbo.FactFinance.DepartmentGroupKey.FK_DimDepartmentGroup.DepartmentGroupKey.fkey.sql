ALTER TABLE  dbo.FactFinance  ADD CONSTRAINT [FK_FactFinance_DepartmentGroupKey_DimDepartmentGroup] FOREIGN KEY ([DepartmentGroupKey])  REFERENCES DimDepartmentGroup([DepartmentGroupKey])...