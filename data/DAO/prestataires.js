import Presta from '../models/prestataires.js'

const prestaList = () => {
    return Presta.findAll()
}

const prestaById = (id) => {
    return Presta.findByPk(id) 
}

const savePresta = (data) => {
    return data.save()
}

export  {
    prestaList, 
    prestaById,
    savePresta,
 }