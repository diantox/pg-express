exports.seed = knex =>
  knex('satellite').insert([
    {
      id: 0,
      planet_id: 2,
      name: 'Moon'
    },
    {
      id: 1,
      planet_id: 3,
      name: 'Phobos'
    },
    {
      id: 2,
      planet_id: 3,
      name: 'Deimos'
    }
  ])
