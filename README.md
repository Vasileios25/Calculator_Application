# Calculator_Application

• Python Calculator that take input from customer in order to choose mathematics calculation(Division, abstraction etc), choose 2 numbers and give output

• How much time each run will be written at postgress table

• vault container will handle the db credentials, pending the connection of python code to vault in order to take the credentials

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
•

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
