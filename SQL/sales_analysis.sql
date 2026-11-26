-- PROJECT OVERVIEW 
-- =====================================================
-- SALES PERFORMANCE ANALYSIS
-- Database: sales_analysis
-- Table: sales_performance_cleaned
-- Records: 7,500
-- =====================================================

-- =====================================================
-- 1. OVERALL BUSINESS KPIs
-- =====================================================
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Quantity) AS Total_Units_Sold,
    SUM(Sales) AS Total_Sales,
    SUM(Cost) AS Total_Cost,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Sales) / COUNT(*), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / COUNT(*), 2) AS Average_Profit_Per_Order,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Overall_Profit_Margin
FROM sales_performance_cleaned;

-- =====================================================
-- 2. PRODUCT PERFORMANCE
-- =====================================================
SELECT
    Product,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM sales_performance_cleaned
GROUP BY Product
ORDER BY Total_Sales DESC;

-- =====================================================
-- 3. CATEGORY PERFORMANCE
-- =====================================================
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM sales_performance_cleaned
GROUP BY Category
ORDER BY Total_Sales DESC;

-- =====================================================
-- 4. REGIONAL PERFORMANCE
-- =====================================================
SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM sales_performance_cleaned
GROUP BY Region
ORDER BY Total_Sales DESC;

-- =====================================================
-- 5. MONTHLY PERFORMANCE
-- =====================================================
SELECT
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%d-%m-%y'),
        '%Y-%m'
    ) AS Sales_Month,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales_performance_cleaned
GROUP BY
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%d-%m-%y'),
        '%Y-%m'
)
ORDER BY Sales_Month;

-- =====================================================
-- 6. PAYMENT METHOD ANALYSIS
-- =====================================================
SELECT
    Payment_Method,
    COUNT(*) AS Number_of_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales_performance_cleaned
GROUP BY Payment_Method
ORDER BY Total_Sales DESC;

-- =====================================================
-- 7. TOP CUSTOMERS
-- =====================================================
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(*) AS Number_of_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales_performance_cleaned
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================================
-- 8. REPEAT CUSTOMERS
-- =====================================================
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(*) AS Number_of_Orders,
    SUM(Sales) AS Total_Sales
FROM sales_performance_cleaned
GROUP BY Customer_ID, Customer_Name
HAVING COUNT(*) > 1
ORDER BY Number_of_Orders DESC;

-- =====================================================
-- 9. PRODUCT PROFITABILITY
-- =====================================================
SELECT
    Product,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM sales_performance_cleaned
GROUP BY Product
ORDER BY Profit_Margin DESC;

-- =====================================================
-- 10. DATA QUALITY / VALIDATION
-- =====================================================

-- Check for duplicate Order IDs
SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM sales_performance_cleaned
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Check for missing critical values
SELECT
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Product IS NULL) AS Missing_Product,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Region IS NULL) AS Missing_Region,
    SUM(Sales IS NULL) AS Missing_Sales,
    SUM(Profit IS NULL) AS Missing_Profit
FROM sales_performance_cleaned;

-- Check for invalid sales, cost and profit values
SELECT *
FROM sales_performance_cleaned
WHERE Sales <= 0
   OR Cost <= 0
   OR Profit <= 0;
   
   -- Check for invalid quantities
SELECT *
FROM sales_performance_cleaned
WHERE Quantity <= 0;
