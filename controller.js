import express from 'express'
const app = express()
app.use(express.json())
app.use(express.static('../sos_immo/public'))
app.use(express.urlencoded({ extended: true }))

export { app, }

//import {PORT} from '.env.dev'
// console.log(PORT)

//gestion des cookies
import session from 'express-session'
app.use(session({
  secret: 'keyboard cat',
  cookie: { maxAge: 600000 }, // 10 minutes
  rolling: true,
}))

// évite les pbmes de sécurité pour les envois front->back
import cors from 'cors'
app.use(cors({
  origin: 'http://localhost:3000',
  credentials: true,
}))
// if (actual_db = 'prod') {
//   './db/db.js'
// }
import db from './db/db.js'
// console.log(process.env.sos_immo_db)
db.sync()
//const port = 3001
//app.listen(port)    
app.listen(process.env.portSosImmo, '0.0.0.0')

import {
  welcome, login, logout,
  UserBySession, UserByMail,
  changePw,
} from './services/login.js'
import {
  getAllPresta, getPrestaById,
  creaOnePresta,
  updateOnePresta,
} from './services/prestataires.js'
import {
  getAllUsers, getOneUser,
  getUserListByCatAndPresta,
  creaOneUser,
  updateOneUser,
  exitOneUser,
} from './services/utilisateurs.js'
import {
  getUserHab,
} from './services/habilitations.js'
import {
  getIncAll, getOneInc,
  getIncByUser, getIncByPresta,
  creaOneInc,
  autoAffectation, affectation, attribution,
  finInc,
  clotInc, clotOldInc,
} from './services/incidents.js'
import {
  getAllEmp, getAllEmpAndTinc, getOneEmp,
  creaOneEmp,
  updateOneEmp,
  getAllTemp, getOneTemp,
  creaOneTemp,
  updateOneTemp,
} from './services/emplacements.js'
import {
  getJrnByInc,
  updateJrnUser, updateJrnTechno,
} from './services/journaux.js'

//////      login - authentification     //////
app.get('/welcome', welcome)
app.post('/login', login)
app.get('/logout', logout)
app.post('/forgotPw', UserByMail)
app.get('/user/get_session', UserBySession)
app.post('/change_pw', changePw)

//////////// gestion utilisateurs ////////////
app.get('/user/get_all', getAllUsers)
app.get('/user/get_one/:uuid', getOneUser)
app.get('/user/get_author/:uuid', getUserHab)
app.get('/user/get_byCatAndPresta/:cat/:presta_id', getUserListByCatAndPresta)

app.post('/user/creation', creaOneUser)
app.post('/user/update', updateOneUser)
app.get('/user/exit/:uuid', exitOneUser)

//////////// gestion prestataires ////////////
app.get('/get_presta', getAllPresta)
app.get('/get_presta/:id', getPrestaById)

app.post('/presta/creation', creaOnePresta)
app.post('/presta/update', updateOnePresta)

//////////// gestion emplacement ////////////
app.get('/emp/get_all', getAllEmp)
app.get('/emp/get_one/:id', getOneEmp)
app.get('/temp/get_all', getAllTemp)
app.get('/temp/get_one/:id', getOneTemp)

app.post('/emp/creation', creaOneEmp)
app.post('/emp/update', updateOneEmp)
app.post('/temp/creation', creaOneTemp)
app.post('/temp/update', updateOneTemp)

//////////// incidents ////////////
app.get('/inc/get_all', getIncAll)
app.get('/inc/get_byUser', getIncByUser)
app.get('/inc/get_one/:id', getOneInc)
app.get('/inc/get_jnr/:id/:infoImmoInclude', getJrnByInc)
app.post('/jrn/update_user', updateJrnUser)
app.post('/jrn/update_techno', updateJrnTechno)

//////////// incidents usagers ////////////
app.get('/inc/get_allEmpAndTinc', getAllEmpAndTinc)
app.post('/inc/creation', creaOneInc)
app.get('/inc/closing/:inc_id', clotInc)
// insatisfaction : commentaire + relance
app.post('/inc/closingAndRelaunch', clotInc)
// clôture tous les incidents fermés +48 heures
app.get('/inc/closing', clotOldInc)

//////////// incidents presta ////////////
app.get('/inc/get_byPresta', getIncByPresta)

app.get('/inc/affect/:inc_id', autoAffectation)
app.get('/inc/affect/:inc_id/:techno_id', affectation)
app.get('/inc/attrib/:inc_id/:presta_id', attribution)
app.get('/inc/end/:inc_id', finInc)

