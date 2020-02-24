SELECT 
    t.NAME AS table_name,
    i.name AS index_name,
    i.type_desc as index_type,
    a.type_desc as allocation_unit_type,
    p.data_compression_desc,
    p.rows,
    a.total_pages,
    a.used_pages,
    a.data_pages,
    (a.total_pages * 8) / 1024.0 AS total_space_mb, 
    (a.used_pages * 8) / 1024.0 AS used_space_mb, 
    (a.data_pages * 8) / 1024.0 AS data_space_mb,
    p.rows / (CASE WHEN a.data_pages > 0 THEN a.data_pages ELSE NULL END) AS rows_per_page,
    (a.data_pages * 8 * 1024.0) / (CASE WHEN p.rows > 0 THEN p.rows ELSE NULL END) as bytes_per_row
FROM sys.objects t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
ORDER BY t.name, i.type_desc, i.name
