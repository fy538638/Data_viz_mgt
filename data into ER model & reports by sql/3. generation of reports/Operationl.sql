SELECT 
    tab1.RegionName,
    tab1.State,
    tab1.Category,
    CONCAT('$', FORMAT(tab2.Total_Sales, 0)) AS Total_Sales,
    tab2.Quantity,
    CONCAT('$', FORMAT(tab2.Total_Profit, 0)) AS Total_Profit,
    CONCAT('$', FORMAT(tab2.Total_Expenses, 0)) AS Total_Expenses,
    CONCAT(ROUND((tab2.Total_Profit / tab2.Total_Sales) * 100,
                    2),
            '%') AS Gross_Profit_Margin
FROM
    (SELECT 
        rg.RegionName, ad.State, ps.Category
    FROM
        orders os
    LEFT JOIN address ad ON os.PostalCode = ad.PostalCode
    LEFT JOIN region rg ON ad.RegionCode = rg.RegionCode
    LEFT JOIN sales ss ON os.OrderID = ss.OrderID
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    GROUP BY rg.RegionName , ad.State , ps.Category) tab1
        LEFT JOIN
    (SELECT 
        rg.RegionName,
            ad.State,
            ps.Category,
            ROUND(SUM(ss.Sales), 0) AS Total_Sales,
            ROUND(SUM(ss.Quantity), 0) AS Quantity,
            ROUND(SUM(ss.Profit), 0) AS Total_Profit,
            ROUND(SUM(ss.CostofSales), 0) AS Total_Expenses
    FROM
        orders os
    LEFT JOIN address ad ON os.PostalCode = ad.PostalCode
    LEFT JOIN region rg ON ad.RegionCode = rg.RegionCode
    LEFT JOIN sales ss ON os.OrderID = ss.OrderID
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    GROUP BY rg.RegionName , ad.State , ps.Category) tab2 ON tab1.RegionName = tab2.RegionName
        AND tab1.State = tab2.State
        AND tab1.Category = tab2.Category;
