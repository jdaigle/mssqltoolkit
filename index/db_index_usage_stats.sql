SELECT
    o.name AS object_name,
    o.[type_desc] AS object_type,
    COALESCE(i.name, '') AS index_name,
    i.type_desc AS index_type,
    stat.user_seeks,
    stat.last_user_seek,
    stat.user_scans,
    stat.last_user_scan,
    stat.user_lookups,
    stat.last_user_lookup,
    stat.last_user_update,
    stat.last_user_update
FROM sys.dm_db_index_usage_stats stat
    INNER JOIN sys.objects o WITH (NOLOCK)
        ON o.object_id = stat.object_id 
    INNER JOIN sys.indexes i WITH (NOLOCK)
        ON i.object_id = stat.object_id AND i.index_id = stat.index_id
WHERE
        stat.database_id = DB_ID('CHANGE ME')
ORDER BY
    o.name,
    i.type_desc,
    i.name
OPTION (RECOMPILE);
