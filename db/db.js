import { Sequelize } from 'sequelize'

export default new Sequelize(process.env.db_sos_immo_test,
                            process.env.mySqlUser,
                            process.env.mySqlPw, {
            dialect: 'mysql',
            host: 'localhost',
            logging: false,
})


              // db_sos_immo_prod / db_sos_immo_test
