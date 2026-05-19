drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

---data exploration---

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data

SELECT * FROM zepto
LIMIT 10;

--null values

SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories.

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock.

SELECT outOfStock,COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times.

SELECT name,COUNT(sku_id) as "Number  of SKUs"
FROM zepto
GROUP By name
HAVING count(sku_id)>1
ORDER BY count(sku_id)DESC;

--products with price=0.

SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp =0;

--convert paisa to rupees.

UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;
 
  
SELECT mrp,discountedSellingPrice FROM zepto

--find top 10-value products based on dis count percentage.

SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--what  are the prroducts with high mrp but out of stock.

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock =TRUE and mrp > 300
ORDER BY mrp DESC;

--calculate  estimated revenue for each  category.

SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--find all products where mrp is greater than 500 and discount is less  than 10%.

SELECT DISTINCT name,mrp,discountPercent
FROM zepto 
WHERE mrp>500 AND discountPercent <10
ORDER BY mrp DESC,discountPercent DESC;

--identify the top 5 categories offering the highest average discount percentage.

SELECT(AVG(discountPercent),2)AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


--find the price per gram for products above 100g and sort by the best value.

SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discontedSellingPrice/weighInGms,2)AS price_per_gram
FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

--group the productss into categories likee low,medium,bulk.

SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms<100 THEN 'Low'
WHEN weightInGms<5000 THEN 'MEDIUM'
END AS weight_category
FROM zepto;

--what is the total inventory weight per category.

SELECT category,
SUM(weightInGms * availableQuantity)AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
