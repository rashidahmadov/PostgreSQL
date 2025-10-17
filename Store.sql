-- Who between the ages of 30 and 50 has an income less than 50,000? (include 30 and 50 in the results)
SELECT * FROM public.customers
WHERE age BETWEEN 30 AND 50 AND income < 50000; 

-- What is the average income between the ages of 20 and 50? (Including 20 and 50)
--SELECT avg( income ) from public.customers
--WHERE age BETWEEN 20 and 50; 

--How many orders were made by customers 7888, 1082, 12808, 9623
-- select count( * ) from public.orders
-- where customerid in (7888, 1082, 12808, 9623);

-- SELECT COUNT(customerid) FROM public.customers
-- WHERE gender = 'F' OR state = 'Oregon';

-- SELECT * FROM public.customers
-- WHERE age > 44 AND income >= 100000;

-- SELECT * FROM public.customers
-- WHERE age BETWEEN 30 and 50 AND income < 50000; 

-- SELECT AVG(income) FROM public.customers
-- WHERE age BETWEEN 21 and 49; 

-- SELECT COUNT(*) FROM public.orders
-- WHERE customerid IN(7888, 1082, 12808, 9623);

-- SELECT * FROM public.customers
-- WHERE (age BETWEEN 30 AND 50) AND income < 50000;

-- SELECT AVG(income) FROM public.customers
-- WHERE age BETWEEN 20 AND 50; 

--Lesson 2
--Question: How many people's zipcodes start with 2 with the 3rd character being a 1.
-- SELECT count( * ) FROM public.customers
-- WHERE zip :: text like '2_1%';

--Question: How many people's zipcode have a 2 in it?.
-- SELECT * FROM public.customers
-- WHERE CAST(zip as text) like '%2%'

--comparisons
-- Select people either under 30 or over 50 with an income above 50000 that are from either Japan or Australia or US
-- SELECT * FROM public.customers
-- WHERE (age < 30 OR age > 50) AND (income > 50000) AND country IN('Japan', 'Australia', 'US'); 

--What was our total sales in June of 2004 for total amount over 100 dollars?
-- select sum( totalamount ) from orders
-- where extract(year from orderdate) = 2024 and (EXTRACT(month from orderdate) = 6) and (totalamount > 100); 

--dates
--How many orders were made in January 2004?
--SELECT COUNT(*) FROM public.orders
--WHERE EXTRACT(YEAR FROM orderdate) = 2004 
--AND EXTRACT(MONTH FROM orderdate) = 1; 

--Lesson 3
--joins
--Question: Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
--SELECT * FROM public.orders AS o 
--left join public.customers AS c 
--ON o.customerid = c.customerid 
--WHERE c.state IN('OH', 'NY', 'OR'); 

--SELECT * from orders 
--inner join customers using(customerid)
--Where state in ('OH', 'NY', 'OR')

--Question: Show me the inventory for each product
--SELECT * FROM public.products AS p 
--RIGHT JOIN public.inventory AS i 
--ON p.prod_id = i.prod_id;  

--select title, quan_in_stock from products
--inner join inventory USING(prod_id) 

--Lesson 5 and 6
--row_number()
--Find the average price for each category and then subtract the item’s price from its category’s price 
-- SELECT category, price, 
--     AVG(price) OVER (PARTITION BY category) AS avg_price, 
--     price - AVG(price) OVER (PARTITION BY category) AS price_difference
-- FROM public.products;

--Find the most expensive product for each category
-- SELECT category, price, most_expensive_product 
-- FROM (
--     SELECT c.category, p.price, ROW_NUMBER() OVER(PARTITION BY c.category ORDER BY p.price DESC) AS most_expensive_product 
--     FROM public.categories AS c
--     INNER JOIN public.products AS p ON c.category = p.category
-- )
-- WHERE most_expensive_product = 1; 

--Find the most expensive product for each category
-- SELECT * 
-- FROM (
--     SELECT *, ROW_NUMBER() OVER(PARTITION BY c.category ORDER BY p.price DESC) AS most_expensive_product 
--     FROM public.categories AS c
--     INNER JOIN public.products AS p ON c.category = p.category
-- )
-- WHERE most_expensive_product <= 1; 


--Lesson 7
--conditionals
--Create a case statement that's named "price class" where if a product is over 20 dollars you show 'expensive
SELECT prod_id, 
(CASE
    WHEN price > 20 THEN 'expensive'
    WHEN price BETWEEN 10 AND 20 THEN 'average'
    ELSE 'cheap'
    END) AS price_class
FROM public.products; 

--Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
SELECT * FROM public.orders AS o 
INNER JOIN public.customers AS c ON o.customerid = c.customerid
WHERE c.state IN('OH', 'NY', 'OR'); 



-- SELECT income as total_sales
-- from public.customers
-- where phone between '2004-06-01' and '2004-06-20'
-- and income > 100;
-- select count( * ) from public.reorder;
-- 
-- SELECT state, count(customerid) AS total_customers
-- FROM customers
-- GROUP BY state
-- ORDER BY total_customers DESC; 
-- 
-- SELECT COUNT(*) AS total_customers
-- FROM customers
-- WHERE SUBSTRING(email FROM 3 FOR 1) = 'H';
-- 
-- SELECT SUM(transaction_amount) AS total_transactions
-- FROM orders
-- WHERE customer_id IN (
--     SELECT DISTINCT customer_id
--     FROM orders
--     ORDER BY customer_id
--     LIMIT 100
-- );
-- 
-- SELECT 
--     category,
--     price,
--     AVG(price) OVER (PARTITION BY category) AS average_price_per_category
-- FROM 
--     products;                  
--   

-- 1) Calculate the total number of customers in each state
SELECT state, count(*) FROM customers
GROUP BY state

--5) What is the total amount of transactions of first 100 customers in orders table?
SELECT sum(totalamount) FROM
(SELECT * FROM orders
WHERE orderid < 101)

--6) Show product_id, category, product's name, it's price and average price for each product based on their category
SELECT prod_id, category, title, price, avg(price) OVER(PARTITION BY category) FROM products

