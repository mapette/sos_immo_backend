import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Mapping = db.define('mapping_inc_emp',{
    mapping_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    mapping_tinc : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    mapping_temp : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Mapping
