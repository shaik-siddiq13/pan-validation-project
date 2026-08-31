-- ============================================
-- PAN NUMBER VALIDATION PROJECT
-- STEP 5: AUDIT AND VALIDATION HISTORY
-- ============================================


-- 1. VIEW ALL VALIDATION ATTEMPTS

SELECT
    AUDIT_ID,
    ORIGINAL_INPUT,
    CLEAN_PAN,
    PAN_STATUS,
    VALIDATION_MESSAGE,
    VALIDATED_AT
FROM PAN_VALIDATION_AUDIT
ORDER BY VALIDATED_AT DESC;


-- ============================================
-- 2. TOTAL NUMBER OF VALIDATION ATTEMPTS
-- ============================================

SELECT
    COUNT(*) AS TOTAL_VALIDATION_ATTEMPTS
FROM PAN_VALIDATION_AUDIT;


-- ============================================
-- 3. COUNT VALID, INVALID AND DUPLICATE PANs
-- ============================================

SELECT
    PAN_STATUS,
    COUNT(*) AS TOTAL_COUNT
FROM PAN_VALIDATION_AUDIT
GROUP BY PAN_STATUS
ORDER BY TOTAL_COUNT DESC;


-- ============================================
-- 4. VALID PAN COUNT
-- ============================================

SELECT
    COUNT(*) AS TOTAL_VALID_PANS
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'VALID';


-- ============================================
-- 5. INVALID PAN COUNT
-- ============================================

SELECT
    COUNT(*) AS TOTAL_INVALID_PANS
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'INVALID';


-- ============================================
-- 6. DUPLICATE PAN COUNT
-- ============================================

SELECT
    COUNT(*) AS TOTAL_DUPLICATE_PANS
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'DUPLICATE';


-- ============================================
-- 7. VALIDATION PERCENTAGE
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
-- 8. INVALID PAN REASONS
-- ============================================

SELECT
    VALIDATION_MESSAGE,
    COUNT(*) AS ERROR_COUNT
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'INVALID'
GROUP BY VALIDATION_MESSAGE
ORDER BY ERROR_COUNT DESC;


-- ============================================
-- 9. VIEW ALL INVALID PANs
-- ============================================

SELECT
    ORIGINAL_INPUT,
    CLEAN_PAN,
    VALIDATION_MESSAGE,
    VALIDATED_AT
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'INVALID'
ORDER BY VALIDATED_AT DESC;


-- ============================================
-- 10. VIEW ALL DUPLICATE PANs
-- ============================================

SELECT
    ORIGINAL_INPUT,
    CLEAN_PAN,
    VALIDATION_MESSAGE,
    VALIDATED_AT
FROM PAN_VALIDATION_AUDIT
WHERE PAN_STATUS = 'DUPLICATE'
ORDER BY VALIDATED_AT DESC;


-- ============================================
-- 11. VIEW ALL ACCEPTED PANs
-- ============================================

SELECT
    PAN_ID,
    ORIGINAL_INPUT,
    CLEAN_PAN,
    ACCEPTED_AT
FROM ACCEPTED_USER_PANS
ORDER BY ACCEPTED_AT DESC;


-- ============================================
-- 12. ACCEPTED PAN COUNT
-- ============================================

SELECT
    COUNT(*) AS TOTAL_ACCEPTED_PANS
FROM ACCEPTED_USER_PANS;