from math import pow
import psycopg2
import csv


#counter variables
Addition = 0
Subtraction = 0
Multiplication = 0
Division = 0
Square_power = 0
final = None
id = 0
#db connection
conn = psycopg2.connect(
   database="my_db", user='postgres', password='password', host='postgres-db', port= '5432'
)
mycursor = conn.cursor()

#try except in order to check if the table is empty and if yes create a new list otherwise create a new list but with keeping the
#previus id and increamnt it after the main program
try:
    id_query = "Select * from Calculator order by id desc limit 1"
    mycursor.execute(id_query)
    conn.commit()
    result = mycursor.fetchone()
    last_entry = list(result)
    print(last_entry)
    new_list = last_entry.copy()

except TypeError:
    new_list = [0,0,0,0,0,0]


#def main():
    # counter variables
    Addition = 0


while True:
    try:
        user_input = (int(input(
                "1 for Addition \n2 for Subtraction\n3 for Multiplication\n4 for Division\n5 for Square power\n6 to quit\nPlease choose one of the above: ")))
            #print("You entered:", user_input)
        if user_input != 6 and user_input != 5:
            first_number = (float(input("Please give the first number: ")))
            second_number = (float(input("Please give the second number: ")))
        elif user_input == 5:
            number = (float(input("Please give number: ")))

            # main program to calculate the given numbers
        if user_input == 1:
            print("You have selected to do Addition")
            final = float(first_number) + float(second_number)
            Addition += 1
            new_list[1] += 1
            print("The result of the Addition is {:.2f}".format(final))
            continue
        elif user_input == 2:
            final = float(first_number) - float(second_number)
            Subtraction = Subtraction + 1
            new_list[2] += 1
            print("The result of the Subtraction is {:.2f}".format(final))
            print(f"You have chosen {Subtraction} time/times the Subscription")

        elif user_input == 3:
            final = float(first_number) * float(second_number)
            Multiplication = Multiplication + 1
            new_list[3] += 1
            print("The result of the Multiplication is {:.2f}".format(final))
            print(f"You have chosen {Multiplication} time/times the Multiplication")
            continue
        elif user_input == 4:
            try:
                final = float(first_number) / float(second_number)
                Division = Division + 1
                new_list[4] += 1
                print("The result of the Division is {:.2f}".format(final))
                print(f"You have chosen {Division} time/times the Division")
            except ZeroDivisionError:
                final = 0
            print(f"The result division by zero is {final}")
            continue
        elif user_input == 5:
            final = float(pow(number, 2))
            Square_power = Square_power + 1
            new_list[5] += 1
            print(f"The result of the Power {number}" + " is {:.2f}".format(final))
            print(f"You have chosen {Square_power} time/times the Square_power")

        elif user_input == 6:
            break
    except ValueError:
        print("Invalid input, please try again")
        continue

id = id + 1
new_list[0] += 1
# final statistics of the current running round of the program

print(
    f"You have use Addition {Addition} time/times\nSusbscription {Subtraction} time/times\nMultiplication {Multiplication} time/times\nDivision {Division} time/times\n"
    f"Square_power {Square_power} time/times")

# make a variable from the list with the entries and print the
input_variable = new_list
print(input_variable)

conn = psycopg2.connect(
    database="my_db", user='postgres', password='password', host='postgres-db', port='5432'
)
# Statistics.csv gets created in the current working directory
with open('Statistics.csv', 'w', newline='') as csvfile:
    my_writer = csv.writer(csvfile, delimiter=',')
    my_writer.writerow(input_variable)

with open('Statistics.csv') as csvfile:
    csvfile = csv.reader(csvfile, delimiter=',')
    all_value = []
    for row in csvfile:
        value = (row[0], row[1], row[2], row[3], row[4], row[5])
        all_value.append(value)

query = "INSERT INTO Calculator values (%s,%s,%s, %s, %s, %s)"
mycursor = conn.cursor()
mycursor.executemany(query, all_value)

# Commit the changes
conn.commit()
# Close the database connection
conn.close()
mycursor.close()
conn.close()

print("Thanks")





