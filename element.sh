#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Checks if any argument was passed
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

if [[ -z $ELEMENT_DATA ]]
then
  echo I could not find that element in the database.
  exit
fi

echo $ELEMENT_DATA | while IFS="|" read ATOMIC_NUMBER ELEMENT_NAME ELEMENT_SYMBOL ELEMENT_TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
do
 echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
