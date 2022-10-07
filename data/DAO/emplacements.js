import {Sequelize, } from 'sequelize'
import db from '../../db/db.js'
import Emplacements from '../models/emplacements.js'

const empListNewInc = () => {
    return Emplacements.sync({alter:false}).then(()=>{
        return db.query(`
        SELECT emp_id, emp_etage, emp_nom, tinc_id, tinc_nom, presta_libelle
        FROM emplacements, types_emp, mapping_inc_emp, types_inc, presta
        WHERE temp_id = emp_temp
            AND mapping_tinc = tinc_id
            AND mapping_temp = temp_id
            AND presta_id = tinc_presta
        ORDER BY emp_etage, emp_nom, presta_libelle`,
        {type: Sequelize.QueryTypes.SELECT,
            model: Emplacements,
        })
    })

}


export  {
    empListNewInc,
 
 }