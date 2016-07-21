SET NOCOUNT ON 

--DBCC UPDATEUSAGE(0) 

-- DB size.
EXEC sp_spaceused

-- Table row counts and sizes.
CREATE TABLE #t 
( 
    [name] NVARCHAR(128),
    [rows] CHAR(11),
    [reserved] VARCHAR(18), 
    [data] VARCHAR(18), 
    [index_size] VARCHAR(18),
    [unused] VARCHAR(18)
) 

INSERT #t EXEC sp_msForEachTable 'EXEC sp_spaceused ''?''' 

SELECT
    [name],
    REPLACE(CONVERT(VARCHAR,CAST([rows] AS MONEY),1),'.00','') AS [rows],
    REPLACE(CONVERT(VARCHAR,CAST(REPLACE([reserved],' KB','') AS MONEY),1),'.00','') AS [reserved],
    REPLACE(CONVERT(VARCHAR,CAST(REPLACE([data],' KB','') AS MONEY),1),'.00','') AS [data],
    REPLACE(CONVERT(VARCHAR,CAST(REPLACE([index_size],' KB','') AS MONEY),1),'.00','') AS [index_size],
    REPLACE(CONVERT(VARCHAR,CAST(REPLACE([unused],' KB','') AS MONEY),1),'.00','') AS [unused]
FROM   #t
order by [name]

-- # of rows.
SELECT REPLACE(CONVERT(VARCHAR,CAST(SUM(CAST([rows] AS INT)) AS MONEY),1),'.00','') AS [rows]
FROM   #t
 
DROP TABLE #t 