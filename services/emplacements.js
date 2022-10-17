import serveStatic from 'serve-static'
import {
    empListWithDetails,
    empListNewInc,
 } from '../data/DAO/emplacements.js'

const getAllEmp = (request, response) => {
    const {session,} = request
    if (session.isId === true && session.profil === 4) {
        empListWithDetails()
        .then(empList => response.send(empList))
        .catch((err)=> console.log(err))
    }
}

const getAllEmpAndTinc = (request, response) => {
    const {session,} = request
    if (session.isId == true) {
        empListNewInc()
        .then(empList => response.send(empList))
        .catch((err)=> console.log(err))
    }
}

export  {
    getAllEmpAndTinc,
    getAllEmp, 
}

