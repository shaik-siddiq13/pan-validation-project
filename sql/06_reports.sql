-- ============================================
-- PAN NUMBER VALIDATION PROJECT
-- STEP 6: FINAL REPORTS
-- ============================================


-- ============================================
-- 1. DATASET SUMMARY
-- ============================================

SELECT
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(DISTINCT PAN_NUMBER) AS UNIQUE_PANS,
    COUNT(*) - COUNT(DISTINCT PAN_NUMBER) AS DUPLICATE_RECORDS
FROM STG_PAN_NUMBERS_DATASET;


-- ============================================
-- 2. CLEANING SUMMARY
-- ============================================

SELECT
    COUNT(*) AS TOTAL_RECORDS,

    COUNT(*) FILTER (
        WHERE PAN_NUMBER IS NULL
    ) AS NULL_RECORDS,

    COUNT(*) FILTER (
        WHERE PAN_NUMBER <> TRIM(PAN_NUMBER)
    ) AS RECORDS_WITH_SPACES,

    COUNT(*) FILTER (
        WHERE PAN_NUMBER <> UPPER(PAN_NUMBER)
    ) AS LOWERCASE_RECORDS

FROM STG_PAN_NUMBERS_DATASET;


-- ============================================
-- 3. VALIDATION SUMMARY
-- ============================================

SELECT
    PAN_STATUS,
    COUNT(*) AS TOTAL_COUNT
FROM PAN_VALIDATION_AUDIT
GROUP BY PAN_STATUS
ORDER BY TOTAL_COUNT DESC;


-- ============================================
-- 4. VALIDATION PERCENTAGE
-- ============================================

SELECT
    PAN_STATUS,
    COUNT(*) AS TOTAL_COUNT,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS PERCENTAGE

FROM PAN_VALIDATION_AUDIT
GROUP BY PAN_STATUS
ORDER BY TOTAL_COUNT DESC;


-- ============================================
-- 5. VALID VS INVALID
-- ============================================

SELECT
    COUNT(*) FILTER (
        WHERE PAN_STATUS = 'VALID'
    ) AS VALID_PANS,

    COUNT(*) FILTER (
        WHERE PAN_STATUS = 'INVALID'
    ) AS INVALID_PANS,

    COUNT(*) FILTER (
        WHERE PAN_STATUS = 'DUPLICATE'
    ) AS DUPLICATE_PANS

FROM PAN_VALIDATION_AUDIT;


-- ============================================
-- 6. INVALID PAN REASONS
-- ============================================

SELECT
    VALIDATION_MESSAGE,
    COUNT(*) AS ERROR_COUNT
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'INVALID'
GROUP BY VALIDATION_MESSAGE
ORDER BY ERROR_COUNT DESC;


-- ============================================
-- 7. ACCEPTED PAN SUMMARY
-- ============================================

SELECT
    COUNT(*) AS TOTAL_ACCEPTED_PANS
FROM ACCEPTED_USER_PANS;


-- ============================================
-- 8. ACCEPTED PAN DETAILS
-- ============================================

SELECT
    PAN_ID,
    ORIGINAL_INPUT,
    CLEAN_PAN,
    ACCEPTED_AT
FROM ACCEPTED_USER_PANS
ORDER BY ACCEPTED_AT DESC;


-- ============================================
-- 9. COMPLETE PROJECT SUMMARY
-- ============================================

SELECT
    (SELECT COUNT(*)
     FROM STG_PAN_NUMBERS_DATASET)
        AS TOTAL_SOURCE_RECORDS,

    (SELECT COUNT(*)
     FROM PAN_VALIDATION_AUDIT
     WHERE PAN_STATUS = 'VALID')
        AS VALID_PANS,

    (SELECT COUNT(*)
     FROM PAN_VALIDATION_AUDIT
     WHERE PAN_STATUS = 'INVALID')
        AS INVALID_PANS,

    (SELECT COUNT(*)
     FROM PAN_VALIDATION_AUDIT
     WHERE PAN_STATUS = 'DUPLICATE')
        AS DUPLICATE_PANS,

    (SELECT COUNT(*)
     FROM ACCEPTED_USER_PANS)
        AS ACCEPTED_PANS;