# Calculator_Application
• Docker implementation, 3 containers, Vault,Python,PostgreSQL.

• Python Calculator that take input from customer in order to choose mathematics calculation(Division, abstraction etc), choose 2 numbers and give output.

• How many times each run will be written at postgress table.

• vault container will handle the db credentials, pending the connection of python code to vault in order to take the credentials.

## Description

This Python script implements a simple calculator that allows users to perform basic arithmetic operations. It keeps track of how many times each operation is performed and stores these statistics in both a CSV file and a PostgreSQL database.

1. Initial Setup
• The script imports necessary libraries:
  • math.pow for exponentiation (square power calculation).
  • psycopg2 for connecting to a PostgreSQL database.
  • csv for handling CSV file operations.
• Initializes counter variables to keep track of how many times each operation is performed (Addition, Subtraction, Multiplication, Division, Square_power).
• Initializes an id variable to track unique entries in the database.

2. Connecting to the PostgreSQL Database
• Establishes a connection to a PostgreSQL database named my_db using credentials(in later implementation creds will exclusively retrieved by Hashicorp Vault)
• Creates a cursor object to execute SQL queries.(A cursor object in PostgreSQL [and databases in general] is an interface that allows you to execute SQL queries and interact with the database through Python.)

3. Retrieving Previous Data from Database
• The script attempts to fetch the last entry from the Calculator table using:
```
SELECT * FROM Calculator ORDER BY id DESC LIMIT 1;
```
• If data exists:
  • The last record is retrieved and stored as a list (new_list).

• If no previous data is found (TypeError occurs):
  • A new list [0, 0, 0, 0, 0, 0] is initialized, representing:
  1.Entry ID
  2.Addition count
  3.Subtraction count
  4.Multiplication count
  5.Division count
  6.Square power count

4. User Interaction and Calculator Operations

• The script enters a loop where it continuously prompts the user for a mathematical operation:
  ```
   1 for Addition
   2 for Subtraction
   3 for Multiplication
   4 for Division
   5 for Square power
   6 to quit
  ```
• If the user chooses an operation other than 6 (exit) and 5 (square power), they are asked for two numbers. 
• If the user chooses 5, only one number is needed.
• Based on user input, the corresponding mathematical operation is performed:
  • Addition (1): first_number + second_number
  • Subtraction (2): first_number - second_number
  • Multiplication (3): first_number * second_number
  • Division (4): first_number / second_number
    • Handles division by zero and sets the result to 0 if an error occurs.
  • Square Power (5): Uses math.pow(number, 2).
• Operation counters are incremented, and the new_list is updated to reflect the new statistics.


5. Handling Errors
• The script includes exception handling for:
  • Invalid input: If the user enters a non-numeric value, it prompts them to try again.
  • Zero division: If division by zero is attempted, it prints an error message and sets the result to 0.

6. Updating Statistics
• After the user exits (6 is chosen), the program:
  • Increments the entry ID (id += 1).
  • Prints a summary of how many times each operation was used.

7. Writing Data to CSV
• The script creates a Statistics.csv file and writes the updated statistics:
  ```
  with open('Statistics.csv', 'w', newline='') as csvfile:
    my_writer = csv.writer(csvfile, delimiter=',')
    my_writer.writerow(input_variable)
  ```
• Reads back the CSV data and stores it in a list (all_value).

8. Storing Data in PostgreSQL
• The script inserts the updated statistics into the Calculator table using the SQL query:
  ```
   INSERT INTO Calculator VALUES (%s, %s, %s, %s, %s, %s);
  ```
 • Uses executemany() to insert multiple rows if needed.

9. Closing the Database Connection
    • Commits the changes and closes the database connection.
    • Prints "Thanks" to indicate that the program has successfully completed execution.

Docker Compose File Explanation

This Docker Compose (docker-compose.yml) file sets up a multi-container environment with:
  1.PostgreSQL Database (postgres-db)
  2.Vault Service (vault) for secrets management
  3.Python Application (python-app), which interacts with the database


Services
1. PostgreSQL Database (postgres-db)

This service runs a PostgreSQL 13 database inside a Docker container.
  • Image: Uses the official PostgreSQL 13 image.
  • Container Name: postgres-container
  • Exposed Ports: Internally exposes port 5432 (default PostgreSQL port).
  • Environment Variables: Loads database credentials from .env variables.
  • Volumes:
    • init_db.sql: Runs an SQL script at startup to create the table calculator:
     ```
      CREATE TABLE IF NOT EXISTS Calculator(
       id integer,
       addition integer,
       substraction integer,
       multiplication integer,
       division integer,
       square   integer
);
    ```
    • my_volume: Stores database data persistently.
  • Restart Policy: Always restarts the container if it stops.
  • Network: Connects to my-network for communication with other services.

2. Vault (vault)

This service runs HashiCorp Vault, used for securely storing and managing secrets.
  • Build Context: Uses a custom Dockerfile.vault to build the container.
  • Container Name: vault
  • Network Mode: Uses the host network (directly binds to the host’s network stack).
  • Environment Variables:
        • ```VAULT_ADDR``` : Specifies the Vault server address.
        VAULT_TOKEN: Uses an environment variable for authentication.
    Volumes:
        Mounts the Vault configuration file (vault-config.hcl).
        Mounts a .env file to store passwords.
        apply-policies.sh: Script for applying security policies.
        (Optional): kv-policy.hcl can be added for Vault policy configuration.

3. Python Application (python-app)

This service runs a Python script that connects to the database and performs calculations.

    Restart Policy: Always restarts the app if it crashes.
    Build Context: Uses the default Dockerfile to build the Python environment.
    Container Name: python-app-container
    Dependencies: Waits for postgres-db to be ready before starting.
    Command & Entry Point:
        Uses wait-for-it.sh to ensure the database is up before running Calculator.py.
        Executes the Python script (Calculator.py) after confirming PostgreSQL is available.
    Network: Connects to my-network for database communication.

Networks

    my-network: A bridge network for communication between the postgres-db and python-app.

Volumes

    my_volume: Stores PostgreSQL data persistently to prevent data loss when the container restarts.

## Getting Started

### Dependencies

* Describe any prerequisites, libraries, OS version, etc., needed before installing program.
* ex. Windows 10

### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)
