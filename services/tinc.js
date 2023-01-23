import {
    tincList, tincById,
    savetinc,
} from '../data/DAO/types_inc.js'
import Tinc from '../data/models/types_inc.js'

const getAllTinc = (request, response) => {
    const { session } = request
    if (session.isId == true & (session.profil == 4)) {
        tincList()
            .then(list => response.send(list))
            .catch((err) => { response.status(500).json(err) })
    }
    else { response.send({ deconnect: true }) }
}


const getOneTinc = (request, response) => {
    const { session, params } = request
    if (session.isId == true & session.profil == 4) {
        tincList()
            .then(list => list.filter(tinc => tinc.tinc_id === parseInt(params.id)))
            .then(list => response.send(list[0]))
            .catch((err) => console.log(err))
    }
    else { response.send({ deconnect: true }) }
}

const createOneTinc = (request, response) => {
    const {session, body} = request
    if (session.isId == true & session.profil == 4) {
        const tinc = Tinc.build({
            tinc_nom: body.tinc_nom,
            tinc_presta: body.presta_id,
        })
        savetinc(tinc)
            .then(tinc => response.send({ id: tinc.tinc_id }))
            .catch((err) => { response.status(500).json(err) })
    }
    else { response.send({ deconnect: true }) }
}

const updateOneTinc = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        tincById(body.tinc_id)
            .then(tinc => {
                tinc.tinc_nom = body.tinc_nom
                tinc.tinc_presta = body.presta_id
                return savetinc(tinc)
            })
            .then(tinc => response.send({ id: tinc.tinc_id }))
            .catch((err) => { response.status(500).json(err) })
    }
    else { response.send({ deconnect: true }) }
}

export {
    getAllTinc, getOneTinc,
    createOneTinc,
    updateOneTinc,
}
