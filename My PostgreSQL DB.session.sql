
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


SELECT paymentmethod,count(*) as COUNTS FROM sales_data GROUP BY paymentmethod ORDER BY COUNTS DESC;