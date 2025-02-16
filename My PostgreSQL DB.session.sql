
-- Create table sales_data--
DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
    TransactionID SERIAL PRIMARY KEY,
    CustomerID NUMERIC(10,2),  
    TransactionDate DATE,
    TransactionAmount NUMERIC(10,2),  
    PaymentMethod VARCHAR(30),
    Quantity INT,
    DiscountPercent NUMERIC(10,2),
    City VARCHAR(30),
    StoreType VARCHAR(30),
    CustomerAge NUMERIC(10,2), 
    CustomerGender VARCHAR(10),
    LoyaltyPoints INT,
    ProductName VARCHAR(30),
    Region VARCHAR(15),
    Returned VARCHAR(5),
    FeedbackScore INT, 
    ShippingCost NUMERIC(10,2),
    DeliveryTimeDays NUMERIC(10,2),  
    IsPromotional VARCHAR(5)
);

COPY sales_data FROM '/var/lib/postgresql/assessment_dataset.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM sales_data LIMIT 5;




-- Understand how frequently customers appear in the dataset --  
SELECT 
    COUNT(customerid) AS total_customers,
    COUNT(DISTINCT customerid) AS unique_customers
FROM sales_data;




-- find most customer preferred payment method--
SELECT paymentmethod,count(*) as COUNTS FROM sales_data GROUP BY paymentmethod ORDER BY COUNTS DESC;






----Total sales and Average sales---
SELECT sum(TRANSACTIONAMOUNT) as total_sales,AVG(transactionamount) as Average_sales FROM sales_data;

SELECT count(*) FROM sales_data;






-- Find the productnames--------------------------------------------
SELECT DISTINCT productname FROM sales_data;





--- Find the most popular product among frequent customers (customers with more than 10 orders)--

WITH FrequentCustomers AS (
    SELECT customerid, COUNT(customerid) AS order_count
    FROM sales_data
    GROUP BY customerid
    HAVING COUNT(customerid) > 10 -- 10 is the threshold for frequent customers
    ORDER BY order_count DESC
),


CustomerTopProduct AS (
    SELECT ProductName, customerid, COUNT(ProductName) AS product_count
    FROM sales_data
    WHERE customerid IN (SELECT customerid FROM FrequentCustomers)
    GROUP BY ProductName, customerid
    ORDER BY product_count DESC
    
)
SELECT * FROM CustomerTopProduct;

------------------------------------------------------------------------------------------------------------





---- Create AGE Group column-----------------------------------
ALTER TABLE sales_data ADD COLUMN AgeGroup VARCHAR(10);


UPDATE sales_data
SET AgeGroup = 
    CASE 
        WHEN CustomerAge < 18 THEN 'Below 18'
        WHEN CustomerAge BETWEEN 18 AND 24 THEN '18-24'
        WHEN CustomerAge BETWEEN 25 AND 34 THEN '25-34'
        WHEN CustomerAge BETWEEN 35 AND 54 THEN '35-54'
        WHEN CustomerAge BETWEEN 55 AND 74 THEN '55-74'
        WHEN CustomerAge >= 75 THEN '75+'
        ELSE 'Unknown'
    END;



SELECT AgeGroup, COUNT(AgeGroup) AS AgeGroupCount FROM sales_data GROUP BY AgeGroup ORDER BY AgeGroupCount DESC;

------------------------------------------------------------------------------------------------------------


-- Top best-selling products Increasing order------


SELECT 
    ProductName, 
    SUM(Quantity) AS TotalQuantitySold
FROM sales_data 
GROUP BY ProductName
ORDER BY TotalQuantitySold DESC
; 





--------------------------------------Find First 3 popular products in each month----------------------------------

WITH MonthlyProductSales AS (
    SELECT 
        DATE_TRUNC('month', TransactionDate) AS Month,
        ProductName,
        SUM(Quantity) AS TotalQuantitySold,
        RANK() OVER (PARTITION BY DATE_TRUNC('month', TransactionDate) ORDER BY SUM(Quantity) DESC) AS rnk
    FROM sales_data
    GROUP BY Month, ProductName
)



SELECT Month, ProductName, TotalQuantitySold
FROM MonthlyProductSales
WHERE rnk in (1,2,3)
ORDER BY Month;
