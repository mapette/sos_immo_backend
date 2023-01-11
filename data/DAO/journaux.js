import Journaux from '../models/journaux.js'

const NewLine = (line) => {
    return Journaux.create(line)
}

const jrnByInc = (inc_id) => {
    return Journaux.findAll({
        where: { jrn_inc : inc_id },
        order:[['jrn_id', 'ASC']],
    })
}

const jrnDestroyByInc = (inc_id) => {
    return Journaux.destroy({
        where: { jrn_inc : inc_id },
    })
}

export  {
    NewLine, 
    jrnByInc,
    jrnDestroyByInc,
 }
 