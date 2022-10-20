import {
    prestaById,
    prestaList,
    savePresta,
} from '../data/DAO/presta.js'
import Presta from '../data/models/presta.js'

const getAllPresta = (request, response) => {
    const { session } = request
    if (session.isId == true & (session.profil == 4)) {
        prestaList()
            .then(list => response.send(list))
            .catch((err) => { response.status(500).json(err) })
    }
}

const getPrestaById = (request, response) => {
    const {session, params} = request
    if (session.profil == 4) {
        prestaById(params.id)
        .then(presta => response.send(presta))
        .catch((err)=>{response.status(500).json(err)})
    }
}

const creaOnePresta = (request, response) => {
    const {session, body} = request
    if (session.isId == true & session.profil == 4) {
        const presta = Presta.build({
            presta_nom: body.presta_nom,
            presta_libelle: body.presta_libelle,
        })
        savePresta(presta)
            .then(response.send({  msg: 'ok' }))
            .catch((err) => { response.status(500).json(err) })
    }
}

const updateOnePresta = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        prestaById(body.presta_id)
            .then(presta => {
                presta.presta_nom = body.presta_nom
                presta.presta_libelle = body.presta_libelle
                return savePresta(presta)
            }).then(response.send({ msg: 'ok' }))
            .catch((err) => { response.status(500).json(err) })
    }
}

export {
    getAllPresta,
    getPrestaById,
    creaOnePresta,
    updateOnePresta,
}
