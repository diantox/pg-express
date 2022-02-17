exports.up = knex =>
  knex.schema.createTable('satellite', table => {
    table.increments('id').notNullable()
    table.integer('planet_id').notNullable()
    table.text('name').notNullable()

    table
      .foreign('planet_id')
      .references('planet.id')
      .onDelete('CASCADE')
      .withKeyName('fk__satellite__planet_id')
  })

exports.down = knex =>
  knex.schema.dropTable('satellite')
