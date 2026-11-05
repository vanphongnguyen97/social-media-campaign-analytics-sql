-- BUSINESS CASE 1 — Platform Effectiveness (CTR by Platform)
SELECT
    sp.Platform_Name,
    COUNT(DISTINCT av.ViewID) AS Total_Views,
    COUNT(DISTINCT ac.ClickID) AS Total_Clicks,
    CASE 
        WHEN COUNT(DISTINCT av.ViewID) = 0 THEN 0
        ELSE ROUND(
            COUNT(DISTINCT ac.ClickID) * 100.0 / COUNT(DISTINCT av.ViewID),
            2
        )
    END AS CTR
FROM Social_Media_Platform sp
LEFT JOIN Advertisement ad 
    ON sp.PlatformID = ad.PlatformID
LEFT JOIN Ad_View av 
    ON ad.AdID = av.AdID
LEFT JOIN Ad_Click ac 
    ON ad.AdID = ac.AdID
GROUP BY sp.Platform_Name;


-- BUSINESS CASE 2 — Conversion Rate (Click → Purchase)
SELECT 
    ac.AdID,
    COUNT(DISTINCT ac.ClickID) AS Clicks,
    COUNT(DISTINCT co.OrderID) AS Orders,
    ROUND(
        COUNT(DISTINCT co.OrderID) * 100.0 / NULLIF(COUNT(DISTINCT ac.ClickID),0),
        2
    ) AS Conversion_Rate
FROM Ad_Click ac
LEFT JOIN Customer_Order co 
    ON ac.AdID = co.AdID
    AND ac.CustomerID = co.CustomerID
    AND co.Order_Date >= DATE(ac.Click_Time)
GROUP BY ac.AdID;

-- BUSINESS CASE 3 — Organic vs Ad-Driven Orders
SELECT 
    CASE 
        WHEN AdID IS NULL THEN 'Organic'
        ELSE 'Ad-Driven'
    END AS Order_Type,
    COUNT(*) AS Total_Orders,
    SUM(Total_Amount) AS Revenue
FROM Customer_Order
GROUP BY Order_Type;


-- BUSINESS CASE 4: Campaign ROI (Revenue per Ad)
SELECT 
    ad.AdID,
    ad.Campaign_Name,
    COUNT(DISTINCT co.OrderID) AS Orders,
    SUM(co.Total_Amount) AS Revenue
FROM Advertisement ad
LEFT JOIN Customer_Order co ON ad.AdID = co.AdID
GROUP BY ad.AdID, ad.Campaign_Name;



-- BUSINESS CASE 5 — Product Performance (Ad-Driven Sales)
SELECT 
    p.Product_Name,
    SUM(od.Quantity) AS Total_Quantity_Sold,
    SUM(od.Quantity * od.Unit_Price) AS Total_Revenue
FROM Customer_Order co
JOIN Order_Detail od 
    ON co.OrderID = od.OrderID
JOIN Product p 
    ON od.ProductID = p.ProductID
WHERE co.AdID IS NOT NULL   -- only ad-driven purchases
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC;

 
-- BUSINESS CASE 6 — Multi-Ad Exposure Impact
SELECT 
    av.CustomerID,
    COUNT(DISTINCT av.AdID) AS Ads_Viewed,
    SUM(co.Total_Amount) AS Total_Spending
FROM Ad_View av
LEFT JOIN Customer_Order co 
    ON av.CustomerID = co.CustomerID
GROUP BY av.CustomerID
ORDER BY Ads_Viewed DESC;


-- BUSINESS CASE 7 — New vs Existing Customers
SELECT 
    CASE 
        WHEN c.Registration_Date >= '2024-05-01' THEN 'New Customer'
        ELSE 'Existing Customer'
    END AS Customer_Type,
    COUNT(DISTINCT co.CustomerID) AS Total_Customers,
    SUM(co.Total_Amount) AS Revenue
FROM Customer c
JOIN Customer_Order co ON c.CustomerID = co.CustomerID
WHERE co.AdID IS NOT NULL
GROUP BY Customer_Type;


