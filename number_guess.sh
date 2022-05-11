#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read username
number=$(( $RANDOM%1001 ))


game_id=$($PSQL "SELECT game_id FROM number_guess WHERE username='$username' ")
#echo $game_id
if [[ -z $game_id ]]
then
 echo "Welcome, $username! It looks like this is your first time here."
 insert_user=$($PSQL "insert into number_guess(username) values('$username') ")
 games_played=0
 best_game=0
else
 games_played=$($PSQL "SELECT games_played FROM number_guess WHERE game_id=$game_id ")
 best_game=$($PSQL "SELECT best_game FROM number_guess WHERE game_id=$game_id")
 echo "Welcome back, "$username"! You have played $games_played games, and your best game took $best_game guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read userguess
guesses=1

while [[ $userguess != $number ]]
do
  if [[ ! $userguess =~ ^[0-9]+$  ]]
   then
    echo "That is not an integer, guess again:"
    read userguess
    guesses=$(( guesses + 1 ))
  else
    if (( $userguess > $number ))
    then
     echo "It's lower than that, guess again:"
     read userguess
     guesses=$(( guesses + 1 ))
    fi

    if (( $userguess < $number ))
    then
     echo "It's higher than that, guess again:"
     read userguess
    guesses=$(( $guesses + 1 ))
    fi
          
  fi
done

echo "You guessed it in "$guesses" tries. The secret number was "$number". Nice job!"
games_played=$games_played+1 

if [[ $best_game -eq 0 && $games_played -eq 1 ]]
then
 best_game=$guesses
fi
if [[ $best_game > $guesses && $gams_played > 1 ]]
then
    best_game=$guesses
    
fi

update=$($PSQL "UPDATE number_guess set best_game=$best_game, games_played=$games_played where username='$username' ")
