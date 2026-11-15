# Customer Churn Analysis

## Project Overview

This project focuses on analysing customer subscription and usage data to understand customer churn patterns and engagement behaviour.

The analysis covers 4,200 customers and their monthly usage records from July 2024 to December 2025. The project uses Microsoft Excel for initial data exploration, SQL Server for data cleaning and analysis, and Power BI for interactive dashboard development.

## Project Objectives

- Calculate the overall customer churn rate.
- Compare churn across monthly and annual subscriptions.
- Analyse churn by acquisition channel, plan tier, device and age group.
- Understand customer cancellation reasons.
- Compare engagement between active and churned customers.
- Examine monthly cancellation trends.
- Present findings through interactive Power BI dashboards.

## Tools and Technologies

- **Microsoft Excel:** Initial data exploration and preliminary analysis.
- **Microsoft SQL Server:** Data storage, cleaning, validation and SQL analysis.
- **SQL Server Management Studio (SSMS):** Executing SQL scripts and managing database tables.
- **Microsoft Power BI:** Data modelling, DAX measures and dashboard development.

## Dataset Information

The project uses two datasets:

| Dataset | Description |
|---|---|
| `subscriptions.csv` | Customer subscription details, pricing, acquisition channels and churn information |
| `usage.csv` | Monthly customer activity, workouts, active minutes, classes and support tickets |

### Dataset Size

- Total customers: 4,200
- Raw usage records: 30,685
- Cleaned usage records: 30,525
- Duplicate usage records removed: 160

## Data Cleaning and Preparation

The following cleaning and validation tasks were performed using SQL Server:

- Removed 160 extra duplicate customer-month records.
- Examined missing values in customer usage data.
- Retained missing active-minute values instead of replacing them with zero.
- Standardised cancellation reason categories.
- Created a date-format usage month column.
- Validated customer records and usage data.
- Checked for negative values and usage records before signup dates.

The original raw tables were preserved, and cleaned tables were used for analysis.

## SQL Analysis

SQL queries were used to answer business questions related to:

- Overall customer churn.
- Churn by subscription type.
- Churn by acquisition channel.
- Churn by plan tier.
- Churn by primary device.
- Churn by age group.
- Average monthly price by churn status.
- Cancellation reason analysis.
- Customer engagement analysis.
- Monthly cancellation trends.

## Power BI Dashboards

Three dashboard pages were developed.

### 1. Churn Overview

- Total customers, churned customers, active customers and churn rate.
- Churn comparison by subscription type, acquisition channel, plan tier and primary device.
- Interactive slicers for subscription type, acquisition channel and plan tier.

### 2. Customer Engagement Analysis

- Average monthly workouts.
- Average monthly active minutes.
- Average monthly classes booked.
- Average monthly support tickets.
- Comparison between active and churned customers.

### 3. Churn Drivers and Retention

- Customer cancellation reasons.
- Churn rate by age group.
- Average monthly price by churn status.
- Monthly cancellation trend.
- Key business insights.

## Key Findings

- Overall customer churn rate was **42.10%**.
- Monthly subscribers had a churn rate of **51.18%**, compared with **26.38%** for annual subscribers.
- Promo Offer customers recorded the highest acquisition-channel churn rate at **50.79%**.
- Referral customers recorded the lowest acquisition-channel churn rate at **33.81%**.
- The most common recorded cancellation reason was **Not using enough (32.24%)**.
- Active customers showed higher average monthly workouts and engagement than churned customers.
- Monthly cancellations peaked in November 2025, with **196 cancellations**.

These findings show associations and patterns in the data; they do not establish that any particular factor caused customer churn.

## Project Folder Structure

```text
customer-churn-analysis/
│
├── Dashboard_Screenshots/
├── Documentation/
├── Excel_Exploration/
├── PowerBI_Dashboard/
├── Raw_Data/
├── SQL_Scripts/
└── README.md
```

## Project Documentation

The detailed project report is available in the `Documentation` folder in PDF.

## Future Scope

- Customer segmentation based on usage and subscription behaviour.
- Exploring machine learning techniques for churn prediction.
- Studying customer retention strategies.
- Performing deeper customer usage and cohort analysis.
- Improving cancellation reason and customer feedback collection.

---

**Project:** Customer Churn Analysis  
**Tools:** Excel | SQL Server | Power BI  
**Author:** Pasupuleti Shasidhar  
**Qualification:** Master of Computer Applications (MCA)
