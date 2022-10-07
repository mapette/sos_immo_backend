import Tinc from '../models/types_inc.js'


const tincById = (tinc) => {
    return Tinc.findByPk(tinc) 
}


export  {
    tincById,
 }