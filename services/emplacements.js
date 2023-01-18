import Emplacements from '../data/models/emplacements.js'
import Temp from '../data/models/types_emp.js'
import {
    empListWithDetails,
    empListNewInc,
    empById,
    saveEmp,
} from '../data/DAO/emplacements.js'
import {
    tempList,
    tempById,
    saveTemp,
} from '../data/DAO/temp.js'


//// emplacements ////
const getAllEmp = (request, response) => {
    const { session, } = request
    if (session.isId === true) {
        empListWithDetails()
            .then(empList => response.send(empList))
            .catch((err) => console.log(err))
    }
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
    if (session.isId == true) {
        empListNewInc()
            .then(empList => response.send(empList))
            .catch((err) => console.log(err))
    }
}

const creaOneEmp = (request, response) => {
    const {session, body} = request
    if (session.isId == true & session.profil == 4) {
        const emp = Emplacements.build({
            emp_nom: body.emp_nom,
            emp_etage: body.emp_etage,
            emp_temp : body.emp_temp,
        })
        saveEmp(emp)
            .then(emp => response.send({ id: emp.emp_id }))
            .catch((err) => { response.status(500).json(err) })
    }
}

const updateOneEmp = (request, response) => {
    const { session, body } = request
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
    }
}


//// types d'emplacement ////
const getAllTemp = (request, response) => {
    const { session, } = request
    if (session.isId === true && session.profil === 4) {
        tempList()
            .then(list => list.sort((x, y) => {
                if (x.temp_nom < y.temp_nom) {return -1}
                if (x.temp_nom > y.temp_nom) {return 1}
                return 0
            }))
            .then(list => response.send(list))
            .catch((err) => console.log(err))
    }
}

const getOneTemp = (request, response) => {
    const { session, params, } = request
    if (session.isId === true && session.profil === 4) {
        tempById(params.id)
            .then(temp => response.send(temp))
            .catch((err) => console.log(err))
    }
}

const creaOneTemp = (request, response) => {
    const {session, body} = request
    if (session.isId == true & session.profil == 4) {
        const temp = Temp.build({
            temp_nom: body.temp_nom,
        })
        saveTemp(temp)
            .then(temp => response.send({ id: temp.temp_id }))
            .catch((err) => { response.status(500).json(err) })
    }
}

const updateOneTemp = (request, response) => {
    const { session, body } = request
    if (session.isId == true & session.profil == 4) {
        tempById(body.temp_id)
            .then(temp => {
                temp.temp_nom = body.temp_nom
                return saveTemp(temp)
            })
            .then(temp => response.send({ id: temp.temp_id }))
            .catch((err) => { response.status(500).json(err) })
    }
}
export  {
    getAllEmpAndTinc,
    getAllEmp, 
    getOneEmp,
    creaOneEmp,
    updateOneEmp,
    getAllTemp,
    getOneTemp, 
    creaOneTemp,
    updateOneTemp,
}

