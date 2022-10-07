import {
    NewLine, 
    jrnByInc,
    jrnImmExclude,
} from '../data/DAO/journaux.js'

const updateJrn = (request, response) => {
    const {session, body} = request
    if (session.isId == true) {
        NewLine({
            jrn_inc : body.jrn_inc,
            jrn_msg :  body.jrn_msg,
            jrn_imm : body.jrn_imm === 'true',
        })
        .then(line => response.send({ jrn_id: line.insertId }))
    }
}

// get
const getJrnByInc = (request, response) => {
    const {params} = request
    jrnByInc(parseInt(params.id))
   // .then(jrnList => console.log(jrnList))
    .then(jrnList => {
        if (params.infoImmoInclude === 'false'){
            return jrnImmExclude(jrnList)
        }
        else return jrnList
    })
    .then(jrnList => response.send(jrnList))
    .catch((err)=>{response.status(500).json(err)})
}

// maj
const jrnApresSignal = (inc, user, presta, msgInfo) => {
    // jrn 1 - création signalement
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Signalement de ' + user.ut_prenom + ' ' + user.ut_prenom +  ' (tél ' + user.ut_tel + ')',
    })
     // jrn 2 - info usager - le cas échéant
    if (msgInfo !== ''){
        NewLine({
            jrn_inc : inc.inc_id,
            jrn_msg : msgInfo,
        })
    }
     // jrn 3 - attribution presta
     NewLine({
         jrn_inc : inc.inc_id,
         jrn_msg : 'Attribution : ' + presta.presta_nom,
         jrn_imm : true,
     })
}

const jrnApresAffectation = (inc, user, reacfect) => {
    // jrn 1 - prise en charge si 1ère affectation
    if (!reacfect){
        NewLine({
            jrn_inc : inc.inc_id,
            jrn_msg : 'Pris en charge par notre technicien',
        })
    }
     // jrn 2 - affectation
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Affectation ' + user.ut_prenom + ' ' + user.ut_nom,
        jrn_imm : true,
    })
}

const jrnApresAttribution = (inc, presta) => {
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Attribution ' + presta.presta_nom,
        jrn_imm : true,
    })
}

const jnrApresFin = (inc, user) => {
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Intervention terminée'
    })

    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Fin intervention : ' + user.ut_prenom + ' ' + user.ut_nom,
        jrn_imm : true,
    })
}

function jnrAprescloture(inc, user, msgInfo) {
    if (msgInfo!== undefined){     // msg donc relance
        NewLine({
            jrn_inc : inc.inc_id,
            jrn_msg : 'Relance demandée - Motif : ' + msgInfo,
        })
    }
    NewLine({
        jrn_inc : inc.inc_id,
        jrn_msg : 'Intervention clôturée : ' + user.ut_prenom + ' ' + user.ut_nom,
    })
}


export  {
    getJrnByInc,
    updateJrn,
    jrnApresSignal, 
    jrnApresAffectation,
    jrnApresAttribution,
    jnrApresFin,
    jnrAprescloture,
}

