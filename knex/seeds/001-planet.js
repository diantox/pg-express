exports.seed = knex =>
  knex('planet').insert([
    {
      id: 0,
      star_id: 0,
      name: 'Mercury'
    },
    {
      id: 1,
      star_id: 0,
      name: 'Venus'
    },
    {
      id: 2,
      star_id: 0,
      name: 'Earth'
    },
    {
      id: 3,
      star_id: 0,
      name: 'Mars'
    },
    {
      id: 4,
      star_id: 0,
      name: 'Jupiter'
    },
    {
      id: 5,
      star_id: 0,
      name: 'Saturn'
    },
    {
      id: 6,
      star_id: 0,
      name: 'Uranus'
    },
    {
      id: 7,
      star_id: 0,
      name: 'Neptune'
    },
    {
      id: 8,
      star_id: 1,
      name: 'Proxima Centauri B'
    },
    {
      id: 9,
      star_id: 1,
      name: 'Proxima Centauri C'
    }
  ])
