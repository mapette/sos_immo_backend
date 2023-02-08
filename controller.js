import express from 'express'
const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

export { app, }

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

import db from './db/db.js'
db.sync()
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
  arcOldInc,
} from './services/incidents.js'
import {
  getAllEmp, getAllEmpAndTinc, getOneEmp,
  creaOneEmp,
  updateOneEmp,
} from './services/emplacements.js'
import {
  getAllTemp, getOneTemp,
  creaOneTemp,
  updateOneTemp,
} from './services/temp.js'
import {
  getAllTinc, getOneTinc,
  createOneTinc,
  updateOneTinc,
} from './services/tinc.js'
import {
  getByTemp, getOneMapping,
  creaOneMapping,
  deleteOneMapping,
} from './services/mapping.js'
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
app.put('/change_pw', changePw)

//////////// gestion utilisateurs ////////////
app.get('/user/get_all', getAllUsers)
app.get('/user/get_one/:uuid', getOneUser)
app.get('/user/get_author/:uuid', getUserHab)
app.get('/user/get_byCatAndPresta/:cat/:presta_id', getUserListByCatAndPresta)

app.post('/user/creation', creaOneUser)
app.put('/user/update', updateOneUser)
app.get('/user/exit/:uuid', exitOneUser)

//////////// gestion prestataires ////////////
app.get('/presta/get_all', getAllPresta)
app.get('/presta/get_one/:id', getPrestaById)
app.post('/presta/creation', creaOnePresta)
app.put('/presta/update', updateOnePresta)

//////////// gestion emplacement ////////////
app.get('/emp/get_all', getAllEmp)
app.get('/emp/get_one/:id', getOneEmp)
app.get('/temp/get_all', getAllTemp)
app.get('/temp/get_one/:id', getOneTemp)

app.post('/emp/creation', creaOneEmp)
app.put('/emp/update', updateOneEmp)
app.post('/temp/creation', creaOneTemp)
app.put('/temp/update', updateOneTemp)

app.get('/mapping/get_by_temp/:id', getByTemp)
app.get('/mapping/get_one/:id', getOneMapping)
app.post('/mapping/creation', creaOneMapping)
app.delete('/mapping/delete/:id', deleteOneMapping)

//////////// incidents ////////////
app.get('/inc/get_all', getIncAll)
app.get('/inc/get_byUser', getIncByUser)
app.get('/inc/get_one/:id', getOneInc)
app.get('/inc/get_jnr/:id/:infoImmoInclude', getJrnByInc)
app.post('/jrn/update_user', updateJrnUser)
app.post('/jrn/update_techno', updateJrnTechno)

//////////// gestion type d'incident ////////////
app.get('/tinc/get_all', getAllTinc)
app.get('/tinc/get_one/:id', getOneTinc)
app.post('/tinc/create', createOneTinc)
app.put('/tinc/update', updateOneTinc)

//////////// incidents usagers ////////////
app.get('/inc/get_allEmpAndTinc', getAllEmpAndTinc)
app.post('/inc/creation', creaOneInc)
app.get('/inc/closing/:inc_id', clotInc)  // satisfaction
app.put('/inc/closingAndRelaunch', clotInc)  // insatisfaction : commentaire + relance

//////////// incidents presta ////////////
app.get('/inc/get_byPresta', getIncByPresta)

app.get('/inc/affect/:inc_id', autoAffectation)
app.get('/inc/affect/:inc_id/:techno_id', affectation)
app.get('/inc/attrib/:inc_id/:presta_id', attribution)
app.get('/inc/end/:inc_id', finInc)

//////////// incidents admin ////////////
app.get('/inc/closing', clotOldInc) // clôture tous les incidents fermés +48 heures
app.get('/inc/arc', arcOldInc) // cl
