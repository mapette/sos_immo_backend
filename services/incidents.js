import {userByUuid, } from '../data/DAO/utilisateurs.js'
import {tincById,} from '../data/DAO/types_inc.js'
import {prestaById,} from '../data/DAO/prestataires.js'
import {NewLine,} from '../data/DAO/journaux.js'
import {
    incById,
    incListWithDetails,
    newInc,
    saveInc,
} from '../data/DAO/incidents.js'
import  {
    DELAIS_CLOTURE_AUTO,
    DELAIS_VISIBILITE_INC_CLOTURE,
} from './lib_serveur.js'
import {
    jrnApresSignal,
    jrnApresAffectation,
    jrnApresAttribution,
    jnrApresFin,
    jnrAprescloture,
} from '../services/journaux.js'

import Prestataires from '../data/models/prestataires.js'
import Tinc from '../data/models/types_inc.js'
import User from '../data/models/utilisateurs.js'
import Incidents from '../data/models/incidents.js'

const retirerVieux = (inc) => {
    if (inc.inc_cloture_date !== null) { return new Date() - inc.inc_cloture_date < DELAIS_VISIBILITE_INC_CLOTURE }
    else { return true }
}

// get
const getIncAll = (request, response) => {
        // selon le profil, on obtient tous les incidents (imm) ou ceux d'1 presta (valideur)
        // tous les incidents => jusqu'à 1 mois après clôture
        const {session} = request
        if (session.isId == true && (session.profil == 3 || session.profil == 4)) {
            incListWithDetails()
            .then(incList => {
                if(session.profil == 3){
                    userByUuid(session.uuid)
                    .then(userList =>prestaById(userList[0].ut_presta))
                    .then(presta => incList.filter(inc => inc.inc_presta === presta.presta_id))
                    .then(incList => incList.filter(inc =>retirerVieux(inc))) 
                    .then(incList => response.send(incList))
                }
                else {
                    response.send(incList.filter(inc =>retirerVieux(inc)))
                }
            })
            .catch((err)=>{response.status(500).json(err)})
    }
}
const getIncByUser = (request, response) =>  {
        // mes demandes => jusqu'à 1 mois après clôture
    const {session} = request
    if (session.isId == true) {
        incListWithDetails()
        .then(list =>{return list.filter(line => line.inc_signal_ut === session.uuid) })
        .then(incList => incList.filter(inc =>retirerVieux(inc))) 
        .then(list => response.send(list))
        .catch((err)=>{response.status(500).json(err)})
    }
}

const getIncByPresta = (request, response) =>  {
        // suivi incidents => status 'enAttente' et 'enCours'
    const {session} = request
    let user = new User
    if (session.isId == true &&
        (session.profil == 2 | session.profil == 3)){
        // récup de l'employeur du demandeur 
        userByUuid(session.uuid)
        .then(userList => user = userList[0])
        .then(() => incListWithDetails())
        // récup inc de cet employeur 
        .then(incList => {return incList.filter(inc => inc.inc_presta === user.ut_presta)})
        .then(incList => {
            if(session.profil == 2){
               return incList.filter(inc => inc.inc_fin_date === null 
                                            && (inc.inc_affect_date === null ||
                                            inc.inc_affect_ut === session.uuid))
            }
            else {return incList.filter(inc => inc.inc_fin_date === null)}
        })
        .then(incList => response.send(incList))
        .catch((err)=>{response.status(500).json(err)})
    }
}

const getOneInc = (request, response) =>  {
    const {session, params} = request
    if (session.isId == true) {
        incListWithDetails()
        .then(incList => {return incList.filter(inc => inc.inc_id ===  parseInt(params.id))})
        .then(incList => response.send(incList[0]))
        .catch((err)=>{response.status(500).json(err)})
    }
}

// création 
const creaOneInc = (request, response) => {
    let presta = new Presta
    let tinc = new Tinc
    let user = new User
    const {session,body} = request
    if (session.isId == true) {
        userByUuid(session.uuid)
        .then(userList => user = userList[0])
        .then(() => {return tincById(body.tinc)})
        .then(typeInc =>{ 
            tinc = typeInc
            return prestaById(tinc.tinc_presta) 
        })
        .then(prestataire =>{
            presta = prestataire
            return newInc({
                inc_emp : parseInt(body.emp),
                inc_tinc : tinc.tinc_id,
                inc_presta : presta.presta_id,
                inc_signal_date : new Date(),
                inc_signal_ut : user.ut_uuid,
            })
        })
        .then(incident =>{
            jrnApresSignal(incident, user, presta, body.info)
            response.send({id : incident.inc_id})
        })
       .catch((err)=>{response.status(500).json(err)})
    }
}

const relanceSignal = (ancInc, user, msg) => {
    let nouvInc = new Incidents
    newInc({
        inc_emp: ancInc.inc_emp,
        inc_tinc: ancInc.inc_tinc,
        inc_presta: ancInc.inc_presta,
        inc_signal_ut: ancInc.inc_signal_ut,
        inc_signal_date: new Date(),
    })
        .then(incident => nouvInc = incident)
        .then(() =>  prestaById(nouvInc.inc_presta))
        .then(presta => {
            let msgRelance = "Relance de l'incident " + ancInc.inc_id + ". Motif : " + msg
            jrnApresSignal(nouvInc, user, presta, msgRelance)
        })
}

// affectation - attribution
const autoAffectation = (request, response) => {
    let user = new User
    const {session, params} = request
    if (session.isId == true && session.profil == 2) {
        userByUuid(session.uuid)
        .then(userList => user = userList[0])
        .then(() => incById(parseInt(params.inc_id)))
        .then(inc => {
            inc.inc_affect_date = new Date()
            inc.inc_affect_ut = user.ut_uuid
            return saveInc(inc)
        })
        .then(inc => {
            jrnApresAffectation(inc, user, false)
            response.send({ status: true })
        })
    }
}

const affectation = (request, response) => {
    let user = new User
    const {session, params} = request      
    if (session.isId == true && (session.profil == 3 | session.profil == 4)) {
        userByUuid(params.techno_id)
        .then(userList => user = userList[0])
        .then(() => incById(params.inc_id))
        .then(inc => {
            inc.inc_affect_date = new Date()
            inc.inc_affect_ut = user.ut_uuid
            return saveInc(inc)
        })
        .then(inc => {
            jrnApresAffectation(inc, user, true)
            response.send({ status: true })
        })
    }
}

const attribution = (request, response) => {
    const {session, params} = request  
    let presta = Prestataires   
    if (session.isId == true && (session.profil == 4)) {
        prestaById(params.presta_id)
        .then(newPresta => presta = newPresta)
        .then(() => incById(params.inc_id))
        .then(inc => {
            inc.inc_presta = presta.presta_id
            return saveInc(inc)
        })
        .then(inc => {
            jrnApresAttribution(inc, presta)
            response.send({ status: true })
        })
    }
}

// fin
const finInc = (request, response) => {
    const {session, params} = request  
    let user = User   
    if (session.isId == true && session.profil != 1) {
        userByUuid(session.uuid)
        .then(userList => user = userList[0])
        .then(() => incById(params.inc_id))
        .then(inc => {
            inc.inc_fin_date = new Date()
            return saveInc(inc)
        })
        .then(inc => {
            jnrApresFin(inc, user)
            response.send({ status: true })
        })
    }
}

const clotInc = (request, response) => {
    const { session, params, body } = request
    let user = User
    let inc_id = 0
    if (session.isId == true) {
        if (Object.keys(params).length === 0) { inc_id = body.inc_id }  // post => prendre body
        else { inc_id = parseInt(params.inc_id) }                       // get => prendre params
        userByUuid(session.uuid)
            .then(userList => user = userList[0])
            .then(() => incById(inc_id))
            .then(inc => {
                inc.inc_cloture_date = new Date()
                return saveInc(inc)
            })
            .then(inc => {
                jnrAprescloture(inc, user, body.info)
                if (Object.keys(params).length === 0) { relanceSignal(inc, user, body.info) }   // post => relance
                response.send({ status: true })
            })
    }
}

const clotOldInc = (request, response) => {
    const { session, } = request
    if (session.isId == true && session.profil == 4) {
        incListWithDetails()
            .then(incList => incList.filter(inc =>
                inc.inc_fin_date !== null && inc.inc_cloture_date === null))
            .then(incList => incList.filter(inc => new Date() - inc.inc_fin_date > DELAIS_CLOTURE_AUTO))
            .then(incList => {
                incList.forEach(inc => {
                    inc.inc_cloture_date = new Date()
                    NewLine({
                        jrn_inc: inc.inc_id,
                        jrn_msg: 'Intervention clôturée automatiquement',
                    })
                    saveInc(inc)
                });
                response.send(incList)
            })
    }
}


export  {
    getIncAll,
    getIncByPresta,
    getOneInc,
    getIncByUser,
    creaOneInc, 
    autoAffectation,  
    affectation, 
    attribution,
    finInc,
    clotInc,
    clotOldInc,
}

