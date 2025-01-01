#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -q -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -q -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPP WINNER_GOALS OPP_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') RETURNING team_id")"
    fi

    OPP_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")"

    if [[ -z $OPP_ID ]]
    then
      OPP_ID="$($PSQL "INSERT INTO teams(name) VALUES('$OPP') RETURNING team_id")"
    fi

    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPP_GOALS)"
  fi
done
