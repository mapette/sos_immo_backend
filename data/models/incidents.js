import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Incidents = db.define('incidents',{
    inc_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    inc_emp : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    inc_tinc : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    inc_presta : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    inc_signal_ut : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    inc_signal_date : {
        type : DataTypes.DATE,
    },
    inc_affect_ut : {
        type : DataTypes.STRING,
        allowNull : true,
    },
    inc_affect_date : {
        type : DataTypes.DATE,
        allowNull : true,
        defaultValue: null,
    },
    inc_fin_date : {
        type : DataTypes.DATE,
        allowNull : true,
        defaultValue: null,
    },
    inc_cloture_date : {
        type : DataTypes.DATE,
        allowNull : true,
        defaultValue: null,
    },
    emp_id : {
        type : DataTypes.VIRTUAL,
    },
    emp_etage : {
        type : DataTypes.VIRTUAL
    },
    tinc_id : {
        type : DataTypes.VIRTUAL
    },
    tinc_nom : {
        type : DataTypes.VIRTUAL
    },
    presta_id : {
        type : DataTypes.VIRTUAL
    },
    presta_nom : {
        type : DataTypes.VIRTUAL
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Incidents
