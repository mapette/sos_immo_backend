import {
    NewLine, jrnByInc,
} from '../data/DAO/journaux.js'
import {
    userByUuid,
} from '../data/DAO/utilisateurs.js'

const updateJrnUsager = (request, response) => {
    const { session, body } = request
    if (session.isId == true) {
        userByUuid(session.uuid)
            .then(userList => userList[0])
            .then(user => {
                NewLine({
                    jrn_inc: body.jrn_inc,
                    jrn_msg: user.ut_prenom + ' ' + user.ut_nom + ' : ' + body.jrn_msg,
                    jrn_imm: body.jrn_imm,
                    jrn_date: new Date(),
                })
                    .then(line => response.send({ jrn_id: line.insertId }))
            })
    }
}
const updateJrnTechno = (request, response) => {
    const { session, body } = request
    if (session.isId == true && session.profil != 1) {
        userByUuid(session.uuid)
            .then(userList => userList[0])
            .then(user => {
                const msg = () => {
                    if (body.jrn_imm) {
                        return user.ut_prenom + ' ' + user.ut_nom + ' : ' + body.jrn_msg
                    }
                    else { return 'votre technicien : ' + body.jrn_msg }
                }
                NewLine({
                    jrn_inc: body.jrn_inc,
                    jrn_msg: msg(),
                    jrn_imm: body.jrn_imm,
                    jrn_date: new Date(),
                })
                    .then(line => response.send({ jrn_id: line.insertId }))
            })
    }
}

// get
const getJrnByInc = (request, response) => {
    const { params } = request
    jrnByInc(parseInt(params.id))
        .then(jrnList => {
            if (params.infoImmoInclude === 'false') {
                return jrnList.filter(line => line.jrn_imm === 0)
            }
            else return jrnList
        })
        .then(jrnList => response.send(jrnList))
        .catch((err) => { response.status(500).json(err) })
}

// maj
const jrnApresSignal = (inc, user, presta, msgInfo) => {
    // jrn 1 - création signalement
    NewLine({
        jrn_inc: inc.inc_id,
        jrn_msg: 'Signalement de ' + user.ut_prenom + ' ' + user.ut_nom + ' (tél ' + user.ut_tel + ')',
        jrn_date : new Date(),
    })
    // jrn 2 - info usager - le cas échéant
    if (msgInfo !== '') {
        NewLine({
            jrn_inc: inc.inc_id,
            jrn_msg : user.ut_prenom + ' ' + user.ut_nom + ' : ' + msgInfo,
            jrn_date : new Date(),
        })
    }
     // jrn 3 - attribution presta
     NewLine({
         jrn_inc : inc.inc_id,
         jrn_msg : 'Attribution : ' + presta.presta_nom,
         jrn_imm : true,
         jrn_date : new Date(),
     })
}

const jrnApresAffectation = (inc, user, reacfect) => {
    // jrn 1 - prise en charge si 1ère affectation
    if (!reacfect){
        NewLine({
            jrn_inc : inc.inc_id,
            jrn_msg : 'Pris en charge par notre technicien',
            jrn_date : new Date(),
        })
    }
     // jrn 2 - affectation
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Affectation : ' + user.ut_prenom + ' ' + user.ut_nom,
        jrn_imm : true,
        jrn_date : new Date(),
    })
}

const jrnApresAttribution = (inc, presta) => {
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Attribution : ' + presta.presta_nom,
        jrn_imm : true,
        jrn_date : new Date(),
    })
}

const jnrApresFin = (inc, user) => {
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Intervention terminée',
        jrn_date : new Date(),
    })
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Fin intervention : ' + user.ut_prenom + ' ' + user.ut_nom,
        jrn_imm : true,
        jrn_date : new Date(),
    })
}

function jnrAprescloture(inc, user, msgInfo) {
    if (msgInfo!== undefined){     // msg donc relance
        NewLine({
            jrn_inc : inc.inc_id,
            jrn_msg : 'Relance demandée par ' + user.ut_prenom + ' ' + user.ut_nom + ' : Motif : ' + msgInfo,
            jrn_date : new Date(),
        })
    }
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Intervention clôturée par ' + user.ut_prenom + ' ' + user.ut_nom,
        jrn_date : new Date(),
    })
}

export  {
    getJrnByInc,
    updateJrnUsager,
    updateJrnTechno,
    jrnApresSignal, 
    jrnApresAffectation,
    jrnApresAttribution,
    jnrApresFin,
    jnrAprescloture,
}
