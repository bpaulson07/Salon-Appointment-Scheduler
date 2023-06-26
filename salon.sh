#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Bike Rental Shop ~~~~~\n"

SERVICE_MENU() {

SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo "Welcome to My Salon, how can I help you?" 
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) SELECTED_SERVICE_MENU ;;
  2) SELECTED_SERVICE_MENU ;;
  3) SELECTED_SERVICE_MENU ;;
  4) SELECTED_SERVICE_MENU ;;
  *) SERVICE_MENU "Please enter a valid option." ;;
esac

}

SELECTED_SERVICE_MENU () {
# if input is not a number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
# send to main menu
 SERVICE_MENU "I could not find that service. What would you like today?"
else 

# is it a true service
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
# if not a true service
# get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$( $PSQL "SELECT name from customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
   # get new customer name
   echo -e "\nI don’t have a record for that phone number, what’s your name?"
   read CUSTOMER_NAME
   # insert new customer
   INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 

  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your $(echo $SERVICE_SELECTED | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  read SERVICE_TIME

  # insert bike rental
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE_SELECTED | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

fi
}

SERVICE_MENU