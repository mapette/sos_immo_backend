import { Sequelize } from 'sequelize'

export default new Sequelize('sos_immo','root',process.env.mySqlPw, {
    dialect: 'mysql',
    host: 'localhost'
})
