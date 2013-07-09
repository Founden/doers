Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  updatedAt: DS.attr('date')
  lastUpdate: DS.attr('string')
  userNicename: DS.attr('string')
  authorNicename: DS.attr('string')

  user: DS.belongsTo('Doers.User')
  author: DS.belongsTo('Doers.User')
  project: DS.belongsTo('Doers.Project')
  parentBoard: DS.belongsTo('Doers.Board')

  branches: DS.hasMany('Doers.Board')

  cards: DS.hasMany('Doers.Card')

  slug: (->
    'board-' + @get('id')
  ).property('id')
