import { Sequelize } from 'sequelize'

// export default new Sequelize(process.env.sos_immo_db,'root',process.env.mySqlPw, {
//     dialect: 'mysql',
//     host: 'localhost',
//     logging: false,
// })

export default new Sequelize('sos_immo_test','root',process.env.mySqlPw, {
    dialect: 'mysql',
    host: 'localhost',
    logging: false,
})
