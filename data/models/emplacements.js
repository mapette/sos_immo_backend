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
    temp_nom : {
         type: DataTypes.VIRTUAL,
    },
    presta_libelle : {
        type: DataTypes.VIRTUAL,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Emplacements
