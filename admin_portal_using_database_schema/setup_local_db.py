## Connect to local postgres database
## Create schema
## Generate sample data
## Populate database with sample data

import psycopg2
import sqlparse

# setup database connection with local postgres database with valid credentials - let database name be admin_portal_db
try:
    conn = psycopg2.connect(
        host="localhost",
        database="admin_portal",
        user="postgres",
        password="password"
    )
    cursor = conn.cursor()
except Exception as e:
    print("Error connecting to database:", e)
    exit(1)

# execute commands in this file database_schema.sql
with open("database_schema.sql", "r") as f:
    cursor.execute(f.read())
conn.commit()

# execute commands in this file sample_data.sql
with open("sample_data.sql", "r") as f:
    cursor.execute(f.read())
conn.commit()



# close connection
conn.close()

