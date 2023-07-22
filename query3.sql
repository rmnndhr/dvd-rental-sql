/* Question 3 */
/* Find the district, the total number of rentals by film category by state for US */
WITH state AS (
	SELECT a.district, cat.name, COUNT (*) AS rental_count 
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
	GROUP BY 1, 2
),
/* Find total number of move rental by state */
staterental AS (
	SELECT district, SUM (rental_count) AS state_count
	FROM state
	GROUP BY 1
)
/* Find if customers in every state rent out Foreign movies */
SELECT sr.district AS state, s.rental_count AS foreign_rental, sr.state_count AS total_rental
FROM state AS s
RIGHT JOIN staterental AS sr
ON s.district = sr.district AND s.name = 'Foreign'
ORDER BY 1;