import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()


# ==========================================
# CONNECT TO POSTGRESQL
# ==========================================

conn = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    port=os.getenv("DB_PORT")
)

print("PostgreSQL connection successful!")


# Create cursor
cursor = conn.cursor()


# ==========================================
# PAN VALIDATION APPLICATION
# ==========================================

while True:

    pan = input("\nEnter PAN number: ")

    # Call PostgreSQL function
    cursor.execute(
        "SELECT * FROM process_pan_submission(%s);",
        (pan,)
    )

    result = cursor.fetchone()

    # Get result values
    original_input = result[0]
    cleaned_pan = result[1]
    status = result[2]
    message = result[3]

    # Display result
    print("\n--------------------------------")
    print("Original Input :", original_input)
    print("Cleaned PAN    :", cleaned_pan)
    print("Status         :", status)
    print("Message        :", message)
    print("--------------------------------")


    # ==========================================
    # VALID PAN
    # ==========================================

    if status == "VALID":

        choice = input(
            "\nDo you want to accept this PAN? (yes/no): "
        )

        if choice.lower() == "yes":

            try:

                cursor.execute(
                    """
                    INSERT INTO ACCEPTED_USER_PANS
                    (ORIGINAL_INPUT, CLEAN_PAN)
                    VALUES (%s, %s)
                    """,
                    (original_input, cleaned_pan)
                )

                conn.commit()

                print("\nPAN accepted successfully.")

                break

            except psycopg2.errors.UniqueViolation:

                conn.rollback()

                print("\nThis PAN is already accepted.")
                print("Please enter another PAN.")

        else:

            print("\nPAN was not accepted.")


    # ==========================================
    # DUPLICATE PAN
    # ==========================================

    elif status == "DUPLICATE":

        print("\nThis PAN already exists in the system.")
        print("Please enter another PAN.")


    # ==========================================
    # INVALID PAN
    # ==========================================

    else:

        print("\nInvalid PAN.")
        print("Please enter the correct PAN.")


# ==========================================
# CLOSE CONNECTION
# ==========================================

cursor.close()
conn.close()

print("\nPostgreSQL connection closed.")