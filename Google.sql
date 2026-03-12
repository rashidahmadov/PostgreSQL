--Question 1
-- CREATE TABLE users (
--     user_id INT PRIMARY KEY,
--     user_name VARCHAR(50)
-- ); 


-- CREATE TABLE searches (
--     search_id INT PRIMARY KEY,
--     user_id INT,
--     search_date TIMESTAMP,
--     FOREIGN KEY (user_id) REFERENCES users(user_id)
-- );


-- INSERT INTO users (user_id, user_name) VALUES
-- (123, 'Alice'),
-- (265, 'Bob'),
-- (362, 'Charlie'),
-- (192, 'David'),
-- (981, 'Eve');

-- INSERT INTO searches (search_id, user_id, search_date) VALUES
-- (1, 123, '2024-06-08 00:00:00'),
-- (2, 265, '2024-06-10 00:00:00'),
-- (3, 362, '2024-06-18 00:00:00'),
-- (4, 192, '2024-07-26 00:00:00'),
-- (5, 981, '2024-07-05 00:00:00'),
-- (6, 123, '2024-06-08 00:00:01'),
-- (7, 192, '2024-06-18 00:00:01'),
-- (600, 123, '2024-07-28 00:00:00'),
-- (601, 123, '2024-07-29 00:00:00');

--Identify the Most Active Google Search Users
-- SELECT u.user_id, COUNT(s.search_id) FROM users AS u 
-- INNER JOIN searches AS s ON u.user_id = s.user_id
-- WHERE (EXTRACT(MONTH FROM s.search_date) = 6)
-- GROUP BY u.user_id
-- having count(*) > 1;


--Question 2
-- CREATE TABLE place_info (
--     place_id INT PRIMARY KEY,
--     place_name VARCHAR(100),
--     place_category VARCHAR(50)
-- );

-- CREATE TABLE maps_ugc_review (
--     content_id INT PRIMARY KEY,
--     place_id INT,
--     content_tag VARCHAR(50),
--     FOREIGN KEY (place_id) REFERENCES place_info(place_id)
-- );

-- INSERT INTO place_info (place_id, place_name, place_category) VALUES
-- (1, 'Baar Baar', 'Restaurant'),
-- (2, 'Rubirosa', 'Restaurant'),
-- (3, 'Mr. Purple', 'Bar'),
-- (4, 'La Caverna', 'Bar');

-- Insert data into the maps_ugc_review table
-- INSERT INTO maps_ugc_review (content_id, place_id, content_tag) VALUES
-- (101, 1, 'Off-topic'),
-- (110, 2, 'Misinformation'),
-- (153, 2, 'Off-topic'),
-- (176, 3, 'Harassment'),
-- (190, 3, 'Off-topic');

--Google Maps Flagged UGC
-- select DISTINCT p.place_category from place_info AS p 
-- INNER JOIN maps_ugc_review AS m ON p.place_id = m.place_id
-- WHERE m.content_tag = 'Off-topic'
-- ORDER BY p.place_category DESC;


--Question 3
-- CREATE TABLE categories (
--     category_id INT PRIMARY KEY,
--     category_name VARCHAR(100)
-- );

-- CREATE TABLE searches_3 (
--     search_id INT PRIMARY KEY,
--     user_id INT,
--     search_date TIMESTAMP,
--     category_id INT,
--     query VARCHAR(255),
--     FOREIGN KEY (category_id) REFERENCES categories(category_id)
-- );

--Insert data into the categories table
-- INSERT INTO categories (category_id, category_name) VALUES
-- (1001, 'Programming Tutorials'),
-- (2001, 'Stock Market'),
-- (3001, 'Recipes'),
-- (4001, 'Sports News');

--Insert data into the searches table
-- INSERT INTO searches_3 (search_id, user_id, search_date, category_id, query) VALUES
-- (1001, 7654, '2024-06-01 00:00:00', 3001, 'chicken recipe'),
-- (1002, 2346, '2024-06-02 00:00:00', 3001, 'vegan meal prep'),
-- (1003, 8765, '2024-06-03 00:00:00', 2001, 'google stocks'),
-- (1004, 9871, '2024-07-01 00:00:00', 1001, 'python tutorial'),
-- (1005, 8760, '2024-07-02 00:00:00', 2001, 'tesla stocks');

--Determine the Most Popular Google Search Category
-- SELECT c.category_name, EXTRACT(MONTH FROM s.search_date) AS month, COUNT(s.search_id) AS total_searches FROM searches_3 AS s 
-- INNER JOIN categories AS c ON s.category_id = c.category_id
-- WHERE EXTRACT(YEAR FROM s.search_date) = 2024
-- GROUP BY c.category_name, EXTRACT(MONTH FROM s.search_date); 


--Question 4
-- CREATE TABLE ads (
--     ad_id INT PRIMARY KEY,
--     name VARCHAR(255),
--     status VARCHAR(50),
--     impressions INT,
--     last_updated TIMESTAMP
-- );

--Insert example data into the ads table
-- INSERT INTO ads (ad_id, name, status, impressions, last_updated)
-- VALUES 
-- (1234, 'Google Phone', 'active', 600000, '2024-06-25 12:00:00'),
-- (5678, 'Google Laptop', 'inactive', 800000, '2024-05-18 12:00:00'),
-- (9012, 'Google App', 'active', 300000, '2024-04-02 12:00:00'),
-- (3456, 'Google Cloud', 'active', 700000, '2024-08-12 12:00:00'),
-- (7890, 'Google Mail', 'inactive', 550000, '2024-09-03 12:00:00');

--Filter Google Ads by Relevant Details
-- SELECT * FROM ads
-- WHERE (STATUS = 'active') AND (impressions > 500000) AND (EXTRACT(YEAR FROM last_updated) = 2024);

--Question 5
-- CREATE TABLE ad_clicks (
--     click_id INT PRIMARY KEY,
--     date DATE,
--     campaign_id INT,
--     ad_group_id INT,
--     clicks INT,
--     cost DECIMAL(10, 2)
-- );


-- INSERT INTO ad_clicks (click_id, date, campaign_id, ad_group_id, clicks, cost)
-- VALUES 
-- (4325, '2024-06-08', 1302, 2001, 50, 100.00),
-- (4637, '2024-06-10', 1403, 2002, 65, 130.00),
-- (4876, '2024-06-18', 1302, 2001, 70, 140.00),
-- (4531, '2024-07-05', 1604, 3001, 80, 200.00),
-- (4749, '2024-07-05', 1604, 2002, 75, 180.00);

-- Google Ad Campaign Performance
-- SELECT campaign_id, ad_group_id, (SUM(cost) / SUM(clicks)) AS avg_CPC
-- FROM ad_clicks
-- GROUP BY campaign_id, ad_group_id;


















