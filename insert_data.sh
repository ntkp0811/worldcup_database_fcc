#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL; do 
  if [[ $WINNER != "winner" ]]; then 
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_TEAM_ID ]]; then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]; then
        echo Inserted into teams, $WINNER
      fi
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]; then
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_TEAM_ID ]]; then
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]; then
      echo Inserted into teams, $OPPONENT 
      fi
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi
  if [[ $YEAR != "year" ]]; then 
    GAME_ID=$($PSQL "SELECT game_id from games WHERE round='$ROUND'")
    if [[ -z $GAME_ID ]]; then
      GAME_ID=null
    fi
    INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOAL, $OPPONENT_GOAL)")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]; then
      echo Inserted result, $YEAR $ROUND
    fi
  fi
done