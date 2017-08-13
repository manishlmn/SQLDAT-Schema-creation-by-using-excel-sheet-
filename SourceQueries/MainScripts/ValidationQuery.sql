
:setvar Release "${Release}"

:setvar SelectedDBs "${SelectedDBs}"

:setvar SelectedSchemas  "${SelectedSchemas}"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'


Select [database] , [table_schema], [table_name], [Decription] , [Count] from (
select count(*) AS 'Count','Schema is Null'  AS 'Decription' ,[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [table_schema] IS  NULL AND Release='$(Release)' 
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Ordinal_Position is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Ordinal_Position] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Data_Type is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Data_Type] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Max_Length is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Max_Length] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Is_Nullable is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Is_Nullable] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Is_Identity is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Is_Identity] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Type Of Change is Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Type Of Change] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

UNION ALL
select count(*),'Database values are Null',[database] , table_schema, table_name  FROM [dbo].[Tahoe] M
where  [Database] IS  NULL AND Release='$(Release)'
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

group by [database] , table_schema,table_name

)Final
where [Count] >0