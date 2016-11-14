SELECT
    o.name as object_name,
    o.[type_desc] as object_type,
    COALESCE(i.name, '') as index_name,
    i.type_desc as index_type,
    au.type_desc as au_type,
    buffer_pages = COUNT_BIG(b.page_id),
    buffer_mb = COUNT_BIG(b.page_id) / 128
FROM sys.dm_os_buffer_descriptors AS b
   INNER JOIN sys.allocation_units AS au
        On au.allocation_unit_id = b.allocation_unit_id
   INNER JOIN sys.partitions AS p
        ON p.partition_id = au.container_id
   INNER JOIN sys.objects AS o
        ON p.[object_id] = o.[object_id]
   INNER JOIN sys.indexes AS i
       ON o.[object_id] = i.[object_id]
      AND p.index_id = i.index_id
WHERE b.database_id = DB_ID()
  AND au.[type] IN (1,2,3)
  AND o.is_ms_shipped = 0
GROUP BY
    o.name,
    o.[type_desc],
    COALESCE(i.name, ''),
    i.type_desc,
    au.type_desc
ORDER BY
   buffer_pages DESC;