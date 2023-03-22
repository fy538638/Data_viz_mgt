SELECT 
    tab1.Category AS Category,
    tab1.Subcategory AS Subcategory,
    CONCAT('$', FORMAT(tab1.Total_Sales, 0)) AS `2018_Sales`,
    CONCAT('$', FORMAT(tab2.Total_Sales, 0)) AS `2019_Sales`,
    CONCAT('$', FORMAT(tab3.Total_Sales, 0)) AS `2020_Sales`,
    CONCAT('$', FORMAT(tab4.Total_Sales, 0)) AS `2021_Sales`,
    CONCAT(ROUND((tab2.Total_Sales / tab1.Total_Sales - 1) * 100,
                    2),
            '%') AS change2019vs2018,
    CONCAT(ROUND((tab3.Total_Sales / tab2.Total_Sales - 1) * 100,
                    2),
            '%') AS change2020vs2019,
    CONCAT(ROUND((tab4.Total_Sales / tab3.Total_Sales - 1) * 100,
                    2),
            '%') AS change2021vs2020
FROM
    (SELECT 
        ps.Category, ps.Subcategory, SUM(ss.Sales) AS Total_Sales
    FROM
        sales ss
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    LEFT JOIN orders os ON os.OrderID = ss.OrderID
    WHERE
        os.OrderDate >= DATE('2018-01-01')
            AND os.OrderDate < DATE('2019-01-01')
    GROUP BY ps.Category , ps.Subcategory) tab1
        LEFT JOIN
    (SELECT 
        ps.Category, ps.Subcategory, SUM(ss.Sales) AS Total_Sales
    FROM
        sales ss
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    LEFT JOIN orders os ON os.OrderID = ss.OrderID
    WHERE
        os.OrderDate >= DATE('2019-01-01')
            AND os.OrderDate < DATE('2020-01-01')
    GROUP BY ps.Category , ps.Subcategory) tab2 ON tab1.Category = tab2.Category
        AND tab1.Subcategory = tab2.Subcategory
        LEFT JOIN
    (SELECT 
        ps.Category, ps.Subcategory, SUM(ss.Sales) AS Total_Sales
    FROM
        sales ss
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    LEFT JOIN orders os ON os.OrderID = ss.OrderID
    WHERE
        os.OrderDate >= DATE('2020-01-01')
            AND os.OrderDate < DATE('2021-01-01')
    GROUP BY ps.Category , ps.Subcategory) tab3 ON tab1.Category = tab3.Category
        AND tab1.Subcategory = tab3.Subcategory
        LEFT JOIN
    (SELECT 
        ps.Category, ps.Subcategory, SUM(ss.Sales) AS Total_Sales
    FROM
        sales ss
    LEFT JOIN products ps ON ss.ProductID = ps.ProductID
    LEFT JOIN orders os ON os.OrderID = ss.OrderID
    WHERE
        os.OrderDate >= DATE('2021-01-01')
            AND os.OrderDate < DATE('2022-01-01')
    GROUP BY ps.Category , ps.Subcategory) tab4 ON tab1.Category = tab4.Category
        AND tab1.Subcategory = tab4.Subcategory
ORDER BY tab1.Category , tab1.Subcategory
