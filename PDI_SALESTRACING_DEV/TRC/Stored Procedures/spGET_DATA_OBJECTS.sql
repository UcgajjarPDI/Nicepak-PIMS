CREATE PROCEDURE [TRC].[spGET_DATA_OBJECTS]
WITH EXEC AS CALLER
AS
BEGIN

  -- ALL DATA OBJECTS
    SELECT 
         SCHEMA_NAME(O.schema_id) as SCHEMA_NM, 
         CASE WHEN O.type='U' THEN 'TABLE' WHEN O.type='P' THEN 'STROED PROC' WHEN O.type='FN' THEN 'FUNCTION' END AS OBJ_TYPE,
         O.name AS OBJ_NM        
  FROM   [PDI_SALESTRACING_DEV].sys.objects  O
  WHERE O.type in ( 'U','P','FN') AND
  SCHEMA_NAME(O.schema_id) NOT IN ('dbo')
  ORDER BY 1, 2, 3

  -- DEPDENCIES
  SELECT ReferencingObjectType = CASE WHEN  o1.type='U' THEN 'TABLE' WHEN o1.type='P' THEN 'STROED PROC' WHEN o1.type='FN' THEN 'FUNCTION' END,
         ReferencingObject = SCHEMA_NAME(o1.schema_id)+'.'+o1.name,
         ReferencedObject = SCHEMA_NAME(o2.schema_id)+'.'+ed.referenced_entity_name,
         ReferencedObjectType = CASE WHEN o2.type='U' THEN 'TABLE' WHEN o2.type='P' THEN 'STROED PROC' WHEN o2.type='FN' THEN 'FUNCTION' END 
  FROM   [PDI_SALESTRACING_DEV].sys.sql_expression_dependencies ed
         INNER JOIN  [PDI_SALESTRACING_DEV].sys.objects o1
           ON ed.referencing_id = o1.object_id
         INNER JOIN [PDI_SALESTRACING_DEV].sys.objects o2
           ON ed.referenced_id = o2.object_id
  WHERE o1.type in ('P','TR','V', 'TF')
  ORDER BY ReferencingObjectType, ReferencingObject

END