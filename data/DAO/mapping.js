import {Sequelize, } from 'sequelize'
import db from '../../db/db.js'
import Mapping from '../models/mapping.js'

// const mappList = () => {
//     return Mapping.findAll()
// }
const mappList = () => {
    return Mapping.sync({ alter: false }).then(() => {
        return db.query(`
            SELECT m.*, tinc_nom, temp_nom, presta_nom, presta_libelle
            FROM mapping_inc_emp m, presta, types_inc, types_emp
            WHERE mapping_tinc = tinc_id 
                AND mapping_temp = temp_id 
                AND presta_id = tinc_presta
            ORDER BY presta_nom, tinc_nom`,
            {
                type: Sequelize.QueryTypes.SELECT,
                model: Mapping,
            })
    })
}

const mappingById = (id) => {
    return Mapping.findByPk(id)
}

const saveMapping = (data) => {
    return data.save()
}

const mappingDestroyById = (id) => {
    return Mapping.destroy({
        where: { mapping_id : id },
    })
}

export {
    mappList, mappingById,
    saveMapping,
    mappingDestroyById,
}
