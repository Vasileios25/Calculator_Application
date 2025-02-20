
# Calculator Application

The project is a Python-based calculator application running inside a Dockerized environment with three containers:
1. **Python Application**: Handles user input and performs basic arithmetic operations.
2. **PostgreSQL**: Stores calculation statistics and tracks how many times each operation is performed.
3. **Vault**: Manages and securely stores database credentials.

## Description

This Python script implements a simple calculator that allows users to perform basic arithmetic operations. It keeps track of how many times each operation is performed and stores these statistics in both a CSV file and a PostgreSQL database.

### Features:
- Perform arithmetic operations: Addition, Subtraction, Multiplication, Division, and Square Power.
- Store statistics (operation counts) in both PostgreSQL and a CSV file.
- Docker Compose setup with 3 containers: Python app, PostgreSQL, and HashiCorp Vault for secret management.
- Vault handles secure storage and retrieval of database credentials.

---

## **1. Initial Setup**

- **Imported Libraries**:
  - `math.pow`: For exponentiation (square power calculation).
  - `psycopg2`: For connecting to the PostgreSQL database.
  - `csv`: For handling CSV file operations.
  
- Initializes counters to track the number of times each operation is performed.
- Initializes an `id` variable to track unique entries in the database.

---

## **2. Connecting to PostgreSQL Database**

- The script establishes a connection to a PostgreSQL database (`my_db`) using credentials (which will later be fetched from HashiCorp Vault).
- A cursor object is created to execute SQL queries.

---

## **3. Retrieving Previous Data from Database**

- The script fetches the last entry from the `Calculator` table using the following query:
  ```sql
  SELECT * FROM Calculator ORDER BY id DESC LIMIT 1;
  ```
- If no previous data exists, it initializes the statistics to `[0, 0, 0, 0, 0, 0]` (representing counts for each operation).

---

## **4. User Interaction and Calculator Operations**

The script enters a loop where it continuously prompts the user for a mathematical operation:
```
1 for Addition
2 for Subtraction
3 for Multiplication
4 for Division
5 for Square power
6 to quit
```

- Based on user input, the corresponding mathematical operation is performed:
  - Addition (1): `first_number + second_number`
  - Subtraction (2): `first_number - second_number`
  - Multiplication (3): `first_number * second_number`
  - Division (4): `first_number / second_number` (with handling for division by zero)
  - Square Power (5): `math.pow(number, 2)`

---

## **5. Handling Errors**

The script includes exception handling for:
- Invalid input: If the user enters a non-numeric value, it prompts them to try again.
- Zero division: If division by zero is attempted, it prints an error message and sets the result to 0.

---

## **6. Updating Statistics**

After the user exits (choosing option 6), the program:
- Increments the entry ID (`id += 1`).
- Prints a summary of how many times each operation was used.

---

## **7. Writing Data to CSV**

The script creates a `Statistics.csv` file and writes the updated statistics:
```python
with open('Statistics.csv', 'w', newline='') as csvfile:
    my_writer = csv.writer(csvfile, delimiter=',')
    my_writer.writerow(input_variable)
```
- Reads the CSV data back and stores it in a list (`all_value`).

---

## **8. Storing Data in PostgreSQL**

The script inserts the updated statistics into the `Calculator` table using the SQL query:
```sql
INSERT INTO Calculator VALUES (%s, %s, %s, %s, %s, %s);
```
- Uses `executemany()` to insert multiple rows if needed.

---

## **9. Closing the Database Connection**

- Commits the changes and closes the database connection.
- Prints "Thanks" to indicate that the program has successfully completed execution.

---

## Docker Compose File Explanation

This Docker Compose (`docker-compose.yml`) file sets up a multi-container environment with:
1. **PostgreSQL Database** (`postgres-db`)
2. **Vault Service** (`vault`) for secrets management
3. **Python Application** (`python-app`), which interacts with the database

---

## **Services**

### **1. PostgreSQL Database (`postgres-db`)**

This service runs a **PostgreSQL 13** database inside a Docker container.

- **Image**: Uses the official PostgreSQL 13 image.
- **Container Name**: `postgres-container`
- **Exposed Ports**: Internally exposes port **5432** (default PostgreSQL port).
- **Environment Variables**: Loads database credentials from `.env` variables.
- **Volumes**:
  - `init_db.sql`: Runs an SQL script at startup to create the **Calculator** table:
    ```sql
    CREATE TABLE IF NOT EXISTS Calculator (
      id integer,
      addition integer,
      substraction integer,
      multiplication integer,
      division integer,
      square integer
    );
    ```
  - `my_volume`: Stores database data persistently.
- **Restart Policy**: Always restarts the container if it stops.
- **Network**: Connects to `my-network` for communication with other services.

---

### **2. Vault (`vault`)**

This service runs **HashiCorp Vault**, used for securely storing and managing secrets.

- **Build Context**: Uses a custom `Dockerfile.vault` to build the container.
- **Container Name**: `vault`
- **Network Mode**: Uses the **host network** (directly binds to the host’s network stack).
- **Environment Variables**:
  - `VAULT_ADDR`: Specifies the Vault server address.
  - `VAULT_TOKEN`: Uses an environment variable for authentication.
- **Volumes**:
  - Mounts the Vault configuration file (`vault-config.hcl`).
  - Mounts a `.env` file to store passwords.
  - `apply-policies.sh`: Script for applying security policies.
  - *(Optional)* `kv-policy.hcl`: Can be added for Vault policy configuration.

---

### **3. Python Application (`python-app`)**

This service runs a **Python script** that connects to the database and performs calculations.

- **Restart Policy**: Always restarts the app if it crashes.
- **Build Context**: Uses the default `Dockerfile` to build the Python environment.
- **Container Name**: `python-app-container`
- **Dependencies**: Waits for `postgres-db` to be ready before starting.
- **Command & Entry Point**:
  - Uses `wait-for-it.sh` to ensure the database is up before running `Calculator.py`.
  - Executes the Python script (`Calculator.py`) after confirming PostgreSQL is available.
- **Network**: Connects to `my-network` for database communication.

---

## **Networks**
- `my-network`: A bridge network for communication between the `postgres-db` and `python-app`.

---

## **Volumes**
- `my_volume`: Stores PostgreSQL data persistently to prevent data loss when the container restarts.

---

## Getting Started

### Dependencies

* Python 3.x
* Docker
* Docker Compose

### Installing

1. Clone the repository:
   ```bash
   git clone https://your-repo-url.git
   cd Calculator_Application
   ```

2. Create a `.env` file for environment variables (database credentials) if not using Vault yet.

3. Build and start the Docker containers:
   ```bash
   docker-compose up --build
   ```

4. Open the Python app container and interact with the calculator.

### Executing program

Run the application using:
```bash
docker-compose up
```

Once the app is running, run in other terminal:
```bash
docker container ls
```

connect to python app to run the python script and the same for the other containers:
```bash
docker exec -t <container> /bin/bash
```

to connect to to postgresql run the following:
```bash
psql -U <name>
```

List available databases:
```bash
\l
```

Switch connection to a new database:
```bash
\c dbname
```

List available tables:
```bash
\dt
```

Describe a table such as a column, type, modifiers of columns, etc.:
```bash
\d table_name
```

## Help

For common issues, check the logs or run the following command for help:
```bash
docker-compose logs
```

## Authors

Contributors names and contact info

ex. Vasilhs S.  


## Version History



## License


## Acknowledgments


