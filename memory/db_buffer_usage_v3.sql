WITH buffer_aggregate AS (
    SELECT
        DB_NAME(database_id) AS database_name,
        COUNT_BIG(*) AS count_pages,
        (COUNT_BIG(*) * 8.0) / 1024 AS count_mb
    FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
    WHERE database_id <> 32767 -- ResourceDB
    GROUP BY database_id
)
SELECT
    database_name,
    count_pages,
    count_mb,
    count_mb * 100 / SUM(count_mb) OVER() AS cached_mb_percent
FROM buffer_aggregate
ORDER BY count_pages DESC
OPTION (RECOMPILE);
