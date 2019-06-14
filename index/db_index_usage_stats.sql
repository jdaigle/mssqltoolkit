SELECT
    o.name AS object_name,
    o.[type_desc] AS object_type,
    COALESCE(i.name, '') AS index_name,
    i.type_desc AS index_type,
    pstat.row_count,
    pstat.used_page_count,
    ((pstat.used_page_count * 8) / 1024.0) as used_mb_count,
    stat.user_seeks,
    stat.last_user_seek,
    stat.user_scans,
    stat.last_user_scan,
    stat.user_lookups,
    stat.last_user_lookup,
    stat.user_lookups,
    stat.last_user_update
FROM sys.objects o WITH (NOLOCK)
    INNER JOIN sys.indexes i WITH (NOLOCK)
        ON i.object_id = o.object_id
    INNER JOIN sys.dm_db_partition_stats pstat
        ON pstat.object_id = i.object_id and pstat.index_id = i.index_id
    LEFT JOIN sys.dm_db_index_usage_stats stat
        ON stat.object_id = i.object_id AND stat.index_id = i.index_id
WHERE o.object_id = OBJECT_ID('CHANGE ME OR REMOVE')
ORDER BY
    o.name,
    i.type_desc,
    i.name
OPTION (RECOMPILE);
