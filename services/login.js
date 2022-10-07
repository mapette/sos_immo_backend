import {saveUser, userLogin} from '../data/DAO/utilisateurs.js'

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

const changeMdp = (request, response) => {
    const {session,body} = request
    console.log('body',body)
    console.log('session',session)
    /*
    login.change_mdp({
        ut_id: request.session.ut,
        ut_mdp: request.body.mdp,
        ut_newmdp: request.body.newmdp
    }, response)
    */
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
    changeMdp,
}

