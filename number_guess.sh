#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

echo "Enter your username:"
read username
number=$(( $RANDOM%1001 ))
game_played=$($PSQL "SELECT users.game_played FROM users WHERE username='$username' ")
function check(){
  if [[ $1 =~ [^0-9] ]]
  then
   printf "That is not an integer, guess again:\n"
   return 1
  fi
  if [[ $1 > $number ]]
  then
   printf "It's lower than that, guess again:\n"
   return 1
  elif [[ $1 < $number ]]
  then
    printf "It's higher than that, guess again:\n"
    return 1
  else
   print "You guessed it in "$2" tries. The secret number was "$1". Nice job!\n"
   return 0;
  fi
}


if [[ -z $game_played ]]
then
 echo "Welcome, "$username"! It looks like this is your first time here."
 echo "Guess the secret number between 1 and 1000:"
 read userguess
 check $userguess $guess
 call=$?
 while [[ call != 0 ]]
 do
  read userguess
  guess=$(( $guess + 1 ))
  check $userguess $guess
  call=$?
 done
else
 #games_played=$($PSQL "SELECT game_played FROM games WHERE username="$query"")
 best_game=$($PSQL "SELECT users.best_game FROM users WHERE best_game='$query' ")
 echo "Welcome back, "$query"! You have played  "$games_played", and your best game took "$best_game" guesses."
 read userguess
 check $userguess
 call=$?
 while [[ call != 0 ]]
 do
  read userguess
  guess=$(( $guess + 1 ))
  check $userguess $guess
  call=$?
 done
fi
