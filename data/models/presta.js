import {DataTypes, Op} from 'sequelize'
import db from '../../db/db.js'

const Presta = db.define('presta',{
    presta_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    presta_nom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    presta_libelle : {
        type : DataTypes.STRING,
        allowNull : false,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Presta


