-- ============================================
-- PAN NUMBER VALIDATION PROJECT
-- STEP 3: PAN VALIDATION
-- ============================================


-- 1. CHECK PAN LENGTH

SELECT
    CLEAN_PAN,
    LENGTH(CLEAN_PAN) AS PAN_LENGTH
FROM CLEAN_PAN_NUMBERS;


-- 2. FIND PANs WITH INVALID LENGTH

SELECT
    CLEAN_PAN,
    LENGTH(CLEAN_PAN) AS PAN_LENGTH
FROM CLEAN_PAN_NUMBERS
WHERE LENGTH(CLEAN_PAN) <> 10;


-- A VALID PAN MUST CONTAIN EXACTLY 10 CHARACTERS


-- 3. CHECK COMPLETE PAN FORMAT

-- Format:
-- AAAAA9999A
-- First 5 characters  -> Alphabets
-- Next 4 characters   -> Numbers
-- Last character      -> Alphabet

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE CLEAN_PAN !~ '^[A-Z]{5}[0-9]{4}[A-Z]$';


-- 4. CHECK FIRST 5 CHARACTERS

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE SUBSTRING(CLEAN_PAN, 1, 5) !~ '^[A-Z]{5}$';


-- 5. CHECK CHARACTERS 6-9

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE SUBSTRING(CLEAN_PAN, 6, 4) !~ '^[0-9]{4}$';


-- 6. CHECK LAST CHARACTER

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE SUBSTRING(CLEAN_PAN, 10, 1) !~ '^[A-Z]$';


-- ============================================
-- 7. CHECK ADJACENT REPEATED ALPHABETS
-- ============================================

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE
    SUBSTRING(CLEAN_PAN,1,1) = SUBSTRING(CLEAN_PAN,2,1)
 OR SUBSTRING(CLEAN_PAN,2,1) = SUBSTRING(CLEAN_PAN,3,1)
 OR SUBSTRING(CLEAN_PAN,3,1) = SUBSTRING(CLEAN_PAN,4,1)
 OR SUBSTRING(CLEAN_PAN,4,1) = SUBSTRING(CLEAN_PAN,5,1);


-- ============================================
-- 8. CHECK ADJACENT REPEATED DIGITS
-- ============================================

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE
    SUBSTRING(CLEAN_PAN,6,1) = SUBSTRING(CLEAN_PAN,7,1)
 OR SUBSTRING(CLEAN_PAN,7,1) = SUBSTRING(CLEAN_PAN,8,1)
 OR SUBSTRING(CLEAN_PAN,8,1) = SUBSTRING(CLEAN_PAN,9,1);


-- ============================================
-- 9. CHECK ALPHABET SEQUENCES
-- ============================================

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE
       SUBSTRING(CLEAN_PAN,1,5) IN
       (
           'ABCDE',
           'BCDEF',
           'CDEFG',
           'DEFGH',
           'EFGHI',
           'FGHIJ',
           'GHIJK',
           'HIJKL',
           'IJKLM',
           'JKLMN',
           'KLMNO',
           'LMNOP',
           'MNOPQ',
           'NOPQR',
           'OPQRS',
           'PQRST',
           'QRSTU',
           'RSTUV',
           'STUVW',
           'TUVWX',
           'UVWXY',
           'VWXYZ'
       );


-- ============================================
-- 10. CHECK NUMERIC SEQUENCES
-- ============================================

SELECT CLEAN_PAN
FROM CLEAN_PAN_NUMBERS
WHERE SUBSTRING(CLEAN_PAN,6,4) IN
(
    '0123',
    '1234',
    '2345',
    '3456',
    '4567',
    '5678',
    '6789'
);