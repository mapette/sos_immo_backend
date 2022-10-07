import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Emplacements = db.define('emplacements',{
    emp_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    emp_etage : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    emp_nom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    emp_temp : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    tinc_id : {
         type: DataTypes.VIRTUAL,
    },
    tinc_nom : {
        type: DataTypes.VIRTUAL,
    },
    presta_libelle : {
        type: DataTypes.VIRTUAL,
    },
               //emp_id, emp_etage, emp_nom, tinc_id, tinc_nom, presta_libelle
},{
    freezeTableName: true,
    timestamps: false,
})

export default Emplacements
