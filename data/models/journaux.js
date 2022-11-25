import {DataTypes, Op} from 'sequelize'
import db from '../../db/db.js'

const Journaux = db.define('journaux',{
    jrn_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    jrn_inc : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    jrn_date : {
        type : DataTypes.DATE,
        allowNull : false,
    
    },
    jrn_msg : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    jrn_imm : {
        type : DataTypes.TINYINT,
        allowNull : false,
        defaultValue: false,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Journaux


