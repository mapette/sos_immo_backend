import {
    genMdp, hash,
} from './lib_serveur.js'
import {
    saveUser, userLogin, OneUserWithoutDetails
} from '../data/DAO/utilisateurs.js'
import { addDaysToDate } from './lib_serveur.js'

const welcome = (request, response) => {
    // request (entrée) : cookie de session
    // response (sortie) : identifiant de l'utilisateur
    // définition de variable initialisée d'après request : cookie (session)
    const {session} = request
    // test session en cours
    if (session.uuid !== undefined) {
        // retourne au front d'identifiant de l'auteur de la session
        response.send({ id: session.ut })
    }
}

const login = (request, response) => {
    const { session, body } = request
    userLogin({
        id: body.ut_id,
        mdp: body.ut_mdp,
    })
        .then(userList => userList[0])
        .then(user => {
            if (user !== undefined) {
                session.isId = true
                session.profil = user.hab_profil
                session.uuid = user.ut_uuid
                session.ut = user.ut_id
                session.presta = user.ut_presta
            }
            response.send(user)
        })
}

const logout = (request, response) => {
    const { session } = request
    session.isId = false
    response.send(session)
}

const UserBySession = (request, response) => response.send({ id: request.session.ut })

const UserByMail = (request, response) =>{
    const {body} = request
    OneUserWithoutDetails(body.mail)
    .then(listUser => listUser[0])
    .then(user => {
        if (user !== undefined){
            if (body.type === 'id'){
                console.log('identifiant envoyé à l\'adresse mail ', body.mail)
                response.send({ result: user.ut_id })
            }
            else{
                let mdp = genMdp()
                user.ut_mdp = hash(user.ut_id, mdp),
                    saveUser(user)
                console.log('mot de passe à changer à la prochaine connexion => ', mdp)
                response.send({ result: mdp })
            }
        }
        else response.send({ result: 'erreur' })
    })
}

const changePw = (request, response) => {
    const {session,body} = request
    userLogin({
        id: session.ut,
        mdp: body.mdp,
    })
    .then(userList => userList[0]) 
    .then(user => {
        if(user === undefined){
            response.send({ status: false })
        }
        else{
            user.ut_mdp = body.newmdp
            user.ut_mdp_exp = addDaysToDate(new Date(),90)
            saveUser(user)
            response.send({ status: true })
        }
    })
}

export  {
    login, logout,
    welcome,
    UserBySession,
    UserByMail,
    changePw,
}
