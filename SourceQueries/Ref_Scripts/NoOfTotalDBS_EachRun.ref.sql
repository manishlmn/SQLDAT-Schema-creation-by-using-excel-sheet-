
:setvar Release "Version1.0"

:setvar SelectedDBs "AdventureWorksDW2012"

:setvar SelectedSchemas  "dbo"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'

SELECT DISTINCT [Database] FROM [tahoe] NOLOCK
WHERE Release='$(Release)' 
 AND
	(
	  COALESCE(@DBS,'ALL')='ALL'
	  OR
	  [database] IN  (SELECT * FROM fn_FunctionSplit_D(@DBS,','))	
	)
 AND
	(
	  COALESCE(@Schemas,'ALL')='ALL'
	  OR
	  [table_schema] IN  (SELECT * FROM fn_FunctionSplit_D(@Schemas,','))	
	)

