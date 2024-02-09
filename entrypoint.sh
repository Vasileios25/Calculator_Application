#!/bin/bash
timeout --signal=SIGTERM 500 python3 Calculator.py
exit $?
#set -e
#chmod +x entrypoint.sh
#chmod +x /Calculator.py
#echo "Select:"
#echo "1 for Addition"
#echo "2 for Subtraction"
#echo "3 for Multiplication"
#echo "4 for Division"
#echo "5 for Square power"
#echo "6 for quit"
#read -p "Enter the number of your choice:" user_input


#export PYTHONPATH=/home/billaras/PycharmProjects/PsounhsProjects/Test
#exec python3  /Calculator.py "$user_input"