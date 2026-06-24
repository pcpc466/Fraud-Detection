-- CREDIT CARD FRAUD DETECTIOIN -- 

-- EDA -- 

-- TOTAL FRAUD TRANSACTIONS --

SELECT COUNT(*) FROM `creditcard-498622.creditcard_1780788446290.creditcard`
WHERE Class = 1;

-- Max. amount in fraud transaction --

SELECT MAX(Amount) FROM `creditcard-498622.creditcard_1780788446290.creditcard`
WHERE Class = 1;

-- Finding mean transaction amount  (88) -- 

SELECT AVG(Amount) FROM `creditcard-498622.creditcard_1780788446290.creditcard`;

-- Median of the transaction amount (22) --

-- Median by transaction type -- 
SELECT DISTINCT Class, 
PERCENTILE_CONT(Amount, 0.5) OVER(PARTITION BY Class) AS median_amount
FROM `creditcard-498622.creditcard_1780788446290.creditcard`;

-- BY CLASS -- 
SELECT APPROX_QUANTILES(Amount, 100)[OFFSET(50)], Class
FROM `creditcard-498622.creditcard_1780788446290.creditcard`
GROUP BY Class;

-- THIS HUGE DIFFERNECE IN MEAN AND MEDIAN SHOWS THAT THERE ARE BIG OUTLIERS PRESENT, --
-- WHICH TELLS US WE MUST GIVE A LOOK ON THE STANDARD DEVIATION --

SELECT STDDEV(Amount) 
FROM `creditcard-498622.creditcard_1780788446290.creditcard`;


-- ALL THE TRANSACTION HAVING 3X STANDARD DEVAITION

SELECT Amount, Time  FROM `creditcard-498622.creditcard_1780788446290.creditcard`
GROUP BY Amount, Time
HAVING Amount > AVG(Amount) + 3 * STDDEV(Amount);


-- find out the percentage of the class distribution --

SELECT Class, COUNT(*) AS transcount,
COUNT(*) * 100 / SUM(COUNT(*)) OVER() AS percentdis
FROM `creditcard-498622.creditcard_1780788446290.creditcard`
GROUP BY Class;

-- "Shows the class imbalance and why the accuracy means almost nothing in this case." --



































