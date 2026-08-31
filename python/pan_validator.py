import psycopg2


# ==========================================
# CONNECT TO POSTGRESQL
# ==========================================

conn = psycopg2.connect(
    host="localhost",
    database="Pan_project",
    user="postgres",
    password="Siddiq@13",
    port=5433
)

print("✅ PostgreSQL connection successful!")


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

            cursor.execute(
                """
                INSERT INTO ACCEPTED_USER_PANS
                (ORIGINAL_INPUT, CLEAN_PAN)
                VALUES (%s, %s)
                """,
                (original_input, cleaned_pan)
            )

            conn.commit()

            print("\n✅ PAN accepted successfully.")

            break

        else:

            print("\n❌ PAN was not accepted.")


    # ==========================================
    # DUPLICATE PAN
    # ==========================================

    elif status == "DUPLICATE":

        print("\n❌ This PAN already exists in the system.")
        print("Please enter another PAN.")


    # ==========================================
    # INVALID PAN
    # ==========================================

    else:

        print("\n❌ Invalid PAN.")
        print("Please enter the correct PAN.")


# ==========================================
# CLOSE CONNECTION
# ==========================================

cursor.close()
conn.close()

print("\n🔒 PostgreSQL connection closed.")