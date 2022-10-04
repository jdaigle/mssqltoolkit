SELECT
    query_stats.sql_handle,
    sql_text.text as sql_text,
    query_stats.plan_handle,
    query_stats.creation_time,
    query_stats.last_execution_time,
    query_stats.execution_count,
    query_stats.total_elapsed_time,
    query_stats.min_elapsed_time,
    query_stats.max_elapsed_time,
    query_stats.total_worker_time,
    query_stats.min_worker_time,
    query_stats.max_worker_time,
    query_stats.total_logical_writes,
    query_stats.total_logical_reads,
    query_stats.total_rows,
    query_stats.min_rows,
    query_stats.max_rows,
    query_stats.total_grant_kb,
    query_stats.min_grant_kb,
    query_stats.max_grant_kb,
    query_stats.total_used_grant_kb,
    query_stats.min_used_grant_kb,
    query_stats.max_used_grant_kb,
    query_stats.total_spills,
    query_stats.min_spills,
    query_stats.max_spills
FROM sys.dm_exec_query_stats as query_stats
CROSS APPLY sys.dm_exec_sql_text(query_stats.sql_handle) as sql_text

;
