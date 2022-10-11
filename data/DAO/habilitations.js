import Habilitations from '../models/habilitations.js'


const newHab = (hab) => {
    Habilitations.create(hab)
}

const habByUserUuid = (uuid) => {
    return Habilitations.findAll({
        where: { hab_ut: uuid },
        order:[['hab_date_deb', 'DESC']]
    })
}

const habByUuid = (uuid) => {
    return Habilitations.findByPk(uuid)
}

const saveHab = (data) => {
    return data.save()
}


export  {
    newHab,
    habByUserUuid,
    habByUuid,
    saveHab,

 }

 
