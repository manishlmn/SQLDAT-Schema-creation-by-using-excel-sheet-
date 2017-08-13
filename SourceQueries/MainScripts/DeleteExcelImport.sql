


IF EXISTS (SELECT 1 FROM SYS.ALL_OBJECTS WHERE NAME='TAHOE' )
 DROP TABLE TAHOE

 IF  EXISTS ( select * from sys.all_objects where name ='fn_FunctionSplit_D' AND [type]='TF')
DROP FUNCTION [dbo].[fn_FunctionSplit_D] 