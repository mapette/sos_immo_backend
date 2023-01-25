import {
    empListWithDetails,
    empListNewInc,
    empById,
    saveEmp,
} from '../data/DAO/emplacements.js'
import Emplacements from '../data/models/emplacements.js'
import { ExceptionUtilisateur } from './cl_exept.js'

const getAllEmp = (request, response) => {
    const { session, } = request
    try {
        if (session.isId === true) {
            empListWithDetails()
                .then(empList => response.send(empList))
                .catch((err) => console.log(err))
        } else { throw new ExceptionUtilisateur() }
    } catch (err) { response.status(666).json(err) }
}

const getOneEmp = (request, response) => {
    const { session, params, } = request

    if (session.isId === true && session.profil === 4) {
        empListWithDetails()
            .then(empList => empList.filter(emp => emp.emp_id === parseInt(params.id)))
            .then(empList => response.send(empList[0]))
            .catch((err) => console.log(err))
    }
}

const getAllEmpAndTinc = (request, response) => {
    const { session, } = request
    try {
        if (session.isId == true) {
            empListNewInc()
                .then(empList => response.send(empList))
                .catch((err) => console.log(err))
        } else { throw new ExceptionUtilisateur() }
    } catch (err) { response.status(666).json(err) }
}

const creaOneEmp = (request, response) => {
    const { session, body } = request
    try {
        if (session.isId == true & session.profil == 4) {
            const emp = Emplacements.build({
                emp_nom: body.emp_nom,
                emp_etage: body.emp_etage,
                emp_temp: body.emp_temp,
            })
            saveEmp(emp)
                .then(emp => response.send({ id: emp.emp_id }))
                .catch((err) => { response.status(500).json(err) })
        } else { throw new ExceptionUtilisateur() }
    } catch (err) { response.status(666).json(err) }
}

const updateOneEmp = (request, response) => {
    const { session, body } = request
    try {
        if (session.isId == true & session.profil == 4) {
            empById(body.emp_id)
                .then(emp => {
                    emp.emp_etage = body.emp_etage
                    emp.emp_nom = body.emp_nom
                    emp.emp_temp = body.emp_temp
                    return saveEmp(emp)
                })
                .then(emp => response.send({ id: emp.emp_id }))
                .catch((err) => { response.status(500).json(err) })
        } else { throw new ExceptionUtilisateur() }
    } catch (err) { response.status(666).json(err) }
}


export  {
    getAllEmpAndTinc,
    getAllEmp, 
    getOneEmp,
    creaOneEmp,
    updateOneEmp,
}

