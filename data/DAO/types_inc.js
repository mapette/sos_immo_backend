import {Sequelize, } from 'sequelize'
import Tinc from '../models/types_inc.js'
import db from '../../db/db.js'

const tincList = () => {
    return Tinc.sync({ alter: false }).then(() => {
        return db.query(`
            SELECT tinc.*, presta_nom, presta_libelle
            FROM types_inc tinc, presta
            WHERE tinc_presta = presta_id
            ORDER BY tinc_nom`,
            {
                type: Sequelize.QueryTypes.SELECT,
                model: Tinc,
            })
    })
}

const tincById = (tinc) => {
    return Tinc.findByPk(tinc)
}

const savetinc = (data) => {
    return data.save()
}

export {
    tincList, tincById,
    savetinc,
}
