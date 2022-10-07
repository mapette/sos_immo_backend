import  express from  'express'
const app = express()
app.use(express.json())
app.use(express.static('../sos_immo/public'))
app.use(express.urlencoded({ extended: true }))

//gestion des cookies
import session from 'express-session'
app.use(session({
    secret: 'keyboard cat',
    cookie: { maxAge: 60000000 } // 1000 minutes
    // cookie: { maxAge: 3000 } // 3 secondes
}))

// évite les pbmes de sécurité pour les envois front->back
import cors from 'cors'
app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true,
}))

import db from './db/db.js'
db.sync()
const port = 3001
app.listen(port)

import {
  accueil,
  login,
  UserBySession,
  changeMdp,
} from './services/login.js'
import {
  getAllPresta,
} from './services/presta.js'
import {
  creaOneUser,
  getAllUsers,
  getOneUser,
  getUserListByCatAndPresta,
  updateOneUser,
  deleteOneUser,
} from './services/utilisateurs.js'
import {
  getUserHab,
} from './services/habilitations.js'
import {
  getIncAll,
  creaOneSignal,
  getOneInc,
  getIncByUser,
  getIncByPresta,
  autoAffectation,
  reAffectation,
  attribution,
  finInc,
  clotInc,
  clotOldInc,
} from './services/incidents.js'
import {
  getAllEmp,
} from './services/emplacements.js'
import {
  getJrnByInc,
  updateJrn,
} from './services/journaux.js'

//////      login     //////
app.get('/get_accueil', accueil)   
app.post('/login', login)
app.get('/get_userBySession',UserBySession)
app.post('/change_mdp', changeMdp)

//////////// gestion utilisateurs ////////////
app.post('/crea_user', creaOneUser)
app.get('/get_presta', getAllPresta)
app.get('/get_users', getAllUsers)
app.get('/get_user:uuid', getOneUser)
app.get('/get_habByUser:uuid', getUserHab)
app.get('/get_usersByCatAndPresta/:cat/:presta_id',getUserListByCatAndPresta)

app.post('/update_user', updateOneUser)
app.get('/delete_user:uuid', deleteOneUser)

//////////// incidents ////////////
app.get('/get_inc', getIncAll)
app.get('/get_incByUser', getIncByUser)
app.get('/get_inc_details:id', getOneInc)
app.get('/get_inc_journal/:id/:infoImmoInclude', getJrnByInc)
app.post('/update_comm', updateJrn)

//////////// incidents usagers ////////////
app.get('/get_emp', getAllEmp)
app.post('/crea_signalement',creaOneSignal)
app.get('/clotureInc:inc_id', clotInc)
// insatisfaction : commentaire + relance
app.post('/clotureInc', clotInc)     
 // clôture tous les incidents fermés +48 heures
app.get('/clotureInc', clotOldInc)

//////////// incidents presta ////////////
app.get('/get_incByPresta', getIncByPresta)

app.get('/affectation:inc_id', autoAffectation)
app.get('/affectation/:inc_id/:techno_id/:reaffect', reAffectation)
app.get('/attribution/:inc_id/:presta_id', attribution)
app.get('/finIntervention:inc_id', finInc)
