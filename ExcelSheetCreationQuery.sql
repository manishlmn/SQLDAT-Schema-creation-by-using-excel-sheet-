
select 

 DB_NAME() AS [Database] 
 , Sch.name AS [table_schema] 
 , Ta.name AS [table_name] 
 , Co.name AS [column_name] 
 , 'NewColumn' AS [Type Of Change] 
 , 'Comments' AS [Comments] 
 ,'CNName' AS [CN] 
 , 'Version1.0' AS [Release] 
 , TY.Name AS [Data_Type] 
 ,case when Co.max_length=-1 Then (select top 1 max_length from sys.types where name=Ty.name) ELSE Co.max_length END AS [Max_Length] 
 ,Co.precision AS [Precision] 
 ,Co.column_id AS [Ordinal_Position] 
 ,co.is_nullable AS [Is_Nullable] 
 ,co.is_identity AS [Is_Identity] 
 ,ISNULL((SELECT i.is_primary_key FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic ON i.OBJECT_ID = ic.OBJECT_ID
          AND i.index_id = ic.index_id WHERE i.is_primary_key = 1 AND ic.OBJECT_ID= Ta.object_id AND ic.column_id=co.column_id ),0)
		  AS [PrimaryKey]
 , ISNULL(DF.definition,'') AS [Default_Expression] 
 ,ISNULL((select c.name from  sys.columns C where C.object_id =FKC.referenced_object_id AND c.column_id = FKC.referenced_column_id ),'')
   AS [ForeignKeyColumnName] 
,ISNULL(OBJECT_NAME(FKC.referenced_object_id),'') AS [ForeignKeyTable]

from   sys.tables Ta
inner join sys.schemas Sch on Ta.schema_id=Sch.schema_id
inner join sys.columns Co on Co.object_id =Ta.object_id 
inner join sys.types Ty on Ty.user_type_id=Co.user_type_id
left join sys.default_constraints Df on DF.parent_object_id=Ta.object_id AND DF.parent_column_id =Co.column_id 
left join Sys.foreign_key_columns FKC on FKC.parent_object_id =ta.object_id
and co.column_id =FKC.parent_column_id

where Ta.name not like 'SYS%'
order by Ta.name,Co.column_id asc

--where Ta.name='FactInternetSales' --not like 'SYS%'


--select c.name,* from  sys.columns C where 
--C.object_id =OBJECT_ID('FactInternetSales') --AND c.column_id = FKC.referenced_column_id 

--select OBJECT_NAME(referenced_object_id),  *from Sys.foreign_key_columns  where parent_object_id=OBJECT_ID('FactInternetSales')
