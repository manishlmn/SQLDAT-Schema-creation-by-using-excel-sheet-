
/*Existing Table*/
:setvar Release "Version1.0"

:setvar SelectedDBs "AdventureWorksDW2012"

:setvar SelectedSchemas  "dbo"

Declare @DBS  NVARCHAR(4000) ='$(SelectedDBs)'

Declare @Schemas  NVARCHAR(4000) ='$(SelectedSchemas)'


select  M.[table_schema]+'.'+M.[table_name]+'.table:::'+
'ALTER TABLE '+M.[table_schema]+'.'+M.[table_name]+' ADD '+ 
Stuff((Select ','+' '+ C.Column_Name +'  '+ 
		  + Case when [Data_Type] ='varchar' Then [Data_Type]+'('+Cast([Max_Length] AS varchar(10))+')'
				 when [Data_Type] ='nvarchar'Then [Data_Type]+'('+Cast (CAST ([Max_Length] AS INT)/2 AS varchar(10))+')'
				ELSE [Data_Type] END
		  + Case when [Ordinal_Position]=1 then '  IDENTITY(1,1)'         
				ELSE '' END 
		  + Case WHEN Is_Nullable =0 Then ' NOT NULL' ELSE ' NULL' END  --+  CHAR(10) 
  
  			from [dbo].[Tahoe] C
			where C.[Database]=M.[Database]
			AND C.[table_schema]=M.[table_schema]
			AND C.[table_name]=M.[table_name]
			order by Ordinal_Position
			FOR XML PATH('')), 1, 1, '')+')' 
			FROM [dbo].[Tahoe] M
where [Database] IS NOT NULL
AND [table_schema] IS NOT NULL
AND [Ordinal_Position] IS NOT NULL
AND [Data_Type] IS NOT NULL
AND [Max_Length]  IS NOT NULL
AND [Is_Nullable] IS NOT NULL
AND [Is_Identity] IS NOT NULL
--AND [Type Of Change]= 'New Column'
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

Group by M.[Database],M.[table_schema],M.[table_name]
ORDER BY 1



