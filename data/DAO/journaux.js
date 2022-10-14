import Journaux from '../models/journaux.js'

const NewLine = (line) => {
    console.log(line)
    return Journaux.create(line)
}

const jrnByInc = (inc_id) => {
    return Journaux.findAll({
        where: { jrn_inc : inc_id },
        order:[['jrn_id', 'ASC']],
    })
}

export  {
    NewLine, 
    jrnByInc,
 }