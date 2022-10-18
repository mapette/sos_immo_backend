import  express from  'express'
const app = express()
app.use(express.json())
app.use(express.static('../sos_immo/public'))
app.use(express.urlencoded({ extended: true }))

app.get('/users', (req,res)=>{
  res.status(200).json({
    users : [{
      name:'sophie',
      age:49,
    }]
  })
})

export {
  app,
}


//gestion des cookies
import session from 'express-session'
app.use(session({
  secret: 'keyboard cat',
  cookie: { maxAge: 600000 }, // 10 minutes
  rolling: true,
  // cookie: { maxAge: 6000000 }, // 100 minutes
  // cookie: { maxAge: 30000 } // 3 secondes
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
  UserByMail,
  changeMdp,
} from './services/login.js'
import {
  getAllPresta,
  getPrestaById,
  creaOnePresta,
  updateOnePresta,
} from './services/presta.js'
import {
  getAllUsers,
  getOneUser,
  getUserListByCatAndPresta,
  creaOneUser,
  updateOneUser,
  deleteOneUser,
} from './services/utilisateurs.js'
import {
  getUserHab,
} from './services/habilitations.js'
import {
  getIncAll,
  creaOneInc,
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
  getOneEmp,
  creaOneEmp,
  updateOneEmp,
  getAllEmpAndTinc,
  getAllTemp,
} from './services/emplacements.js'
import {
  getJrnByInc,
  updateJrn,
} from './services/journaux.js'

//////      login     //////
app.get('/get_accueil', accueil)   
app.post('/login', login)
app.get('/get_userBySession',UserBySession)
app.post('/forgotPw',UserByMail)
app.post('/change_mdp', changeMdp)

//////////// gestion utilisateurs ////////////
app.get('/get_users', getAllUsers)
app.get('/get_user/:uuid', getOneUser)
app.get('/get_habByUser/:uuid', getUserHab)
app.get('/get_usersByCatAndPresta/:cat/:presta_id',getUserListByCatAndPresta)

app.post('/crea_user', creaOneUser)
app.post('/update_user', updateOneUser)
app.get('/delete_user/:uuid', deleteOneUser)

//////////// gestion prestataires ////////////
app.get('/get_presta', getAllPresta)
app.get('/get_presta/:id', getPrestaById)

app.post('/crea_presta', creaOnePresta)
app.post('/update_presta', updateOnePresta)

//////////// gestion emplacement ////////////
app.get('/get_emp', getAllEmp)
app.get('/get_emp/:id', getOneEmp)
app.get('/get_temp', getAllTemp)

app.post('/crea_emp', creaOneEmp)
app.post('/update_emp', updateOneEmp)

//////////// incidents ////////////
app.get('/get_inc', getIncAll)
app.get('/get_incByUser', getIncByUser)
app.get('/get_inc_details/:id', getOneInc)
app.get('/get_inc_journal/:id/:infoImmoInclude', getJrnByInc)
app.post('/update_comm', updateJrn)

//////////// incidents usagers ////////////
app.get('/get_emp', getAllEmpAndTinc)
app.post('/crea_inc',creaOneInc)
app.get('/clotureInc/:inc_id', clotInc)
// insatisfaction : commentaire + relance
app.post('/clotureInc', clotInc)     
 // clôture tous les incidents fermés +48 heures
app.get('/clotureInc', clotOldInc)

//////////// incidents presta ////////////
app.get('/get_incByPresta', getIncByPresta)

app.get('/affectation/:inc_id', autoAffectation)
app.get('/affectation/:inc_id/:techno_id/:reaffect', reAffectation)
app.get('/attribution/:inc_id/:presta_id', attribution)
app.get('/finIntervention/:inc_id', finInc)

