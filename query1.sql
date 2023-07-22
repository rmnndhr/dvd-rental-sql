/* Question 1 */
/* Find the top 10 paying customers*/
WITH topten AS (
	SELECT customer_id, SUM (amount) FROM payment
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
	)
/* Pull the necessary fields joining 2 tables for the top 10 customers */
SELECT DATE_TRUNC('month', p.payment_date) AS pay_month, 
	   c.first_name || ' ' || c.last_name AS customer_name, 
	   COUNT (*) AS pay_countpermon, SUM (amount) AS pay_amount
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
WHERE p.customer_id IN (
	SELECT customer_id FROM topten)
GROUP BY 1, 2
ORDER BY 2, 1;