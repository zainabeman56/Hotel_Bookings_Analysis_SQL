--Hotel_bookings analysis
--Create Table

CREATE TABLE hotel_bookings (
    hotel VARCHAR(50), 
	is_canceled INT, 
	lead_time INT,
	arrival_date_year INT, 
	arrival_date_month VARCHAR(20),
	arrival_date_week_number INT, 
	arrival_day_of_month INT,
	stays_in_weekend_nights INT,
	stays_in_week_nights INT,
	adults INT,
	children FLOAT,
	babies INT,
	meal VARCHAR(20),
	country VARCHAR(10),
	market_segment VARCHAR(30),
	distribution_channel VARCHAR(30),
	is_repeated_guest  INT,        
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type CHAR(1),
    assigned_room_type CHAR(1),
    booking_changes INT,
    deposit_type   VARCHAR(20),
    agent   FLOAT,
    company  FLOAT,
    days_in_waiting_list INT,
	customer_type  VARCHAR(30),
	adr  FLOAT,
	required_car_parking_spaces INT,
	total_of_special_requests INT,
	reservation_status VARCHAR(20),
	reservation_status_date  DATE,
	total_nights INT,
	is_family  INT
);

--Q1. Total bookings & cancellations .
SELECT
    COUNT(*) AS total_bookings,
	SUM(is_canceled) AS total_cancellations,
	COUNT(*) - SUM(is_canceled) AS confirmed_bookings
FROM hotel_bookings;

--Q2. Cancellation rate per hotel.
SELECT
   hotel,
   COUNT(*) AS total_bookings,
   SUM(is_canceled) AS cancellations,
   ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 2) AS cancellation_rate_pct
FROM hotel_bookings
GROUP BY hotel
ORDER BY cancellation_rate_pct DESC;

--Q3. which months receive the most bookings?
SELECT
    arrival_date_month,
	COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY total_bookings DESC;

--Q4. Average, min and max nightly rate
SELECT
    ROUND(AVG(adr):: numeric, 2)  AS avg_nightly_rate,
    MIN(adr)            AS cheapest_rate,
    MAX(adr)            AS most_expensive_rate
FROM hotel_bookings
WHERE is_canceled = 0
   
--Q5.Top 10 countries by confirmed bookings
SELECT 
    country,
	COUNT(*) AS total_bookings
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY country
ORDER BY total_bookings DESC
LIMIT 10;

--Q6. New guests vs returning guests
SELECT
    CASE WHEN is_repeated_guest = 1
	     THEN 'Returning Guest'
		 ELSE 'New Guest'
	END AS guest_type,
	COUNT(*)  AS total_bookings,
	ROUND(AVG(adr) :: numeric, 2) AS avg_nightly_rate
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY 
      CASE
	      WHEN is_repeated_guest = 1 THEN 'Returning Guest'
		  ELSE 'New Guest'
	  END;

--Q7. Stay duration buckets
SELECT 
    CASE 
	    WHEN total_nights = 0  THEN 'Same Day'
        WHEN total_nights BETWEEN 1 AND 3   THEN 'Short  (1-3 nights)'
        WHEN total_nights BETWEEN 4 AND 7   THEN 'Medium (4-7 nights)'
        WHEN total_nights BETWEEN 8 AND 14  THEN 'Long   (8-14 nights)'
        ELSE 'Extended (15+ nights)'
    END      AS stay_category,
    COUNT(*) AS bookings,
    ROUND(AVG(adr) :: numeric, 2) AS avg_nightly_rate
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY stay_category
ORDER BY bookings DESC;

--Q8. Cancellation rate by deposit type
SELECT 
    deposit_type ,
	COUNT(*) AS total_bookings,
	SUM(is_canceled) AS total_cancellations,
	ROUND(AVG(adr) :: numeric, 2) * 100.0/COUNT(*)  AS cancel_rate_pct
FROM hotel_bookings
GROUP BY deposit_type
ORDER BY cancel_rate_pct DESC;

--Q9. Meal plan popularity
SELECT 
    meal,
	COUNT(*) AS bookings
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY meal
ORDER BY bookings DESC;

--Q10. Average daily rate by market segment
SELECT
    market_segment,
    COUNT(*) AS bookings,
    ROUND(AVG(adr :: numeric), 2) AS avg_nightly_rate
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY market_segment
ORDER BY avg_nightly_rate DESC;
 
--Q11. Estimated revenue per hotel
SELECT
    hotel,
	COUNT(*) AS confirmed_stays,
	ROUND(SUM(adr :: numeric * total_nights), 2) AS estimated_revenue
FROM hotel_bookings
WHERE is_canceled = 0
  AND total_nights > 0
GROUP BY hotel
ORDER BY estimated_revenue DESC;

--Q12. Months with above average bookings
WITH monthly_counts AS (
     SELECT 
	     arrival_date_month,
	     COUNT(*) AS bookings
	FROM hotel_bookings
	GROUP BY arrival_date_month
)
SELECT
    arrival_date_month,
	bookings
FROM monthly_counts
WHERE bookings > (SELECT AVG(bookings) FROM monthly_counts)
ORDER BY bookings DESC;

--Q13. Room change rate
SELECT
    COUNT(*) AS total_stays,
    SUM(CASE 
            WHEN reserved_room_type != assigned_room_type
            THEN 1 
            ELSE 0 
        END) AS room_changed,
        
    ROUND(
        SUM(CASE 
                WHEN reserved_room_type != assigned_room_type
                THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*), 
        2
    ) AS change_rate_pct
FROM hotel_bookings
WHERE is_canceled = 0;

--Q14. Rank countries by bookings
SELECT 
    country,
	COUNT(*)  AS boookings,
	RANK() OVER (ORDER BY COUNT (*) DESC) AS country_rank
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY country
ORDER BY country_rank
LIMIT 15;

--Q15. Do more special requests mean fewer cancellation?
SELECT 
    total_of_special_requests  AS special_requests,
	COUNT(*)  AS  bookings,
	SUM (is_canceled) AS cancellations,
	ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 2)  AS cancel_rate_pct
FROM hotel_bookings
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;

--Q16. Meal share per hotel.
SELECT
    hotel,
	meal,
	COUNT(*)  AS bookings,
	ROUND(
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY hotel), 2) AS meal_share_pct
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY hotel,meal
ORDER BY hotel, bookings DESC;

--Q17. Booking lead-time groups vs. nightly rate
SELECT 
    CASE
        WHEN lead_time BETWEEN 0   AND 30  THEN 'Last Minute  (0-30 days)'
        WHEN lead_time BETWEEN 31  AND 90  THEN 'Early        (31-90 days)'
        WHEN lead_time BETWEEN 91  AND 180 THEN 'Advance      (91-180 days)'
        ELSE                                    'Very Advance (180+ days)'
    END AS booking_window,
	COUNT(*) AS bookings,
	ROUND(AVG(adr) :: numeric, 2) AS avg_nightly_rate
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY booking_window
ORDER BY avg_nightly_rate DESC;

 --Q18.  High-value guests
SELECT
    hotel,
    country,
    adr,
    total_nights,
    customer_type,
    COALESCE(children, 0) + babies AS kids
FROM hotel_bookings
WHERE is_canceled = 0
  AND adr > (
        SELECT AVG(adr)
        FROM hotel_bookings
        WHERE is_canceled = 0
  )
  AND total_nights >= 5
ORDER BY adr DESC
LIMIT 2;

--Q19. Month-over-month cancellation trend.
WITH monthly_data AS (
    SELECT
        arrival_date_year,
        arrival_date_month,
        SUM(is_canceled) AS cancellations
    FROM hotel_bookings
    GROUP BY arrival_date_year, arrival_date_month
)
SELECT
    arrival_date_year,
    arrival_date_month,
    cancellations,

    LAG(cancellations) OVER (
        ORDER BY arrival_date_year, arrival_date_month
    ) AS prev_month_cancellations,

    cancellations - LAG(cancellations) OVER (
        ORDER BY arrival_date_year, arrival_date_month
    ) AS change_vs_prev_month
FROM monthly_data
ORDER BY arrival_date_year, arrival_date_month;

--Q20. Full business summary dashboard.
SELECT
    COUNT(*)  AS total_bookings,
    SUM(is_canceled)  AS total_cancellations,
    ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1)  AS cancel_rate_pct,
    ROUND(AVG(adr) :: numeric, 2)   AS avg_nightly_rate,
    ROUND(AVG(total_nights) :: numeric, 1)   AS avg_stay_nights,
    SUM(is_repeated_guest)   AS returning_guests,
    SUM(is_family)   AS family_bookings,
    ROUND(SUM(adr * total_nights) :: numeric, 0)  AS total_est_revenue
FROM hotel_bookings
WHERE is_canceled = 0
