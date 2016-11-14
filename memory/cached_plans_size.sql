SELECT
    Name,
    SUM(single_pages_kb + multi_pages_kb)/1024.0 MBUsed
FROM sys.dm_os_memory_clerks
WHERE name LIKE '%plan%'
GROUP BY Name

select cp.cacheobjtype, cp.objtype, 
  sum(cast(cp.size_in_bytes as DECIMAL(19,4)))/1024/1024 as sizeMB,
  count(*) as [count]
from sys.dm_exec_cached_plans as cp
group by cp.cacheobjtype, cp.objtype
ORDER BY sizeMB DESC;
