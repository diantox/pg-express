/** @file Load the configuration. */

const { join, normalize } = require('path')

const knexConfig = {
  client: 'pg',
  connection: {
    host: process.env.POSTGRES_HOST,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB
  },
  seeds: {
    directory: normalize(join(__dirname, '../seeds'))
  },
  migrations: {
    directory: normalize(join(__dirname, '../migrations'))
  }
}

module.exports = knexConfig
