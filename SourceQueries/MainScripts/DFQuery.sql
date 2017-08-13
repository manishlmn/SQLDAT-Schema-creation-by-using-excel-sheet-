
/*DefaultConstraints */

:setvar Release "${Release}"

:setvar SelectedDBs "${SelectedDBs}"

:setvar SelectedSchemas  "${SelectedSchemas}"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'

Select [table_schema]+'.'+[table_name]+'.DF_'+[table_name]+'_'+[Column_Name]+'.defconst::: ALTER TABLE '+[table_schema]+'.'+[table_name]+' ADD CONSTRAINT [DF_'+[table_name]+'_'+[Column_Name] +'] DEFAULT '+[Default_Expression]+' FOR ['+[Column_Name]+'];'
FROM [dbo].[Tahoe] 
where [Database] is not null
AND  Default_Expression is not null 
and Default_Expression <>''
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