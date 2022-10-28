import  {
    genUuid,
} from './lib_serveur.js'
import {
    habByUserUuid,
    habByUuid,
    saveHab,
    newHab,
} from '../data/DAO/habilitations.js'

const getUserHab = (request, response) => {
    const {session} = request
    if (session.isId == true & session.profil == 4) {
        habByUserUuid(request.params.uuid)
        .then(userList => {return userList.filter((element) => element.hab_profil !== 0)})
        .then(userList => response.send(userList))
        .catch((err)=>{response.status(500).json(err)})
    }
}

const changeProfil = (data, response) => {
    // récupérer ancien hab
    habByUuid(data.hab_uuid)
    .then(hab => {
    // update ancien hab => date exp
        hab.hab_date_exp = new Date()
        return saveHab(hab)
    })
    .then(newHab({
    // créer new hab
            hab_uuid : genUuid(),
            hab_ut : data.ut_uuid,
            hab_profil :  data.profil,
            hab_date_deb : new Date(),
            hab_date_exp : null,
        })
    )
}


export  {
    getUserHab,
    changeProfil,

}