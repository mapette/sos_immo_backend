import {DataTypes, Op} from 'sequelize'
import db from '../../db/db.js'

const Habilitations = db.define('habilitations',{
    hab_uuid : {
        type : DataTypes.STRING,
        primaryKey : true,
        allowNull : false,
    },
    hab_ut : {
        type : DataTypes.STRING,
        allowNull : false,
        unique: true,
    },
    hab_profil : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : false,
    },
    hab_date_deb : {
        type : DataTypes.DATE,
        allowNull : false,
    },
    hab_date_exp : {
        type : DataTypes.DATE,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Habilitations


