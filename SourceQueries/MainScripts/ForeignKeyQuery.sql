
:setvar Release "${Release}"

:setvar SelectedDBs "${SelectedDBs}"

:setvar SelectedSchemas  "${SelectedSchemas}"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'

/*ForiegnKeys creations*/
Select [table_schema]+'.'+[table_name]+'.'+[Column_Name]+'.FK_'+isnull([ForeignKeyTable],'')+'.'+isnull([ForeignKeyColumnName],'') +'.fkey'+
+':::'+
'ALTER TABLE  '+[table_schema]+'.'+[table_name]+'  ADD CONSTRAINT [FK_'+[table_name]+'_'+[Column_Name]+'_'+isnull([ForeignKeyTable],'')+'] FOREIGN KEY (['+Column_Name+'])  REFERENCES '+isnull([ForeignKeyTable],'')+'(['+isnull([ForeignKeyColumnName],'')+'])
GO 

ALTER TABLE '+[table_schema]+'.'+[table_name]+' CHECK CONSTRAINT [FK_'+[table_name]+'.'+[Column_Name]+'_'+isnull([ForeignKeyTable],'')+']

GO'
FROM [dbo].[Tahoe] 
where [Database] IS NOT NULL
AND ForeignKeyColumnName IS NOT NULL
AND ForeignKeyTable  IS NOT NULL
AND Release='$(Release)'

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
