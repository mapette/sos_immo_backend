import {Sequelize, } from 'sequelize'
import db from '../../db/db.js'
import Incidents from '../models/incidents.js'

const newInc = (inc) => {return Incidents.create(inc)}
const saveInc = (data) => {return data.save()}

const incById = (id) => {return Incidents.findByPk(id) }

const incListWithDetails = () => {
    return Incidents.sync({alter:false}).then(()=>{
        return db.query(`
        SELECT inc.*, emp_id, emp_nom, emp_etage, tinc_id, tinc_nom, presta_id, presta_nom
                    FROM incidents inc, emplacements, types_inc, presta
                    WHERE inc_emp = emp_id 
                        AND inc_presta = presta_id
                        AND inc_tinc = tinc_id
                    ORDER BY inc_fin_date asc, inc_affect_date asc, inc_signal_date asc`,
        {type: Sequelize.QueryTypes.SELECT,
            model: Incidents,
        })
    })
}

export  {
    newInc, 
    saveInc,
    incById,
    incListWithDetails,
  }
  