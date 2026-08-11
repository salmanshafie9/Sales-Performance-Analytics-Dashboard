-- ============================================
-- PROJECT: Sales Performance Analytics
-- ============================================


-- ============================================
-- 1. TOTAL REVENUE
-- ============================================

SELECT
    SUM(s.Quantity * p.UnitPrice) AS TotalRevenue
FROM Sales s
LEFT JOIN Products p
    ON s.ProductID = p.ProductID;


-- ============================================
-- 2. TOTAL PROFIT
-- ============================================

SELECT
    SUM(s.Quantity * (p.UnitPrice - p.UnitCost)) AS TotalProfit
FROM Sales s
LEFT JOIN Products p
    ON s.ProductID = p.ProductID;


-- ============================================
-- 3. REVENUE BY PRODUCT
-- ============================================

SELECT
    p.ProductName,
    SUM(s.Quantity * p.UnitPrice) AS ProductRevenue
FROM Sales s
LEFT JOIN Products p
    ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY ProductRevenue DESC;


-- ============================================
-- 4. REVENUE BY REGION
-- ============================================

SELECT
    sp.Region,
    SUM(s.Quantity * p.UnitPrice) AS RegionRevenue
FROM Sales s
LEFT JOIN Salespeople sp
    ON s.SalespersonID = sp.SalespersonID
LEFT JOIN Products p
    ON s.ProductID = p.ProductID
GROUP BY sp.Region
ORDER BY RegionRevenue DESC;


-- ============================================
-- 5. TOP 5 CUSTOMERS BY REVENUE
-- ============================================

SELECT
    c.CustomerName,
    SUM(s.Quantity * p.UnitPrice) AS CustomerRevenue
FROM Sales s
LEFT JOIN Customers c
    ON s.CustomerID = c.CustomerID
LEFT JOIN Products p
    ON s.ProductID = p.ProductID
GROUP BY c.CustomerName
ORDER BY CustomerRevenue DESC
LIMIT 5;


-- ============================================
-- 6. REVENUE BY SALESPERSON
-- ============================================

SELECT
    sp.SalespersonName,
    SUM(s.Quantity * p.UnitPrice) AS SalespersonRevenue
FROM Sales s
LEFT JOIN Products p
    ON s.ProductID = p.ProductID
LEFT JOIN Salespeople sp
    ON s.SalespersonID = sp.SalespersonID
GROUP BY sp.SalespersonName
ORDER BY SalespersonRevenue DESC;


-- ============================================
-- 7. CUSTOMER REVENUE RANKING
-- CTE + WINDOW FUNCTION
-- ============================================

WITH CustomerRevenue AS (
    SELECT
        c.CustomerName,
        SUM(s.Quantity * p.UnitPrice) AS Revenue
    FROM Sales s
    LEFT JOIN Customers c
        ON s.CustomerID = c.CustomerID
    LEFT JOIN Products p
        ON s.ProductID = p.ProductID
    GROUP BY c.CustomerName
)

SELECT
    CustomerName,
    Revenue,
    RANK() OVER (
        ORDER BY Revenue DESC
    ) AS RevenueRank
FROM CustomerRevenue
ORDER BY RevenueRank;