import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Tinc = db.define('types_inc',{
    tinc_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    tinc_nom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    tinc_presta : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Tinc
