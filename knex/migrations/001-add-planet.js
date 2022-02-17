exports.up = knex =>
  knex.schema.createTable('planet', table => {
    table.increments('id').notNullable()
    table.integer('star_id').notNullable()
    table.text('name').notNullable()

    table
      .foreign('star_id')
      .references('star.id')
      .onDelete('CASCADE')
      .withKeyName('fk__planet__star_id')
  })

exports.down = knex =>
  knex.schema.dropTable('planet')
