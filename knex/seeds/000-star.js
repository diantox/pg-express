exports.seed = knex =>
  knex('star').insert([
    {
      id: 0,
      name: 'Sol'
    },
    {
      id: 1,
      name: 'Proxima Centauri'
    }
  ])
