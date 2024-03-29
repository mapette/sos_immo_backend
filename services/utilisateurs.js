import {
    genMdp, genUuid, hash,
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
import { ExceptionUtilisateur } from './cl_exept.js'
import  {addDaysToDate} from './lib_serveur.js'

const getAllUsers = (request, response) => {
    const { session } = request
    try {
        if (session.isId == true && session.profil == 4) {
            userList(request)
                .then(userList => response.send(userList))
                .catch((err) => console.log(err))
        }
        else { throw new ExceptionUtilisateur(666) }
    } catch (err) { response.status(err.status).json(err) }
}

// get
const getOneUser = (request, response) => {
    const { session, params } = request
    try {
        if (session.isId == true & session.profil == 4) {
            userByUuid(params.uuid)
                .then(userList => {
                    response.send(userList[0])
                })
                .catch((err) => { response.status(500).json(err) })
        } else { throw new ExceptionUtilisateur(666) }
    } catch (err) { response.status(err.status).json(err) }
}

const getUserListByCatAndPresta = (request, response) => {
    const { session, params } = request
    if (session.isId == true & (session.profil == 3 | session.profil == 4)) {
        userList(request)
            .then(userList => { return userList.filter(user => user.ut_presta === parseInt(params.presta_id)) })
            .then(userList => { return userList.filter(user => user.hab_profil === parseInt(params.cat)) })
            .then(userList => response.send(userList))
            .catch((err) => console.log(err))
    }
}

// maj
const creaOneUser = (request, response) => {
    // request (entrée) :  cookie de session - données nouvel utilisateur
    // response (sortie) : mot de passe aléatoire
    // définition de variables initialisées d'après request :
    //      cookie (session) et données utilisateur (body)
    const { session, body } = request   
    // test session en cours et profil Admin
    try{
    if (session.isId == true & session.profil == 4) {
        let mdp = genMdp()  // génération du mdp aléatoire
        console.log('mot de passe à changer à la prochaine connexion => ', mdp)
        // création d'un objet Utilisateurs
        const user = Utilisateurs.build({
            ut_uuid: genUuid(),
            ut_id: body.ut_id,
            ut_nom: body.ut_nom,
            ut_prenom: body.ut_prenom,
            ut_presta: body.ut_presta,
            ut_tel: body.ut_tel,
            ut_mail: body.ut_mail,
            ut_mdp: hash(body.ut_id, mdp),
            ut_mdp_exp: addDaysToDate(new Date(), -1),
        })
            // sauvegarde de l'objet en base  
            saveUser(user)
                .then(newHab({
                    hab_uuid: genUuid(),
                    hab_ut: user.ut_uuid,
                    hab_profil: parseInt(body.hab_profil),
                }))
                .then(response.send({ mdp: mdp }))
                .catch((err) => { response.status(500).json(err) })
        }
        else { throw new ExceptionUtilisateur(666) }
    } catch (err) { response.status(err.status).json(err) }
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

const exitOneUser = (request, response) => {
    const { session, params } = request
    if (session.isId == true & session.profil == 4) {
        userByUuid(params.uuid) // retourne 1 liste d'1 seul élément
            .then(user => user[0])      // extrait l'élément
            .then(user => {
                user.ut_date_exp = new Date()
                user.ut_mdp = null
                user.ut_mdp_exp = new Date()
                return saveUser(user)
            })
            .then(user => changeProfil({
                ut_uuid: user.ut_uuid,
                hab_uuid: user.hab_uuid,
                profil: 0,
            }))
            .then(response.send({ status: 'exit' }))
            .catch((err) => { response.status(500).json(err) })
    }
}

export {
    getAllUsers,
    getOneUser,
    getUserListByCatAndPresta,
    creaOneUser,
    updateOneUser,
    exitOneUser,
}
