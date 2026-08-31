# 🇮🇳 PAN Number Data Cleaning & Validation System

A real-world **Data Engineering / Data Quality project** built using **PostgreSQL and Python** to clean, validate, categorize, and audit Indian PAN (Permanent Account Number) data.

This project demonstrates how raw PAN data can be processed through a structured data-quality pipeline and how a Python application can interact with PostgreSQL to validate PAN numbers entered by users.

---

## 📌 Project Overview

In real-world data engineering projects, data received from different sources can contain various data-quality issues such as:

- Duplicate records
- Leading or trailing spaces
- Lowercase characters
- Incorrect PAN formats
- Incorrect PAN lengths
- Repeated characters
- Sequential characters
- Sequential numbers
- Invalid user inputs

This project implements a complete **PAN data cleaning and validation workflow** using PostgreSQL.

The project uses a dataset containing **10,000 PAN records** and performs data-quality checks, cleaning, validation, duplicate detection, audit logging, and reporting.

A Python application is also integrated with PostgreSQL to allow users to enter PAN numbers and receive real-time validation results.

---

# 🎯 Project Objective

The main objective of this project is to build a reliable PAN data-quality and validation system that can:

1. Load raw PAN data into a staging table.
2. Identify missing values.
3. Detect duplicate PAN numbers.
4. Remove leading and trailing spaces.
5. Convert lowercase PAN characters to uppercase.
6. Validate PAN length.
7. Validate PAN format using Regular Expressions.
8. Validate individual PAN character positions.
9. Detect adjacent repeated characters.
10. Detect sequential alphabetic patterns.
11. Detect sequential numeric patterns.
12. Categorize PANs as `VALID`, `INVALID`, or `DUPLICATE`.
13. Store validation attempts in an audit table.
14. Allow users to enter PAN numbers through a Python application.
15. Accept valid PANs into a final table.
16. Generate data-quality and validation reports.

---

# 🏗️ Project Architecture

```text
                         RAW PAN DATA
                              |
                              v
                 STG_PAN_NUMBERS_DATASET
                              |
                              v
                       DATA CLEANING
                              |
                              v
                    CLEAN_PAN_NUMBERS
                              |
                              v
                     PAN VALIDATION
                              |
              +---------------+---------------+
              |               |               |
              v               v               v
           VALID           INVALID         DUPLICATE
              |               |               |
              v               v               v
     ACCEPTED_USER_PANS   Re-enter PAN     Reject PAN
              |
              v
       Validation Audit
              |
              v
     PAN_VALIDATION_AUDIT
              |
              v
        Final Reports


                USER INPUT
                    |
                    v
             Python Application
                    |
                    v
       process_pan_submission()
                    |
                    v
              PostgreSQL
