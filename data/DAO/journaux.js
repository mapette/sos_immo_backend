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

const jrnImmExclude = (jrn) => {
    return jrn.filter(line => line.jrn_imm === 0)
}

export  {
    NewLine, 
    jrnByInc,
    jrnImmExclude,
 
 }