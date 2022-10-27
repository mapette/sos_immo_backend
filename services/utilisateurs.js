import  {
    genMdp,
    genUuid,
    hash,
} from './lib_serveur.js'
import {
    userList,
    userByUuid,
    saveUser,
} from '../data/DAO/utilisateurs.js'
import {
    newHab,
} from '../data/DAO/habilitations.js'
import {
    changeProfil,
} from '../services/habilitations.js'
import Utilisateurs from '../data/models/utilisateurs.js'

const getAllUsers = (request, response) => {
    const {session} = request
    if (session.isId == true) {
        userList(request)
        .then(userList => response.send(userList))
        .catch((err)=> console.log(err)) 
    }
}

// get
const getOneUser = (request, response) => {
    const {session} = request
    if (session.isId == true & session.profil == 4) {
        userByUuid(request.params.uuid) 
        .then(userList => response.send(userList[0]))
        .catch((err)=>{response.status(500).json(err)})
    }
}

const getUserListByCatAndPresta = (request, response) => {
    const {session, params} = request
    if (session.isId == true & (session.profil == 3 | session.profil == 4)) {
        userList(request)
        .then(userList => { return userList.filter(user => user.ut_presta === parseInt(params.presta_id)) })
        .then(userList => { return userList.filter(user => user.hab_profil === parseInt(params.cat)) })
        .then(userList => response.send(userList))
        .catch((err)=> console.log(err)) 
    }
}


// maj
const creaOneUser = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        let mdp = genMdp()
        const user = Utilisateurs.build({
            ut_uuid: genUuid(),
            ut_id: body.ut_id,
            ut_nom: body.ut_nom,
            ut_prenom: body.ut_prenom,
            ut_presta: body.ut_presta,
            ut_tel: body.ut_tel,
            ut_mail: body.ut_mail,
            ut_mdp: hash(body.ut_id, mdp),
            // ut_admin_deb: session.ut,
        })
        console.log('mot de passe à changer à la prochaine connexion => ', mdp)
        saveUser(user)
            .then(newHab({
                hab_uuid: genUuid(),
                hab_ut: user.ut_uuid,
                hab_profil: parseInt(body.hab_profil),
                hab_date_deb: new Date(),
                hab_date_exp: null,
            })
            )
            .then(response.send({ mdp: mdp }))
            .catch((err) => { response.status(500).json(err) })
    }
}

const updateOneUser = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        userByUuid(body.ut_uuid) // retourne 1 liste d'1 seul élément
        .then(user => user[0])      // extrait l'élément
        .then(user => {
            user.ut_nom = body.ut_nom
            user.ut_prenom = body.ut_prenom
            user.ut_tel = body.ut_tel
            user.ut_mail = body.ut_mail
            user.ut_presta = body.ut_presta
            return saveUser(user)
        }).then(user => {
            if(user.hab_profil !== parseInt(body.hab_profil)){
                changeProfil({
                    ut_uuid : user.ut_uuid,
                    hab_uuid : user.hab_uuid,
                    profil : parseInt(body.hab_profil),
                })
            }
        })
        .then(user => response.send({ user: user.ut_id }))
        .catch((err)=>{response.status(500).json(err)})
    
    }
}

const deleteOneUser = (request, response) => {
    const { session, params } = request
    if (session.isId == true & session.profil == 4) {
        userByUuid(params.uuid) // retourne 1 liste d'1 seul élément
            .then(user => user[0])      // extrait l'élément
            .then(user => {
                user.ut_date_exp = new Date()
                user.ut_admin_exp = session.ut
                user.ut_mdp = null
                user.ut_mdp_exp = new Date()
                return saveUser(user)
            })
            .then(user => changeProfil({
                ut_uuid: user.ut_uuid,
                hab_uuid: user.hab_uuid,
                profil: 0,
            }))
            .then(response.send({ status: 'delete' }))
            .catch((err) => { response.status(500).json(err) })
    }
}


export {
    getAllUsers,
    getOneUser,
    // getUserHab,
    getUserListByCatAndPresta,
    creaOneUser,
    updateOneUser,
    deleteOneUser,

}