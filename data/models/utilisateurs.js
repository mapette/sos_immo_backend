import  {addDaysToDate} from './../../services/lib_serveur.js'
import {DataTypes,} from 'sequelize'
import db from '../../db/db.js'

const Utilisateurs = db.define('utilisateurs',{
    ut_uuid : {
        type : DataTypes.STRING,
        primaryKey : true,
        allowNull : false,
    },
    ut_id : {
        type : DataTypes.STRING,
        allowNull : false,
        unique: true,
    },
    ut_nom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    ut_prenom : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    ut_presta : {
        type : DataTypes.INTEGER.UNSIGNED,
        allowNull : true,
        defaultValue: null,
    },
    ut_tel : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    ut_mail : {
        type : DataTypes.STRING,
        allowNull : false,
    },
    ut_date_deb : {
        type : DataTypes.DATE,
        allowNull : false,
        defaultValue: new Date(),
    },
    ut_date_exp : {
        type : DataTypes.DATE,
        allowNull : true,
        defaultValue: null,
    },
    ut_mdp : {
        type : DataTypes.STRING,
        allowNull : true,
    },
    ut_mdp_exp : {
        type : DataTypes.DATE,
        allowNull : true,
        defaultValue: addDaysToDate(new Date(), 90),
    },
    hab_profil : {      // dernier en date
        type: DataTypes.VIRTUAL,
    },
    hab_uuid : {        // dernier en date
        type: DataTypes.VIRTUAL,
    },
    presta_libelle : {  
        type: DataTypes.VIRTUAL,
    },
    presta_nom : {     
        type: DataTypes.VIRTUAL,
    },
},{
    freezeTableName: true,
    timestamps: false,
})

export default Utilisateurs
