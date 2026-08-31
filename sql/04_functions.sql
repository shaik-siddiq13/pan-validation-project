-- ============================================
-- PAN NUMBER VALIDATION PROJECT
-- STEP 4: USER-DEFINED FUNCTIONS
-- ============================================


-- ============================================
-- 1. CLEAN PAN FUNCTION
-- Removes leading/trailing spaces
-- Converts lowercase letters to uppercase
-- ============================================

CREATE OR REPLACE FUNCTION clean_pan(p_pan TEXT)
RETURNS TEXT
LANGUAGE SQL
AS $$
    SELECT UPPER(TRIM(p_pan));
$$;


-- ============================================
-- 2. VALIDATE PAN FUNCTION
-- Checks the basic PAN format
-- ============================================

CREATE OR REPLACE FUNCTION validate_pan(p_pan TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN

    -- Missing or empty PAN
    IF p_pan IS NULL OR TRIM(p_pan) = '' THEN
        RETURN 'INVALID';
    END IF;


    -- PAN must contain exactly 10 characters
    IF LENGTH(p_pan) <> 10 THEN
        RETURN 'INVALID';
    END IF;


    -- Basic PAN format
    IF p_pan !~ '^[A-Z]{5}[0-9]{4}[A-Z]$' THEN
        RETURN 'INVALID';
    END IF;


    -- Adjacent repeated alphabets
    IF SUBSTRING(p_pan,1,1) = SUBSTRING(p_pan,2,1)
       OR SUBSTRING(p_pan,2,1) = SUBSTRING(p_pan,3,1)
       OR SUBSTRING(p_pan,3,1) = SUBSTRING(p_pan,4,1)
       OR SUBSTRING(p_pan,4,1) = SUBSTRING(p_pan,5,1)
    THEN
        RETURN 'INVALID';
    END IF;


    -- Adjacent repeated digits
    IF SUBSTRING(p_pan,6,1) = SUBSTRING(p_pan,7,1)
       OR SUBSTRING(p_pan,7,1) = SUBSTRING(p_pan,8,1)
       OR SUBSTRING(p_pan,8,1) = SUBSTRING(p_pan,9,1)
    THEN
        RETURN 'INVALID';
    END IF;


    -- Alphabet sequence
    IF SUBSTRING(p_pan,1,5) IN
    (
        'ABCDE','BCDEF','CDEFG','DEFGH','EFGHI',
        'FGHIJ','GHIJK','HIJKL','IJKLM','JKLMN',
        'KLMNO','LMNOP','MNOPQ','NOPQR','OPQRS',
        'PQRST','QRSTU','RSTUV','STUVW','TUVWX',
        'UVWXY','VWXYZ'
    )
    THEN
        RETURN 'INVALID';
    END IF;


    -- Numeric sequence
    IF SUBSTRING(p_pan,6,4) IN
    (
        '0123','1234','2345','3456',
        '4567','5678','6789'
    )
    THEN
        RETURN 'INVALID';
    END IF;


    RETURN 'VALID';

END;
$$;


-- ============================================
-- 3. VALIDATION MESSAGE FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION pan_validation_message(p_pan TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_pan IS NULL OR TRIM(p_pan) = '' THEN
        RETURN 'PAN is missing or empty';
    END IF;

    IF LENGTH(p_pan) <> 10 THEN
        RETURN 'PAN must contain exactly 10 characters';
    END IF;

    IF p_pan !~ '^[A-Z]{5}[0-9]{4}[A-Z]$' THEN
        RETURN 'PAN format is incorrect';
    END IF;

    IF SUBSTRING(p_pan,1,1) = SUBSTRING(p_pan,2,1)
       OR SUBSTRING(p_pan,2,1) = SUBSTRING(p_pan,3,1)
       OR SUBSTRING(p_pan,3,1) = SUBSTRING(p_pan,4,1)
       OR SUBSTRING(p_pan,4,1) = SUBSTRING(p_pan,5,1)
    THEN
        RETURN 'Adjacent repeated alphabets are not allowed';
    END IF;

    IF SUBSTRING(p_pan,6,1) = SUBSTRING(p_pan,7,1)
       OR SUBSTRING(p_pan,7,1) = SUBSTRING(p_pan,8,1)
       OR SUBSTRING(p_pan,8,1) = SUBSTRING(p_pan,9,1)
    THEN
        RETURN 'Adjacent repeated digits are not allowed';
    END IF;

    IF SUBSTRING(p_pan,1,5) IN
    (
        'ABCDE','BCDEF','CDEFG','DEFGH','EFGHI',
        'FGHIJ','GHIJK','HIJKL','IJKLM','JKLMN',
        'KLMNO','LMNOP','MNOPQ','NOPQR','OPQRS',
        'PQRST','QRSTU','RSTUV','STUVW','TUVWX',
        'UVWXY','VWXYZ'
    )
    THEN
        RETURN 'Alphabet sequence is not allowed';
    END IF;

    IF SUBSTRING(p_pan,6,4) IN
    (
        '0123','1234','2345','3456',
        '4567','5678','6789'
    )
    THEN
        RETURN 'Numeric sequence is not allowed';
    END IF;

    RETURN 'PAN is valid';

END;
$$;


-- ============================================
-- 4. PROCESS PAN SUBMISSION FUNCTION
-- Used by the Python application
-- ============================================

CREATE OR REPLACE FUNCTION process_pan_submission(p_pan TEXT)
RETURNS TABLE
(
    original_input TEXT,
    cleaned_pan TEXT,
    pan_status TEXT,
    message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_clean_pan TEXT;
    v_status TEXT;
    v_message TEXT;
BEGIN

    -- Clean the input
    v_clean_pan := clean_pan(p_pan);


    -- Validate the cleaned PAN
    IF validate_pan(v_clean_pan) = 'INVALID' THEN

        v_status := 'INVALID';
        v_message := pan_validation_message(v_clean_pan);


    -- Check whether PAN already exists
    ELSIF EXISTS
    (
        SELECT 1
        FROM ACCEPTED_USER_PANS a
        WHERE a.CLEAN_PAN = v_clean_pan
    ) THEN

        v_status := 'DUPLICATE';
        v_message := 'PAN already exists in the system';


    ELSE

        v_status := 'VALID';
        v_message := 'PAN is valid and can be accepted';

    END IF;


    -- Store every submission in audit table
    INSERT INTO PAN_VALIDATION_AUDIT
    (
        ORIGINAL_INPUT,
        CLEAN_PAN,
        PAN_STATUS,
        VALIDATION_MESSAGE
    )
    VALUES
    (
        p_pan,
        v_clean_pan,
        v_status,
        v_message
    );


    -- Return result to Python
    RETURN QUERY
    SELECT
        p_pan,
        v_clean_pan,
        v_status,
        v_message;

END;
$$;