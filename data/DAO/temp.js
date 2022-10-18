import Temp from '../models/types_emp.js'

const tempList = () => {
    return Temp.findAll()
}

const tempById = (id) => {
    return Temp.findByPk(id)
}



export  {
    tempList, 
    tempById,
 }