CREATE  TABLE dbo.FactProductInventory( ProductKey  int IDENTITY(1,1) NOT NULL,
 DateKey  int NOT NULL,
 MovementDate  date NOT NULL,
 UnitCost  money NOT NULL,
 UnitsIn  int NOT NULL,
 UnitsOut  int NOT NULL,
 UnitsBalance  int NOT NULL)
