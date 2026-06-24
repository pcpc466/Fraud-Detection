-- Frequency Flagging -- 
-- The time is in seconds so we gonna take 3600 for 1 hour montoring parameter -- 


-- WITH proxy_ids AS ( 
--   SELECT 
--   ROW_NUMBER() OVER(ORDER BY Time, Amount) as transaction_id, 
--   CAST(ABS(ROUND(V1 * 10)) AS INT64) AS account_id, *
--   FROM `creditcard-498622.creditcard_1780788446290.creditcard`
-- )
  
--   SELECT
--   transaction_id,
--   account_id,
--   Amount,
--   Time,
--   Class,
--   COUNT(*) OVER (
--     PARTITION BY account_id
--     ORDER BY Time
--     RANGE BETWEEN CURRENT ROW AND 3600 FOLLOWING
--   ) AS txn_in_1hr_window,
--   CASE
--     WHEN COUNT(*) OVER (
--       PARTITION BY account_id
--       ORDER BY Time
--       RANGE BETWEEN CURRENT ROW AND 3600 FOLLOWING
--     ) > 5 THEN 1
--     ELSE 0
--   END AS time_flag
-- FROM proxy_ids;


WITH proxy_ids AS ( 
  SELECT 
  ROW_NUMBER() OVER(ORDER BY Time, Amount) as transaction_id, 
  CAST(ABS(ROUND(V1 * 10)) AS INT64) AS account_id, *
  FROM `creditcard-498622.creditcard_1780788446290.creditcard`
)

SELECT 
MOD(CAST (FLoor(Time/3600) AS INT64), 24) AS hour_day,
COUNTIF(Class = 1) AS fraud_count, 
SUM(IF(Class = 1, Amount, 0)) As fraud_amount
FROM proxy_ids
GROUP BY hour_day
ORDER BY fraud_amount DESC;




