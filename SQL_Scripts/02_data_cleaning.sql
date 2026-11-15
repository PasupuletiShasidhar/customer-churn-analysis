select count(*) as total_records 
from raw_subscriptions


select count(*) as total_records 
from raw_usage






SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('raw_subscriptions', 'raw_usage')
ORDER BY TABLE_NAME, ORDINAL_POSITION;







SELECT DISTINCT TOP 20
    month
FROM raw_usage
ORDER BY month;







select COUNT(*) as total_rows
, sum(
        case when TRY_CONVERT(date,month + '-01',23) is null 
        then 1
        else 0
      end ) as invaild_months 
      from raw_usage






SELECT
    customer_id,
    month,
    COUNT(*) AS duplicate_count
FROM raw_usage
GROUP BY customer_id, month
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;








SELECT
    customer_id,
    month,
    workouts_completed,
    minutes_active,
    classes_booked,
    support_tickets,
    COUNT(*) AS duplicate_count
FROM raw_usage
GROUP BY
    customer_id,
    month,
    workouts_completed,
    minutes_active,
    classes_booked,
    support_tickets
HAVING COUNT(*) > 1
ORDER BY customer_id, month;









WITH ranked_usage AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                customer_id,
                month,
                workouts_completed,
                minutes_active,
                classes_booked,
                support_tickets
            ORDER BY customer_id
        ) AS rn
    FROM raw_usage
)
SELECT
    customer_id,
    month,
    workouts_completed,
    minutes_active,
    classes_booked,
    support_tickets
INTO clean_usage
FROM ranked_usage
WHERE rn = 1;





SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM clean_usage;

select customer_id
,month
,count(*) as record_count
from clean_usage
group by customer_id,month
having count(*) > 1

select count(*) as total_rows
,sum( case 
        when minutes_active is null 
        then 1 
        else 0
    end ) as missing_minutes
from clean_usage





SELECT
    CASE
        WHEN workouts_completed > 0 OR classes_booked > 0
            THEN 'Missing Despite Activity'
        ELSE 'Missing With No Recorded Activity'
    END AS missing_category,
    COUNT(*) AS record_count
FROM clean_usage
WHERE minutes_active IS NULL
GROUP BY
    CASE
        WHEN workouts_completed > 0 OR classes_booked > 0
            THEN 'Missing Despite Activity'
        ELSE 'Missing With No Recorded Activity'
    END;




ALTER TABLE clean_usage
ADD minutes_status VARCHAR(50);

UPDATE clean_usage  
SET minutes_status =
    CASE
        WHEN minutes_active IS NOT NULL
            THEN 'Available'
        WHEN workouts_completed > 0 OR classes_booked > 0
            THEN 'Missing Despite Activity'
        ELSE 'Missing With No Recorded Activity'
    END;



    SELECT
    minutes_status,
    COUNT(*) AS record_count
FROM clean_usage
GROUP BY minutes_status;





SELECT
    churned,
    CASE
        WHEN churned = 'no' AND cancel_reason IS NULL
            THEN 'Active - No Reason'
        WHEN churned = 'no' AND cancel_reason IS NOT NULL
            THEN 'Active - Unexpected Reason'
        WHEN churned = 'yes' AND cancel_reason IS NULL
            THEN 'Churned - Missing Reason'
        ELSE 'Churned - Reason Available'
    END AS cancellation_status,
    COUNT(*) AS record_count
FROM raw_subscriptions
GROUP BY
    churned,
    CASE
        WHEN churned = 'no' AND cancel_reason IS NULL
            THEN 'Active - No Reason'
        WHEN churned = 'no' AND cancel_reason IS NOT NULL
            THEN 'Active - Unexpected Reason'
        WHEN churned = 'yes' AND cancel_reason IS NULL
            THEN 'Churned - Missing Reason'
        ELSE 'Churned - Reason Available'
    END;



    SELECT *,
    CASE
        WHEN churned = 'no' THEN 'Not Applicable'
        WHEN churned = 'yes' AND cancel_reason IS NULL
            THEN 'Not Provided'
        ELSE cancel_reason
    END AS cleaned_cancel_reason
INTO clean_subscriptions
FROM raw_subscriptions;



SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM clean_subscriptions;



SELECT
    cleaned_cancel_reason,
    COUNT(*) AS record_count
FROM clean_subscriptions
GROUP BY cleaned_cancel_reason
ORDER BY record_count DESC;




SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END) AS missing_signup_date,
    SUM(CASE WHEN monthly_price IS NULL THEN 1 ELSE 0 END) AS missing_monthly_price,
    SUM(CASE WHEN cleaned_cancel_reason IS NULL THEN 1 ELSE 0 END) AS missing_cleaned_reason
FROM clean_subscriptions;





SELECT
    customer_id,
    COUNT(*) AS record_count
FROM clean_subscriptions
GROUP BY customer_id
HAVING COUNT(*) > 1;




SELECT COUNT(*) AS unmatched_customer_records
FROM clean_usage u
LEFT JOIN clean_subscriptions s
    ON u.customer_id = s.customer_id
WHERE s.customer_id IS NULL;




SELECT
    SUM(CASE WHEN workouts_completed < 0 THEN 1 ELSE 0 END) AS negative_workouts,
    SUM(CASE WHEN minutes_active < 0 THEN 1 ELSE 0 END) AS negative_minutes,
    SUM(CASE WHEN classes_booked < 0 THEN 1 ELSE 0 END) AS negative_classes,
    SUM(CASE WHEN support_tickets < 0 THEN 1 ELSE 0 END) AS negative_support_tickets
FROM clean_usage;



SELECT
    SUM(CASE WHEN workouts_completed < 0 THEN 1 ELSE 0 END) AS negative_workouts,
    SUM(CASE WHEN minutes_active < 0 THEN 1 ELSE 0 END) AS negative_minutes,
    SUM(CASE WHEN classes_booked < 0 THEN 1 ELSE 0 END) AS negative_classes,
    SUM(CASE WHEN support_tickets < 0 THEN 1 ELSE 0 END) AS negative_support_tickets
FROM clean_usage;



SELECT
    u.customer_id,
    u.month,
    s.signup_date
FROM clean_usage u
INNER JOIN clean_subscriptions s
    ON u.customer_id = s.customer_id
WHERE EOMONTH(TRY_CONVERT(DATE, u.month + '-01')) < s.signup_date;




SELECT
    customer_id,
    month,
    COUNT(*) AS record_count
FROM clean_usage
GROUP BY customer_id, month
HAVING COUNT(*) > 1;




SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('clean_subscriptions', 'clean_usage')
ORDER BY TABLE_NAME, ORDINAL_POSITION;




ALTER TABLE clean_subscriptions
ALTER COLUMN monthly_price DECIMAL(10,2) NOT NULL;


ALTER TABLE clean_usage
ADD usage_month DATE;

UPDATE clean_usage
SET usage_month = TRY_CONVERT(DATE, month + '-01', 23);



SELECT TOP 10
    month,
    usage_month
FROM clean_usage;



SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN usage_month IS NULL THEN 1 ELSE 0 END) AS missing_usage_month,
    COUNT(DISTINCT usage_month) AS distinct_months,
    MIN(usage_month) AS first_month,
    MAX(usage_month) AS last_month
FROM clean_usage;




SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN monthly_price IS NULL THEN 1 ELSE 0 END) AS missing_prices,
    MIN(monthly_price) AS minimum_price,
    MAX(monthly_price) AS maximum_price,
    AVG(monthly_price) AS average_price
FROM clean_subscriptions;