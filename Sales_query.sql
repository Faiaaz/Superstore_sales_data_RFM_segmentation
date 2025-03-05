-- see entire table
select * from superstore_db1.Superstore_Sales;


-- check total number of rows

select COUNT(*) from superstore_db1.Superstore_Sales;

-- check for NULL values in Discount column
SELECT COUNT(*) 
FROM superstore_db1.Superstore_Sales
WHERE Discount IS NULL;

-- check minimum value for Shipping_Cost column

SELECT MIN(Shipping_Cost) AS min_value
FROM superstore_db1.Superstore_Sales;

-- check for duplicate orders

SELECT Order_ID, COUNT(*) FROM superstore_db1.Superstore_Sales GROUP BY Order_ID HAVING COUNT(*) > 1;

-- check statistics for Profit column

Select   MIN(Profit) AS min_profit, MAX(Profit) AS max_profit, AVG(Profit) AS avg_profit 
FROM superstore_db1.Superstore_Sales;

-- check top selling product categories

SELECT Product_Category, SUM(Sales) AS total_sales
FROM superstore_db1.Superstore_Sales
GROUP BY Product_Category
ORDER BY total_sales DESC;

-- most profitable regions

SELECT Region, SUM(Profit) AS Total_Profit
FROM superstore_db1.Superstore_Sales
GROUP BY Region
ORDER BY Total_Profit DESC;

-- RFM segmentation
WITH RFM AS (
    SELECT 
        Customer_ID,
		DATEDIFF(CURDATE(), DATE_ADD('1900-01-01', INTERVAL MAX(Order_Date) - 2 DAY)) AS Recency,
        COUNT(Order_ID) AS Frequency,
        SUM(Profit) AS Monetary
    FROM superstore_db1.Superstore_Sales
    GROUP BY Customer_ID
),
RFM_Scored AS (
    SELECT 
        Customer_ID,
        Recency,
        Frequency,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency ASC) AS Recency_Score,  -- Lower Recency = Higher Score
        NTILE(5) OVER (ORDER BY Frequency DESC) AS Frequency_Score,  -- Higher Frequency = Higher Score
        NTILE(5) OVER (ORDER BY Monetary DESC) AS Monetary_Score  -- Higher Monetary = Higher Score
    FROM RFM
)
SELECT 
    Customer_ID,
    Recency,
    Frequency,
    Monetary,
    Recency_Score,
    Frequency_Score,
    Monetary_Score,
    CONCAT(Recency_Score, Frequency_Score, Monetary_Score) AS RFM_Score
FROM RFM_Scored
ORDER BY RFM_Score DESC;


