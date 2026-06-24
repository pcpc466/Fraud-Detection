


-- Now we need to generate the proxy transactioin IDs and Account IDs since the real data is preprocessed using PCA (Principal Component Analysis) to maintain the confidentiality, since V1 is one of the strongest PCA components, transactions with similar V1 values get grouped together as if they belong to the same "account.


WITH proxy_ids AS ( 
  SELECT 
  ROW_NUMBER() OVER(ORDER BY Time, Amount) as transaction_id, 
  CAST(ABS(ROUND(V1 * 10)) AS INT64) AS account_id, *
  FROM `creditcard-498622.creditcard_1780788446290.creditcard`
),

stats AS ( 
  SELECT STDDEV(Amount) AS std_amount,
  AVG(Amount) AS mean_amount
FROM proxy_ids
)

-- account with Z score  -- 
-- (amount - avg_amount) / std_amount > 3
SELECT p.account_id, 
ROUND((p.Amount - s.mean_amount) / s.std_amount, 2) as Zscore
FROM proxy_ids p
CROSS JOIN stats s
WHERE  ROUND((p.Amount - s.mean_amount) / s.std_amount, 2) > 3
ORDER BY Zscore;


