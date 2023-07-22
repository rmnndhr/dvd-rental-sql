/* Question 2 */
/* Find the top 10 paying customers*/
WITH topten AS (
	SELECT customer_id, SUM (amount) FROM payment
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
	),
/* Pull the necessary fields joining 2 tables for the top 10 customers */
toppay AS (
	SELECT DATE_TRUNC('month', p.payment_date) AS pay_month, 
	   c.first_name || ' ' || c.last_name AS fullname, 
	   COUNT (*) AS pay_countpermon, SUM (amount) AS pay_amount
	FROM payment AS p
	INNER JOIN customer AS c
	ON p.customer_id = c.customer_id
	WHERE p.customer_id IN (
		SELECT customer_id FROM topten)
	GROUP BY 1, 2
	ORDER BY 2, 1
),
/* Create a lead field to populate with the leading value for the successive month 
and find the difference in payment */
paydiff AS (
	SELECT pay_month, fullname, pay_countpermon, pay_amount,
	   LEAD(pay_amount) OVER (PARTITION BY fullname ORDER BY pay_month) AS lead,
       LEAD(pay_amount) OVER (PARTITION BY fullname ORDER BY pay_month) - pay_amount AS lead_diff
	FROM toppay
	ORDER BY 2, 1
	)
/* Compare with the max value to find the customer with the maximum difference */	
SELECT pay_month, fullname, pay_amount, lead_diff,
	   CASE WHEN lead_diff = (SELECT MAX (lead_diff) FROM paydiff) THEN lead_diff
	   END AS ismaxdiff
FROM paydiff;