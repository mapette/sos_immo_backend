import {prestaList} from '../data/DAO/presta.js'

const getAllPresta = (request, response) => {
    const {session} = request
    if (session.isId == true & (session.profil == 3 | session.profil == 4)) {
        prestaList()
        .then(list => response.send(list))
        .catch((err)=>{response.status(500).json(err)})
    }
}

export  {
    getAllPresta,

}