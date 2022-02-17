exports.up = knex =>
  knex.schema.createTable('star', table => {
    table.increments('id').notNullable()
    table.text('name').notNullable()
  })

exports.down = knex =>
  knex.schema.dropTable('star')
