WITH buffer_aggregate AS (
    SELECT
        DB_NAME(database_id) AS database_name,
        (COUNT_BIG(*) * 8.0) / 1024 AS cached_mb
    FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
    WHERE database_id <> 32767 -- ResourceDB
    GROUP BY database_id
)
SELECT
    database_name,
    cached_mb,
    cached_mb * 100 / SUM(cached_mb) OVER() AS cached_mb_percent
FROM buffer_aggregate
ORDER BY cached_mb DESC
OPTION (RECOMPILE);
