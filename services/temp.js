import {
    tempList,
    tempById,
    saveTemp,
} from '../data/DAO/temp.js'
import Temp from '../data/models/types_emp.js'

const getAllTemp = (request, response) => {
    const { session, } = request
    if (session.isId === true && session.profil === 4) {
        tempList()
            .then(list => list.sort((x, y) => {
                if (x.temp_nom < y.temp_nom) {return -1}
                if (x.temp_nom > y.temp_nom) {return 1}
                return 0
            }))
            .then(list => response.send(list))
            .catch((err) => console.log(err))
    }
}

const getOneTemp = (request, response) => {
    const { session, params, } = request
    if (session.isId === true && session.profil === 4) {
        tempById(params.id)
            .then(temp => response.send(temp))
            .catch((err) => console.log(err))
    }
}

const creaOneTemp = (request, response) => {
    const {session, body} = request
    if (session.isId == true & session.profil == 4) {
        const temp = Temp.build({
            temp_nom: body.temp_nom,
        })
        saveTemp(temp)
            .then(temp => response.send({ id: temp.temp_id }))
            .catch((err) => { response.status(500).json(err) })
    }
}

const updateOneTemp = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        tempById(body.temp_id)
            .then(temp => {
                temp.temp_nom = body.temp_nom
                return saveTemp(temp)
            })
            .then(temp => response.send({ id: temp.temp_id }))
            .catch((err) => { response.status(500).json(err) })
    }
}
export  {
    getAllTemp,
    getOneTemp, 
    creaOneTemp,
    updateOneTemp,
}

