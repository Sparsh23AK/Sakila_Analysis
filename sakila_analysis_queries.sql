-- ##### Customer Behavior Analysis #####
-- 1. Top Customers by Rental Count 
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(r.rental_id) AS total_rentals
FROM
    customer c
        JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id , customer_name
ORDER BY total_rentals DESC
LIMIT 5;

-- 2. Customers With No Rentals
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM
    customer c
        LEFT JOIN
    rental r ON c.customer_id = r.customer_id
WHERE
    r.rental_id IS NULL;

-- 3. Monthly Rentals Per Customer
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATE_FORMAT(r.rental_date, '%Y-%m') AS rental_month,
    COUNT(r.rental_id) AS total_rental
FROM
    customer c
        JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id , customer_name , rental_month
ORDER BY rental_month , total_rental DESC;

-- #### Store Performance Metrics ####
-- 4. Store With Highest Revenue
SELECT 
    *
FROM
    sales_by_store;
SELECT 
    s.store_id, SUM(p.amount) AS total_sales
FROM
    payment p
        JOIN
    staff st ON p.staff_id = st.staff_id
        JOIN
    store s ON st.store_id = s.store_id
GROUP BY s.store_id
ORDER BY total_sales;

-- 5. Number of Rentals by Store Per Month
SELECT 
    s.store_id,
    COUNT(r.rental_id) AS rental_count,
    DATE_FORMAT(r.rental_date, '%Y-%m') AS rental_month
FROM
    rental r
        JOIN
    staff st ON r.staff_id = st.staff_id
        JOIN
    store s ON st.store_id = s.store_id
GROUP BY s.store_id , rental_month
ORDER BY rental_month ASC;

-- #### Inventory & Film Analysis ####
-- 6. Most Rented Film
SELECT 
    f.film_id, f.title, COUNT(r.rental_id) AS total_rental
FROM
    rental r
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film f ON i.film_id = f.film_id
GROUP BY f.film_id
ORDER BY total_rental DESC;

-- 7. Films Never Rented
SELECT 
    f.film_id, f.title
FROM
    film f
        LEFT JOIN
    inventory i ON f.film_id = i.film_id
        LEFT JOIN
    rental r ON i.inventory_id = r.inventory_id
WHERE
    r.rental_id IS NULL
GROUP BY f.film_id;

 
-- 8. Category-wise Rentals
SELECT 
    c.category_id, c.name, COUNT(r.rental_id) AS total_rental
FROM
    rental r
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film f ON i.film_id = f.film_id
        JOIN
    film_category fm ON f.film_id = fm.film_id
        JOIN
    category c ON fm.category_id = c.category_id
GROUP BY c.category_id
ORDER BY total_rental DESC;

-- ####  Location-Based Insights ####
-- 9. Top Cities by Revenue
SELECT 
    ci.city_id, ci.city, SUM(p.amount) AS revenue
FROM
    payment p
        JOIN
    rental r ON p.rental_id = r.rental_id
        JOIN
    customer c ON r.customer_id = c.customer_id
        JOIN
    address a ON c.address_id = a.address_id
        JOIN
    city ci ON a.city_id = ci.city_id
GROUP BY ci.city_id
ORDER BY revenue DESC;

-- 10. Average Rentals Per Customer by Country
SELECT 
    ca.country_id,
    ca.country,
    ROUND(COUNT(r.rental_id) / COUNT(DISTINCT c.customer_id),
            2) AS average_rentals
FROM
    rental r
        JOIN
    customer c ON r.customer_id = c.customer_id
        JOIN
    address a ON c.address_id = a.address_id
        JOIN
    city ci ON a.city_id = ci.city_id
        JOIN
    country ca ON ci.country_id = ca.country_id
GROUP BY ca.country_id
ORDER BY average_rentals DESC;