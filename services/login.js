import {
    genMdp, hash,
} from './lib_serveur.js'
import {
    saveUser, userLogin, OneUserWithoutDetails
} from '../data/DAO/utilisateurs.js'
import { addDaysToDate } from './lib_serveur.js'

const accueil = (request, response) => {
    const {session} = request
    if (session.uuid !== undefined) {
        response.send({id: session.ut})
    }
}

const login = (request, response) => {
    const {session,body} = request
    userLogin({
        id: body.ut_id,
        mdp: body.ut_mdp,
    })
    .then(userList => userList[0]) 
    .then(user => {
        if(user !== undefined){
            session.isId = true
            session.profil = user.hab_profil
            session.uuid = user.ut_uuid
            session.ut = user.ut_id
        }
        response.send(user)
    })
    .catch((err)=> console.log(err)) 
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
                user.ut_mdp = hash(user.ut_id,mdp),
                saveUser(user)
                console.log('mot de passe à changer à la prochaine connexion => ', mdp)
                response.send({ result: mdp })
            }   
         }
        else{
            response.send({ result: 'erreur' })
        }
    })
}

const changeMdp = (request, response) => {
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
    .catch((err)=> console.log(err)) 
}

export  {
    login,
    accueil,
    UserBySession,
    UserByMail,
    changeMdp,
}
