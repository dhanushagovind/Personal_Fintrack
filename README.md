# FinTrack – Personal Finance Management System

## Project Overview

**FinTrack** is a personal finance management system designed to help users track income and expenses, monitor spending habits, detect overspending, and visualize financial data through an interactive dashboard.
The system integrates a database, analytics queries, and a web-based interface to provide insights that support better financial decision-making.

The project demonstrates how database systems and Python-based applications can be combined to build a small financial analytics platform.

---

# Problem Statement

Many individuals struggle to manage their personal finances due to:

* Lack of structured expense tracking
* Difficulty identifying overspending patterns
* Limited visibility into monthly spending trends
* Absence of simple analytics tools for personal budgeting

Traditional manual tracking methods are inefficient and do not provide actionable insights.
FinTrack aims to solve this problem by creating an automated finance tracking and analytics system.

---

# Project Objectives

* Develop a system to record and manage financial transactions.
* Store and organize data using a structured relational database.
* Detect overspending automatically using database triggers.
* Provide financial analytics such as monthly summaries and category-wise spending.
* Generate visual charts to help users understand spending behavior.
* Recommend budgets based on historical spending patterns.

---

# System Architecture

The system consists of three main layers:

### 1. Database Layer

The database stores financial data and performs analytics operations.

Main components:

* Tables for storing transactions and categories
* Triggers for overspending detection
* Views for financial analytics

### 2. Application Layer

Python is used to interact with the database and implement system logic.

Responsibilities:

* Insert and retrieve financial data
* Process analytics queries
* Generate financial charts

### 3. User Interface Layer

An interactive dashboard allows users to interact with the system.

Users can:

* Add transactions
* View spending summaries
* Analyze financial data
* Visualize charts and trends

---

# Database Design

## Main Tables

### transactions

Stores all financial transactions.

Fields include:

* transaction_id
* category_id
* type (income or expense)
* amount
* description
* date

### categories

Stores expense categories such as food, transport, shopping, etc.

### budgets

Stores monthly budget limits for categories.

### overspending_alerts

Stores alerts generated when spending exceeds the allocated budget.

---

# Advanced Database Features

## Triggers

Triggers automatically monitor new transactions and detect overspending.

When an expense exceeds the predefined budget, an alert is generated and stored in the `overspending_alerts` table.

## Views

Views simplify complex analytics queries.

Examples:

* monthly_expense_summary
* category_spending
* unusual_transactions
* budget_recommendation

These views provide insights without modifying the original data.

---

# Key Features

### Transaction Management

Users can add income and expense records easily.

### Expense Tracking

All financial data is stored in a structured database for analysis.

### Overspending Detection

The system automatically detects when spending exceeds the defined budget.

### Financial Analytics

Users can view summaries such as:

* Monthly expenses
* Category-wise spending
* Unusual transactions

### Financial Visualization

The system generates charts including:

* Expense distribution pie chart
* Monthly spending trend graph

### Budget Recommendation

The system calculates recommended budgets based on historical spending data.

---

# Financial Analytics

FinTrack performs several types of financial analysis:

### Monthly Expense Summary

Shows total spending for each month.

### Category Spending Analysis

Displays how much money is spent in each category.

### Unusual Transaction Detection

Identifies transactions that are significantly larger than normal spending.

---

# Budget Recommendation Logic

The system analyzes historical expense data and calculates the average spending for each category.

A small buffer is added to account for spending variations.

Formula:

Recommended Budget = Average Spending × 1.1

This helps users plan realistic budgets while avoiding frequent overspending alerts.

---

# Technologies Used

Programming Language:

* Python

Database:

* MySQL

Libraries:

* pandas
* matplotlib

User Interface:

* Gradio

Development Environment:

* Jupyter Notebook

---

# Advantages of the System

* Simple and user-friendly interface
* Automated financial tracking
* Real-time overspending detection
* Visual analytics for better understanding of expenses
* Data-driven budget planning

---

# Future Enhancements

Possible improvements include:

* Machine learning for expense prediction
* Automatic transaction category classification
* Mobile application integration
* Cloud database deployment
* Multi-user financial management

---

# Conclusion

FinTrack demonstrates how database technologies and data analytics can be used to improve personal financial management.
By combining structured data storage, automated alerts, and visual analytics, the system helps users gain better control over their spending habits and financial planning.

---

# Author
Dhanusha G
Capstone Project
Personal Finance Analytics System – Fintrack
