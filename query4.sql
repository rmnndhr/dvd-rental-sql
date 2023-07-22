/* Question 4 */
/* Find the district, the total number of rentals by film category by state for US */
WITH state AS (
	SELECT a.district, cty.city, cat.name, COUNT (*) AS rental_count 
	FROM rental AS r
	INNER JOIN payment AS p
	ON r.rental_id = p.rental_id
	INNER JOIN customer AS c
	ON p.customer_id = c.customer_id
	INNER JOIN address AS a
	ON c.address_id = a.address_id
	INNER JOIN city AS cty
	ON a.city_id = cty.city_id
	INNER JOIN country AS cy
	ON cty.country_id = cy.country_id
	INNER JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f
	ON i.film_id = f.film_id
	INNER JOIN film_category as fc
	ON f.film_id = fc.film_id
	INNER JOIN category AS cat
	ON fc.category_id = cat.category_id
	WHERE cy.country = 'United States'
	GROUP BY 1, 2, 3
),
/* Find MAX total number of movie rental by state */
staterental AS (
	SELECT district, SUM (rental_count) AS state_count
	FROM state
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1
),
/* Find MAX total number of movie rental by city of MAX state */
cityrental AS (
	SELECT district, city, SUM (rental_count) AS city_count
	FROM state
	WHERE district = (SELECT district FROM staterental)
	GROUP BY 1, 2
)
/* List the cities of the MAX state along with the rank of city with the highest Foreign to total movies ratio */
SELECT cr.district, cr.city, COALESCE(s.rental_count, 0) AS foreign_rental, cr.city_count AS total_rental,
	RANK() OVER (ORDER BY (COALESCE(s.rental_count, 0)/cr.city_count))
FROM state AS s
RIGHT JOIN cityrental AS cr
ON s.city = cr.city AND s.name = 'Foreign'
ORDER BY 2;
