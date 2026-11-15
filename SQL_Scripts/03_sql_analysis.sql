-- Q1: Overall Customer Churn Rate

SELECT
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN churned = 'yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN churned = 'no' THEN 1
        ELSE 0
    END) AS active_customers,

    CAST(
        SUM(CASE WHEN churned = 'yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage

FROM clean_subscriptions;




-- Q2: Churn Rate by Subscription Type

SELECT
    plan_type,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN churned = 'yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    CAST(
        SUM(CASE WHEN churned = 'yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage

FROM clean_subscriptions
GROUP BY plan_type
ORDER BY churn_rate_percentage DESC;



-- Q3: Churn Rate by Acquisition Channel

SELECT
    acquisition_channel,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN churned = 'yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    CAST(
        SUM(CASE WHEN churned = 'yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage

FROM clean_subscriptions
GROUP BY acquisition_channel
ORDER BY churn_rate_percentage DESC;



-- Q4: Churn Rate by Plan Tier

SELECT
    plan_tier,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN churned = 'yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    CAST(
        SUM(CASE WHEN churned = 'yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage

FROM clean_subscriptions
GROUP BY plan_tier
ORDER BY churn_rate_percentage DESC;



-- Q5: Churn Rate by Primary Device

SELECT
    primary_device,
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN churned = 'yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    CAST(
        SUM(CASE WHEN churned = 'yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage

FROM clean_subscriptions
GROUP BY primary_device
ORDER BY churn_rate_percentage DESC;



-- Q6: Churn Rate by Age Group

SELECT
age_group
,COUNT(*) as TOTAL_CUSTOMERS
,SUM(CASE 
        WHEN CHURNED = 'YES' THEN 1
        ELSE 0
      END ) AS CHURNED_CUSTOMERS
,CAST(SUM(CASE 
        WHEN CHURNED = 'YES' THEN 1.0
        ELSE 0
      END )*100 / COUNT(*) AS decimal(10,2)
      ) AS CHURN_RATE_PER
FROM clean_subscriptions
GROUP BY age_group


-- Q7: Average Monthly Price by Churn Status

SELECT
    churned,
    COUNT(*) AS total_customers,
    CAST(AVG(monthly_price) AS DECIMAL(10,2)) AS average_monthly_price,
    CAST(MIN(monthly_price) AS DECIMAL(10,2)) AS minimum_price,
    CAST(MAX(monthly_price) AS DECIMAL(10,2)) AS maximum_price

FROM clean_subscriptions
GROUP BY churned
ORDER BY churned;



-- Q8: Distribution of Cancellation Reasons

SELECT
    cleaned_cancel_reason,
    COUNT(*) AS churned_customers,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS percentage_of_churned

FROM clean_subscriptions
WHERE churned = 'yes'
GROUP BY cleaned_cancel_reason
ORDER BY churned_customers DESC;



-- Q9: Customer Engagement and Churn
-- Step 1: Calculate average usage per customer

WITH customer_engagement AS
(
    SELECT
        customer_id,

        AVG(CAST(workouts_completed AS DECIMAL(10,2)))
            AS avg_workouts,

        AVG(CAST(minutes_active AS DECIMAL(10,2)))
            AS avg_active_minutes,

        AVG(CAST(classes_booked AS DECIMAL(10,2)))
            AS avg_classes,

        AVG(CAST(support_tickets AS DECIMAL(10,2)))
            AS avg_support_tickets

    FROM clean_usage
    GROUP BY customer_id
)

SELECT
    churned,
    COUNT(*) AS total_customers,

    CAST(AVG(avg_workouts) AS DECIMAL(10,2))
        AS avg_workouts,

    CAST(AVG(avg_active_minutes) AS DECIMAL(10,2))
        AS avg_active_minutes,

    CAST(AVG(avg_classes) AS DECIMAL(10,2))
        AS avg_classes,

    CAST(AVG(avg_support_tickets) AS DECIMAL(10,2))
        AS avg_support_tickets

FROM customer_engagement ce
INNER JOIN clean_subscriptions cs
    ON ce.customer_id = cs.customer_id

GROUP BY churned
ORDER BY churned;



-- Q10: Monthly Customer Churn Trend

SELECT
    DATEFROMPARTS(
        YEAR(churn_date),
        MONTH(churn_date),
        1
    ) AS churn_month,

    COUNT(*) AS churned_customers

FROM clean_subscriptions
WHERE churned = 'yes'
  AND churn_date IS NOT NULL

GROUP BY
    YEAR(churn_date),
    MONTH(churn_date)

ORDER BY churn_month;



-- Final Validation 1: Record Counts and Unique Customers

SELECT
    'clean_subscriptions' AS table_name,
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM clean_subscriptions

UNION ALL

SELECT
    'clean_usage' AS table_name,
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM clean_usage;



-- Final Validation 2: Check unmatched customers

SELECT
    COUNT(*) AS unmatched_usage_records
FROM clean_usage u
LEFT JOIN clean_subscriptions s
    ON u.customer_id = s.customer_id
WHERE s.customer_id IS NULL;



-- Final Validation 3: Check duplicate customer-month records

SELECT
    customer_id,
    usage_month,
    COUNT(*) AS record_count
FROM clean_usage
GROUP BY customer_id, usage_month
HAVING COUNT(*) > 1;