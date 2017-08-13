
:setvar ExcelFilePath "D:\manish\RD_DATADictionary\AdventureDB.xlsx"
:setvar sheetname [EXCEL_IMPORT$]
:setvar SelectedDBs "AdventureWorksDW2012"

:setvar SelectedSchemas  "dbo"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'

IF EXISTS (SELECT 1 FROM SYS.ALL_OBJECTS WHERE NAME='TAHOE' )
 DROP TABLE TAHOE


 exec sp_configure 'show advanced options', 1;
RECONFIGURE;
exec sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
--drop table EXCEL_IMPORT

SELECT * INTO  TAHOE
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0; Database=$(ExcelFilePath); HDR=YES; IMEX=1',
'SELECT * FROM $(sheetname)  where  [Database] is not null');

