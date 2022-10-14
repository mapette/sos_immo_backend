import {Sequelize, } from 'sequelize'
import db from '../../db/db.js'
import Utilisateurs from '../models/utilisateurs.js'

// login
const userLogin = (data) => {
    return Utilisateurs.sync({alter:false}).then(()=>{
        return db.query(`
            SELECT ut_nom, ut_prenom, ut_id, ut_uuid, ut_mdp_exp 
                hab_uuid, hab_profil 
            FROM habilitations, utilisateurs
            WHERE ut_id = :id AND ut_mdp = :mdp 
            AND hab_date_exp is null
            AND hab_ut = ut_uuid`,
        {type: Sequelize.QueryTypes.SELECT,
            model: Utilisateurs, 
            replacements: {id: data.id, mdp: data.mdp},
        })
    })
}

// get
const OneUserWithoutDetails = (mail) => {
    return Utilisateurs.findAll({
       where: {ut_mail : mail}
    })
}

const userList = () => {
    return Utilisateurs.sync({alter:false}).then(()=>{
        return db.query(`
        SELECT ut.*, presta_nom, presta_libelle, hab_profil, hab_date_exp
        FROM utilisateurs ut LEFT JOIN presta ON (ut_presta = presta_id), habilitations  
        WHERE hab_ut = ut_uuid and hab_date_exp IS NULL`,
        {type: Sequelize.QueryTypes.SELECT})
    })
}
const userByUuid = (uuid) => {
    return Utilisateurs.sync({alter:false}).then(()=>{
        return db.query(`
            SELECT ut.*, presta_nom, presta_libelle, hab_uuid, hab_profil
            FROM utilisateurs ut LEFT JOIN presta ON (ut_presta = presta_id), habilitations  
            WHERE hab_ut = ut_uuid 
                AND hab_date_exp IS NULL
                AND ut_uuid = :id`,
        {type: Sequelize.QueryTypes.SELECT,
            replacements: {id: uuid},
            model: Utilisateurs,
        })
    }) 
}

// maj
const saveUser = (data) => {
    return data.save()
}

export  {
   userLogin, 
   userList,
   userByUuid,
   OneUserWithoutDetails,
   saveUser,

}



