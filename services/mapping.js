import {
    mappList, saveMapping, mappingDestroyById,
} from '../data/DAO/mapping.js'
import Mapping from '../data/models/mapping.js'

const getByTemp = (request, response) => {
    const { session, params } = request
    if (session.isId === true && session.profil === 4) {
         mappList()
     .then(mapp => mapp.filter(m => m.mapping_temp === parseInt(params.id)))
            .then(list => response.send(list))
            .catch((err) => console.log(err))
    } 
}

const getOneMapping = (request, response) => {
    const { session, params, } = request
    if (session.isId === true && session.profil === 4) {
        mappList()
            .then(mapp => mapp.filter(m => m.mapping_id === parseInt(params.id)))
            .then(m => response.send(m))
            .catch((err) => console.log(err))
    }
}

const creaOneMapping = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        const mapping = Mapping.build({
            mapping_temp: body.temp,
            mapping_tinc: 3,//body.tinc,
        })
        saveMapping(mapping)
            .then(map => response.send({ id: map.mapping_id }))
            .catch((err) => { 
                console.log(err)
                response.status(500).json(err) })
    }
}

const deleteOneMapping = (request, response) => {
    const { session, params } = request
    if (session.isId == true && session.profil == 4) {
        mappingDestroyById(params.id) 
        response.send(params.id)
    }
}


export  {
    getByTemp, getOneMapping,
    creaOneMapping,
    deleteOneMapping,
}

