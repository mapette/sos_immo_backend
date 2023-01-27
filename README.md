# SOS_IMMO Back End
20220606 téléchargement nodejs depuis nodejs.org
cmd : node -v : v16.14.0

## Librairies à installer : 
npm install 
* express 
* session-express
* cors
* mysql2
* uuidv4
* sequelize-cli
* jest

## base de données MySql : 
* jouer le script "backend sos_immo\doc\bdd\script_mise_en_place.sql"

## variables d'environnement : 
portSosImmo -> valeur 3001

db_sos_immo_prod -> nom de la base de production
db_sos_immo_test -> nom de la base de tests

mySqlUser -> user mySql
mySqlPw -> mot de passe mySql

## lancement : 
* ligne de commande : nodemon serveur.js

### tests :
* postman
* scénarios : répertoire "tests"
