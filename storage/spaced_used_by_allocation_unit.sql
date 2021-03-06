SELECT 
 t.NAME AS table_name,
 i.name AS index_name,
 i.type_desc as index_type,
 SUM(p.rows) AS row_count,
 SUM(a.total_pages) AS total_pages, 
 SUM(a.used_pages) AS used_pages, 
 SUM(a.data_pages) AS data_pages,
 (SUM(a.total_pages) * 8) / 1024.0 AS total_space_mb, 
 (SUM(a.used_pages) * 8) / 1024.0 AS used_space_mb, 
 (SUM(a.data_pages) * 8) / 1024.0 AS data_space_mb,
 Sum(p.rows) / SUM(CASE WHEN a.data_pages > 0 THEN a.data_pages ELSE NULL END) AS rows_per_page
FROM 
 sys.objects t
INNER JOIN  
 sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
 sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
 sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY 
 t.NAME, i.object_id, i.index_id, i.name, i.type_desc
ORDER BY 
 t.name, i.type_desc, i.name