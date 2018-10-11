SELECT
    o.name AS object_name,
    o.[type_desc] AS object_type,
    COALESCE(i.name, '') AS index_name,
    i.type_desc AS index_type,
    au.type_desc AS au_type,
    COUNT_BIG(b.page_id) AS count_pages,
    (COUNT_BIG(b.page_id) * 8.0) / 1024 AS count_mb
FROM sys.dm_os_buffer_descriptors AS b WITH (NOLOCK)
   INNER JOIN sys.allocation_units AS au WITH (NOLOCK)
        On au.allocation_unit_id = b.allocation_unit_id
   INNER JOIN sys.partitions AS p WITH (NOLOCK)
        ON p.partition_id = au.container_id
   INNER JOIN sys.objects AS o WITH (NOLOCK)
        ON p.[object_id] = o.[object_id]
   INNER JOIN sys.indexes AS i WITH (NOLOCK)
       ON o.[object_id] = i.[object_id]
      AND p.index_id = i.index_id
WHERE
        b.database_id = DB_ID()
    AND au.[type] IN (1,2,3)
    AND o.is_ms_shipped = 0
GROUP BY
    o.name,
    o.[type_desc],
    COALESCE(i.name, ''),
    i.type_desc,
    au.type_desc
ORDER BY
    count_pages DESC
OPTION (RECOMPILE);
