SELECT
    request_session_id,
    dbname,
    ObjectName,
    index_name,
    resource_type,
    request_mode,
    request_status,
    COUNT(*) as lock_count
FROM (
    SELECT
        dm_tran_locks.request_session_id,
        dm_tran_locks.resource_database_id,
        DB_NAME(dm_tran_locks.resource_database_id) AS dbname,
        CASE
            WHEN resource_type = 'OBJECT'
                THEN OBJECT_NAME(dm_tran_locks.resource_associated_entity_id)
            ELSE OBJECT_NAME(partitions.OBJECT_ID)
        END AS ObjectName,
        partitions.index_id,
        indexes.name AS index_name,
        dm_tran_locks.resource_type,
        dm_tran_locks.resource_description,
        dm_tran_locks.resource_associated_entity_id,
        dm_tran_locks.request_mode,
        dm_tran_locks.request_status
    FROM sys.dm_tran_locks
        LEFT JOIN sys.partitions ON partitions.hobt_id = dm_tran_locks.resource_associated_entity_id
        LEFT JOIN sys.indexes ON indexes.OBJECT_ID = partitions.OBJECT_ID AND indexes.index_id = partitions.index_id
    WHERE resource_associated_entity_id > 0
) _
GROUP BY
    request_session_id,
    dbname,
    ObjectName,
    index_name,
    resource_type,
    request_mode,
    request_status
ORDER BY request_session_id, dbname,resource_type,  ObjectName, index_name, lock_count desc, request_mode
    --ORDER BY request_session_id, resource_associated_entity_id 
