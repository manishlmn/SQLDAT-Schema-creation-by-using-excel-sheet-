
:setvar Release "Version1.0"

:setvar SelectedDBs "AdventureWorksDW2012"

:setvar SelectedSchemas  "dbo"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'
Select M.[table_schema]+'.'+M.[table_name]+'.PK_'+'.pkey'+
+':::'+'ALTER TABLE  '+ M.[table_schema]+'.'+ M.[table_name]+'  ADD CONSTRAINT [PK_'+ M.[table_schema]+'.'+ M.[table_name]+
Stuff((Select '_'+ C.Column_Name
 from [dbo].[Tahoe] C
			where C.[Database]=M.[Database]
			AND C.[table_schema]=M.[table_schema]
			AND C.[table_name]=M.[table_name]
			AND  C.[PrimaryKey]=1
			FOR XML PATH('')
			), 1, 0, '') +'] PRIMARY KEY CLUSTERED ('+ 
Stuff((Select ','+'['+ C.Column_Name +'] ASC  ' 
 from [dbo].[Tahoe] C
			where C.[Database]=M.[Database]
			AND C.[table_schema]=M.[table_schema]
			AND C.[table_name]=M.[table_name]
			AND  C.[PrimaryKey]=1
			FOR XML PATH('')
			), 1, 1, '') +')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]'
FROM [dbo].[Tahoe] M
where  M.[Database] is not null
AND  M.[PrimaryKey]=1
AND  M.Release='$(Release)'
 AND
	(
	  COALESCE(@DBS,'ALL')='ALL'
	  OR
	   M.[database] IN  (SELECT * FROM fn_FunctionSplit_D(@DBS,','))	
	)
 AND
	(
	  COALESCE(@Schemas,'ALL')='ALL'
	  OR
	   M.[table_schema] IN  (SELECT * FROM fn_FunctionSplit_D(@Schemas,','))	
	)

Group by M.[Database],M.[table_schema],M.[table_name]

