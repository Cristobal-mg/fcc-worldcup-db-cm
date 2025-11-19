#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# 1. Limpiar tablas (TRUNCATE) para empezar de cero
echo $($PSQL "TRUNCATE TABLE games, teams")

# 2. Leer el archivo CSV
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Saltar la línea de títulos
  if [[ $YEAR != "year" ]]
  then
    # --- OBTENER ID DEL GANADOR ---
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # Si no existe, insertarlo y recuperar el nuevo ID
    if [[ -z $WINNER_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo "Inserted team: $WINNER"
    fi

    # --- OBTENER ID DEL OPONENTE ---
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # Si no existe, insertarlo y recuperar el nuevo ID
    if [[ -z $OPPONENT_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo "Inserted team: $OPPONENT"
    fi

    # --- INSERTAR EL JUEGO ---
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
    echo "Inserted game: $YEAR $ROUND - $WINNER vs $OPPONENT"
  fi
done

# Do not change code above this line. Use the PSQL variable above to query your database.
