import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Temp = db.define('types_emp',{
    temp_id : {
        type : DataTypes.INTEGER.UNSIGNED,
        primaryKey : true,
        autoIncrement : true,
        allowNull : false,
    },
    temp_nom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Temp
