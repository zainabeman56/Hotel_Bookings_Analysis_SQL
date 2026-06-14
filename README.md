# 🏨 Hotel Booking Data Analysis (SQL Project)

## 📌 Project Overview

This project focuses on analyzing hotel booking data using SQL. The goal is to extract meaningful insights such as booking trends, cancellation patterns, guest behavior, and high-value customers.

The dataset contains information about hotel reservations including booking dates, customer details, room types, pricing, and cancellations.

---

## 🎯 Objectives

* Analyze total bookings and cancellations
* Identify monthly booking trends
* Calculate cancellation rates
* Compare new vs returning guests
* Detect high-value customers
* Understand month-over-month changes

---

## 🗂️ Dataset

The dataset used in this project is stored in a CSV file and includes fields such as:

* Hotel type
* Booking status (canceled / not canceled)
* Arrival date (year, month, day)
* Number of adults, children, babies
* Room types (reserved vs assigned)
* Customer type
* ADR (Average Daily Rate)
* Total nights stayed

---

## 🛠️ Tools & Technologies

* SQL (for data analysis)
* CSV dataset
* Database system (e.g., PostgreSQL / MySQL)

---

## 🧠 Key SQL Concepts Used

* SELECT, WHERE, GROUP BY, ORDER BY
* Aggregate functions (COUNT, SUM, AVG)
* CASE statements
* Subqueries
* Common Table Expressions (WITH clause)
* Window functions (LAG)
* COALESCE for handling NULL values

---

## 📊 Analysis & Queries

### 1. Total Bookings & Cancellations

* Calculated total bookings
* Identified cancellation count and confirmed bookings

---

### 2. Cancellation Rate per Hotel

* Compared cancellation percentage across hotels

---

### 3. Monthly Booking Trends

* Identified which months receive the most bookings

---

### 4. New vs Returning Guests

* Classified guests using CASE
* Compared booking counts and average rates

---

### 5. High-Value Guests

* Filtered guests with:

  * Above-average ADR
  * Long stays (5+ nights)
* Selected top customers

---

### 6. Month-over-Month Cancellation Trend

* Used LAG() window function
* Compared cancellations with previous month

---

## 📈 Key Insights

* Certain months have significantly higher booking volume
* Cancellation rates vary by hotel
* Returning guests may have different booking behavior
* High-value guests tend to stay longer and pay higher rates
* Month-over-month analysis helps identify trends in cancellations

---

## 📁 Repository Structure

* `hotel_bookings.csv` → Dataset
* `hotel_bookings_analysis.sql` → SQL queries
* `README.md` → Project documentation

---

## 🚀 How to Use

1. Import the CSV dataset into your database
2. Create the table using provided SQL script
3. Run the queries step by step
4. Analyze results

---

## ⭐ Conclusion

This project demonstrates how SQL can be used to perform real-world data analysis. It covers essential concepts required for data analyst roles and provides insights into hotel booking behavior.

---
