import {empListNewInc, } from '../data/DAO/emplacements.js'

const getAllEmp = (request, response) => {
    const {session,} = request
    if (session.isId == true) {
        empListNewInc()
        .then(empList => response.send(empList))
        .catch((err)=> console.log(err))
    }
}

export  {
    getAllEmp, 
}

